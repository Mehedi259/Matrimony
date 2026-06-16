import 'package:flutter/material.dart';

class CountryPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CountryPhoneField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  State<CountryPhoneField> createState() => _CountryPhoneFieldState();
}

class _CountryPhoneFieldState extends State<CountryPhoneField> {
  String _selectedFlag = '🇬🇧';
  String _selectedCode = '+44';

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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Phone Number',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              // Country Code Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    icon: const Icon(Icons.arrow_drop_down, size: 24),
                    // Show flag + code in dropdown items
                    items: _flagToCode.keys.map((flag) {
                      return DropdownMenuItem(
                        value: flag,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(flag, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(_flagToCode[flag]!, 
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (flag) {
                      if (flag != null) {
                        setState(() {
                          _selectedFlag = flag;
                          _selectedCode = _flagToCode[flag] ?? '+44';
                        });
                      }
                    },
                  ),
                ),
              ),
              // Phone Number Input
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  validator: widget.validator,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
                    hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
