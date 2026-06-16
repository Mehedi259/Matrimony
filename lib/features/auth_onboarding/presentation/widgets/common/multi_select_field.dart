import 'package:flutter/material.dart';

class MultiSelectField extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> selectedValues;
  final Function(List<String>) onChanged;
  final String searchHint;

  const MultiSelectField({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.searchHint = 'Search...',
  });

  @override
  State<MultiSelectField> createState() => _MultiSelectFieldState();
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredOptions = [];
  List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _selectedItems = List.from(widget.selectedValues);
    _searchController.addListener(_filterOptions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOptions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options
            .where((option) => option.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _toggleSelection(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
      widget.onChanged(_selectedItems);
    });
  }

  void _clearAll() {
    setState(() {
      _selectedItems.clear();
      widget.onChanged(_selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        const SizedBox(height: 16),
        
        // Search Field
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: widget.searchHint,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
        
        // Selected count and Clear button
        if (_selectedItems.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select (${_selectedItems.length})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _clearAll,
                child: Text(
                  'Clear all',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Selected chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedItems.map((item) {
              return Chip(
                label: Text(item),
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _toggleSelection(item),
                side: BorderSide.none,
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                deleteIconColor: Theme.of(context).primaryColor,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        
        // Options List
        Container(
          constraints: const BoxConstraints(maxHeight: 250),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredOptions.length,
            itemBuilder: (context, index) {
              final option = _filteredOptions[index];
              final isSelected = _selectedItems.contains(option);
              
              return InkWell(
                onTap: () => _toggleSelection(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.05)
                        : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: index < _filteredOptions.length - 1
                            ? Colors.grey[200]!
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isSelected 
                            ? Theme.of(context).primaryColor 
                            : Colors.grey[400],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
