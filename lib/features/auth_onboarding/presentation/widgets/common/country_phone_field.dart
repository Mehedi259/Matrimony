import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final String hintText;
  final bool isRequired;
  final ValueChanged<String>? onChanged;

  const CountryPhoneField({
    super.key,
    required this.controller,
    this.validator,
    this.label = 'Phone Number',
    this.hintText = 'Phone number',
    this.isRequired = true,
    this.onChanged,
  });

  @override
  State<CountryPhoneField> createState() => _CountryPhoneFieldState();
}

class _CountryPhoneFieldState extends State<CountryPhoneField> {
  String _selectedFlag = '🇬🇧';
  final TextEditingController _localController = TextEditingController();
  bool _isSyncing = false;

  // Map of flag emoji to country code
  final Map<String, String> _flagToCode = {
    '🇦🇫': '+93', '🇦🇱': '+355', '🇩🇿': '+213', '🇦🇷': '+54', '🇦🇲': '+374',
    '🇦🇺': '+61', '🇦🇹': '+43', '🇦🇿': '+994', '🇧🇭': '+973', '🇧🇩': '+880',
    '🇧🇾': '+375', '🇧🇪': '+32', '🇧🇹': '+975', '🇧🇴': '+591', '🇧🇦': '+387',
    '🇧🇷': '+55', '🇧🇳': '+673', '🇧🇬': '+359', '🇰🇭': '+855', '🇨🇲': '+237',
    '🇨🇦': '+1', '🇨🇱': '+56', '🇨🇳': '+86', '🇨🇴': '+57', '🇨🇷': '+506',
    '🇭🇷': '+385', '🇨🇺': '+53', '🇨🇾': '+357', '🇨🇿': '+420', '🇩🇰': '+45',
    '🇪🇨': '+593', '🇪🇬': '+20', '🇪🇪': '+372', '🇪🇹': '+251', '🇫🇮': '+358',
    '🇫🇷': '+33', '🇬🇪': '+995', '🇩🇪': '+49', '🇬🇭': '+233', '🇬🇷': '+30',
    '🇭🇰': '+852', '🇭🇺': '+36', '🇮🇸': '+354', '🇮🇳': '+91', '🇮🇩': '+62',
    '🇮🇷': '+98', '🇮🇶': '+964', '🇮🇪': '+353', '🇮🇱': '+972', '🇮🇹': '+39',
    '🇯🇵': '+81', '🇯🇴': '+962', '🇰🇿': '+7', '🇰🇪': '+254', '🇰🇼': '+965',
    '🇱🇻': '+371', '🇱🇧': '+961', '🇱🇾': '+218', '🇱🇹': '+370', '🇱🇺': '+352',
    '🇲🇴': '+853', '🇲🇾': '+60', '🇲🇻': '+960', '🇲🇹': '+356', '🇲🇽': '+52',
    '🇲🇩': '+373', '🇲🇨': '+377', '🇲🇳': '+976', '🇲🇪': '+382', '🇲🇦': '+212',
    '🇲🇲': '+95', '🇳🇵': '+977', '🇳🇱': '+31', '🇳🇿': '+64', '🇳🇬': '+234',
    '🇰🇵': '+850', '🇳🇴': '+47', '🇴🇲': '+968', '🇵🇰': '+92', '🇵🇸': '+970',
    '🇵🇦': '+507', '🇵🇾': '+595', '🇵🇪': '+51', '🇵🇭': '+63', '🇵🇱': '+48',
    '🇵🇹': '+351', '🇶🇦': '+974', '🇷🇴': '+40', '🇷🇺': '+7', '🇸🇦': '+966',
    '🇷🇸': '+381', '🇸🇬': '+65', '🇸🇰': '+421', '🇸🇮': '+386', '🇿🇦': '+27',
    '🇰🇷': '+82', '🇪🇸': '+34', '🇱🇰': '+94', '🇸🇩': '+249', '🇸🇪': '+46',
    '🇨🇭': '+41', '🇸🇾': '+963', '🇹🇼': '+886', '🇹🇯': '+992', '🇹🇿': '+255',
    '🇹🇭': '+66', '🇹🇳': '+216', '🇹🇷': '+90', '🇹🇲': '+993', '🇺🇬': '+256',
    '🇺🇦': '+380', '🇦🇪': '+971', '🇬🇧': '+44', '🇺🇸': '+1', '🇺🇾': '+598',
    '🇺🇿': '+998', '🇻🇪': '+58', '🇻🇳': '+84', '🇾🇪': '+967',
  };

  @override
  void initState() {
    super.initState();
    _syncFromExternal();
    widget.controller.addListener(_onExternalChanged);
  }

  @override
  void didUpdateWidget(covariant CountryPhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onExternalChanged);
      _syncFromExternal();
      widget.controller.addListener(_onExternalChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onExternalChanged);
    _localController.dispose();
    super.dispose();
  }

  void _onExternalChanged() {
    if (_isSyncing) return;
    _syncFromExternal();
  }

  void _syncFromExternal() {
    final raw = widget.controller.text.trim();
    String nextFlag = _selectedFlag;
    String nextLocal = raw;

    if (raw.startsWith('+')) {
      final compact = raw.replaceAll(RegExp(r'\s+'), '');
      final sortedEntries = _flagToCode.entries.toList()
        ..sort((a, b) => b.value.length.compareTo(a.value.length));
      for (final entry in sortedEntries) {
        if (compact.startsWith(entry.value)) {
          if (entry.value == '+1' && compact != raw) {
            nextFlag = '🇺🇸';
          } else {
            nextFlag = entry.value == '+1' ? '🇺🇸' : entry.key;
          }
          nextLocal = compact
              .substring(entry.value.length)
              .replaceAll(RegExp(r'[^0-9]'), '');
          break;
        }
      }
    } else {
      nextLocal = raw.replaceAll(RegExp(r'[^0-9]'), '');
    }

    _isSyncing = true;
    if (_localController.text != nextLocal) {
      _localController.value = TextEditingValue(
        text: nextLocal,
        selection: TextSelection.collapsed(offset: nextLocal.length),
      );
    }
    if (mounted && _selectedFlag != nextFlag) {
      setState(() => _selectedFlag = nextFlag);
    } else {
      _selectedFlag = nextFlag;
    }
    _isSyncing = false;
  }

  void _syncToExternal() {
    if (_isSyncing) return;
    final digits = _localController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final code = _flagToCode[_selectedFlag] ?? '+44';
    final combined = digits.isEmpty ? '' : '$code$digits';
    _isSyncing = true;
    if (widget.controller.text != combined) {
      widget.controller.value = TextEditingValue(
        text: combined,
        selection: TextSelection.collapsed(offset: combined.length),
      );
    }
    _isSyncing = false;
    widget.onChanged?.call(combined);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            children: widget.isRequired
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : const [],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              // Country Code Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  border: Border(
                    right: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFlag,
                    isDense: true,
                    icon: const Icon(Icons.arrow_drop_down, size: 22),
                    // Show flag + code in dropdown items
                    items: _flagToCode.keys.map((flag) {
                      return DropdownMenuItem(
                        value: flag,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(flag, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(
                              _flagToCode[flag]!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (flag) {
                      if (flag != null) {
                        setState(() {
                          _selectedFlag = flag;
                        });
                        _syncToExternal();
                      }
                    },
                  ),
                ),
              ),
              // Phone Number Input
              Expanded(
                child: TextFormField(
                  controller: _localController,
                  validator: widget.validator == null
                      ? null
                      : (_) => widget.validator!(widget.controller.text),
                  onChanged: (_) => _syncToExternal(),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
