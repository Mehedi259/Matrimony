import 'package:flutter/material.dart';

class CustomCheckboxItem extends StatefulWidget {
  final String label;
  final bool initialValue;

  const CustomCheckboxItem({super.key, required this.label, this.initialValue = false});

  @override
  State<CustomCheckboxItem> createState() => _CustomCheckboxItemState();
}

class _CustomCheckboxItemState extends State<CustomCheckboxItem> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _isChecked,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (v) {
                setState(() {
                  _isChecked = v ?? false;
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(width: 12),
          Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
