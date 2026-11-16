/// Store product IDs. These must match App Store Connect, Google Play Console
/// and the backend (A-Muslim-Matchmaker-Backend/subscriptions/products.py).
class IapProducts {
  IapProducts._();

  static const String monthly = 'amm_premium_monthly';
  static const String annual = 'amm_premium_annual';
  static const String topUp = 'amm_topup_3_connections';

  static const Set<String> subscriptions = {monthly, annual};
  static const Set<String> all = {monthly, annual, topUp};

  /// Shown until the store returns localized prices.
  static const Map<String, String> fallbackPrices = {
    monthly: '£14.99',
    annual: '£124.99',
    topUp: '£5',
  };

  // Links required on the paywall by App Store guideline 3.1.2.
  static const String termsOfUseUrl =
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
  static const String privacyPolicyUrl =
      'https://amuslimmatchmaker.com/privacy-policy/';

  static const String appleManageUrl =
      'https://apps.apple.com/account/subscriptions';
  static const String androidPackage = 'com.muslimmatchmaker.app';
  static String googleManageUrl(String? productId) => productId == null
      ? 'https://play.google.com/store/account/subscriptions'
      : 'https://play.google.com/store/account/subscriptions?sku=$productId&package=$androidPackage';
}
