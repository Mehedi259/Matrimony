import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart' show ReplacementMode;
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/iap_products.dart';
import '../../core/network/api_client.dart';

/// Server-side subscription state (GET /api/subscriptions/status/).
class SubscriptionStatus {
  final String plan;
  final DateTime? end;
  final bool autoRenewing;
  final String? storePlatform;
  final String? productId;
  final int bonusRequests;

  const SubscriptionStatus({
    required this.plan,
    this.end,
    this.autoRenewing = false,
    this.storePlatform,
    this.productId,
    this.bonusRequests = 0,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) =>
      SubscriptionStatus(
        plan: (json['subscription_plan'] ?? 'free').toString(),
        end: DateTime.tryParse(json['subscription_end']?.toString() ?? ''),
        autoRenewing: json['auto_renewing'] == true,
        storePlatform: json['store_platform']?.toString(),
        productId: json['product_id']?.toString(),
        bonusRequests: (json['bonus_requests'] as num?)?.toInt() ?? 0,
      );

  bool get isPaid => plan == 'monthly' || plan == 'annual';
}

/// Owns the store connection: loads products, starts purchases, sends each
/// completed purchase to the backend for verification, then finishes it with
/// the store. Purchases are only finished after the server has accepted them,
/// so an interrupted purchase is retried on the next app launch.
class PurchaseProvider extends ChangeNotifier {
  PurchaseProvider({InAppPurchase? iap}) : _iap = iap ?? InAppPurchase.instance;

  final InAppPurchase _iap;
  final ApiClient _api = ApiClient();
  StreamSubscription<List<PurchaseDetails>>? _sub;

  bool _initialized = false;
  bool _storeAvailable = false;
  bool _loadingProducts = false;
  bool _restoring = false;
  String? _busyProductId;
  String? _errorMessage;
  String? _successMessage;
  SubscriptionStatus? _status;
  final Map<String, ProductDetails> _products = {};

  /// Called after a purchase is applied so other providers (profile, usage) refresh.
  VoidCallback? onEntitlementChanged;

  bool get storeAvailable => _storeAvailable;
  bool get loadingProducts => _loadingProducts;
  bool get restoring => _restoring;
  String? get busyProductId => _busyProductId;
  bool get isBusy => _busyProductId != null || _restoring;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  SubscriptionStatus? get status => _status;
  String get currentPlan => _status?.plan ?? 'free';

  ProductDetails? product(String id) => _products[id];
  String priceFor(String id) =>
      _products[id]?.price ?? IapProducts.fallbackPrices[id] ?? '';

  String get _platform => Platform.isIOS ? 'apple' : 'google';

  Future<void> init() async {
    if (_initialized) {
      await refreshStatus();
      return;
    }
    _initialized = true;

    // Listen before anything else so purchases left unfinished from a
    // previous session are delivered and verified.
    _sub = _iap.purchaseStream.listen(
      _onPurchases,
      onError: (Object e) => _setError('Store error: $e'),
    );

    await Future.wait([loadProducts(), refreshStatus()]);
  }

  Future<void> loadProducts() async {
    _loadingProducts = true;
    notifyListeners();
    try {
      _storeAvailable = await _iap.isAvailable();
      if (!_storeAvailable) return;
      final response = await _iap.queryProductDetails(IapProducts.all);
      if (response.error != null) {
        debugPrint('IAP product query error: ${response.error}');
      }
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('IAP products not found in store: ${response.notFoundIDs}');
      }
      _products
        ..clear()
        ..addEntries(response.productDetails.map((p) => MapEntry(p.id, p)));
    } catch (e) {
      debugPrint('IAP loadProducts failed: $e');
    } finally {
      _loadingProducts = false;
      notifyListeners();
    }
  }

  Future<void> refreshStatus() async {
    try {
      final res = await _api.get(ApiConstants.subscriptionStatus);
      _status = SubscriptionStatus.fromJson(
          Map<String, dynamic>.from(res.data as Map));
      notifyListeners();
    } catch (e) {
      debugPrint('Subscription status failed: $e');
    }
  }

  Future<void> buy(String productId) async {
    clearMessages();
    if (isBusy) return;

    if (!_storeAvailable) {
      _setError(Platform.isIOS
          ? 'The App Store is not available right now. Please try again later.'
          : 'Google Play is not available right now. Please try again later.');
      return;
    }
    final product = _products[productId];
    if (product == null) {
      await loadProducts();
      if (_products[productId] == null) {
        _setError('This plan is not available yet. Please try again later.');
        return;
      }
    }

    _busyProductId = productId;
    notifyListeners();

    try {
      final details = _products[productId]!;
      final isSubscription = IapProducts.subscriptions.contains(productId);
      if (isSubscription && Platform.isAndroid) await _loadGooglePastPurchases();
      final PurchaseParam param = _purchaseParamFor(details);

      final started = isSubscription
          ? await _iap.buyNonConsumable(purchaseParam: param)
          : await _iap.buyConsumable(purchaseParam: param, autoConsume: true);
      if (!started) {
        _busyProductId = null;
        notifyListeners();
      }
      // Result arrives on purchaseStream → _onPurchases.
    } on PlatformException catch (e) {
      _busyProductId = null;
      _setError(e.message ?? 'Could not start the purchase.');
    } catch (e) {
      _busyProductId = null;
      _setError('Could not start the purchase: $e');
    }
  }

  PurchaseParam _purchaseParamFor(ProductDetails details) {
    // On Android, switching between Monthly and Annual must replace the old
    // subscription instead of stacking a second one.
    if (Platform.isAndroid &&
        IapProducts.subscriptions.contains(details.id)) {
      final old = _status?.storePlatform == 'google' ? _status?.productId : null;
      if (old != null && old != details.id) {
        final oldPurchase = _lastGooglePurchases[old];
        if (oldPurchase != null) {
          return GooglePlayPurchaseParam(
            productDetails: details,
            changeSubscriptionParam: ChangeSubscriptionParam(
              oldPurchaseDetails: oldPurchase,
              replacementMode: ReplacementMode.withTimeProration,
            ),
          );
        }
      }
    }
    return PurchaseParam(productDetails: details);
  }

  final Map<String, GooglePlayPurchaseDetails> _lastGooglePurchases = {};

  Future<void> _loadGooglePastPurchases() async {
    try {
      final addition =
          _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await addition.queryPastPurchases();
      for (final p in response.pastPurchases) {
        _lastGooglePurchases[p.productID] = p;
      }
    } catch (e) {
      debugPrint('queryPastPurchases failed: $e');
    }
  }

  Future<void> restore() async {
    clearMessages();
    if (isBusy) return;
    _restoring = true;
    notifyListeners();
    try {
      await _iap.restorePurchases();
      // Restored purchases arrive on the stream. Give them a moment, then
      // refresh from the server whether or not anything was found.
      await Future<void>.delayed(const Duration(seconds: 3));
      await refreshStatus();
      if (_errorMessage == null) {
        _successMessage = (_status?.isPaid ?? false)
            ? 'Your subscription has been restored.'
            : 'No active subscription was found for this store account.';
      }
    } catch (e) {
      _setError('Restore failed: $e');
    } finally {
      _restoring = false;
      notifyListeners();
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p is GooglePlayPurchaseDetails) {
        _lastGooglePurchases[p.productID] = p;
      }
      switch (p.status) {
        case PurchaseStatus.pending:
          _busyProductId = p.productID;
          notifyListeners();
          break;
        case PurchaseStatus.canceled:
          if (_busyProductId == p.productID) _busyProductId = null;
          await _finish(p);
          notifyListeners();
          break;
        case PurchaseStatus.error:
          if (_busyProductId == p.productID) _busyProductId = null;
          _setError(p.error?.message ?? 'The purchase could not be completed.');
          await _finish(p);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyAndFinish(p);
          break;
      }
    }
  }

  Future<void> _verifyAndFinish(PurchaseDetails p) async {
    final wasUserInitiated = _busyProductId == p.productID;
    try {
      final res = await _api.post(
        ApiConstants.subscriptionVerify,
        data: {
          'platform': _platform,
          'product_id': p.productID,
          'verification_data': p.verificationData.serverVerificationData,
          'transaction_id': p.purchaseID,
        },
      );
      _status = SubscriptionStatus.fromJson(
          Map<String, dynamic>.from(res.data as Map));
      await _finish(p);
      if (wasUserInitiated) {
        _successMessage = p.productID == IapProducts.topUp
            ? '3 extra connection requests added.'
            : 'Welcome to ${p.productID == IapProducts.annual ? 'Annual' : 'Monthly'}! Your plan is active.';
      }
      onEntitlementChanged?.call();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final detail = (e.response?.data is Map)
          ? (e.response!.data as Map)['detail']?.toString()
          : null;
      if (code == 400 || code == 409) {
        // Store says it's invalid, or it belongs to another account:
        // finishing is safe and stops it being re-delivered forever.
        await _finish(p);
      }
      // Network / 5xx: leave unfinished so the store re-delivers it later.
      if (wasUserInitiated || code == 409) {
        _setError(detail ??
            'We could not confirm your purchase yet. It will be applied automatically — please check again shortly.');
      }
    } catch (e) {
      if (wasUserInitiated) {
        _setError(
            'We could not confirm your purchase yet. It will be applied automatically — please check again shortly.');
      }
    } finally {
      if (_busyProductId == p.productID) _busyProductId = null;
      notifyListeners();
    }
  }

  Future<void> _finish(PurchaseDetails p) async {
    if (p.pendingCompletePurchase) {
      try {
        await _iap.completePurchase(p);
      } catch (e) {
        debugPrint('completePurchase failed: $e');
      }
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  /// Clear per-user state on logout.
  void reset() {
    _status = null;
    clearMessages();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
