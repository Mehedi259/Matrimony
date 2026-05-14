import 'package:flutter/material.dart';

class CustomRadioGroup extends StatefulWidget {
  final String label;
  final List<String> options;
  final String selected;

  const CustomRadioGroup({super.key, required this.label, required this.options, required this.selected});

  @override
  State<CustomRadioGroup> createState() => _CustomRadioGroupState();
}

class _CustomRadioGroupState extends State<CustomRadioGroup> {
  late String _currentSelected;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: widget.options.map((option) {
            bool isSelected = option == _currentSelected;
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Row(
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: _currentSelected,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (v) {
                      setState(() {
                        _currentSelected = v!;
                      });
                    },
                  ),
                  Text(option),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
