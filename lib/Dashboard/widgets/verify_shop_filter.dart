import 'package:flutter/material.dart';

class VerifyShopFilter extends StatefulWidget {
  final Function(String?, DateTime?, DateTime?) onFilterChanged;

  const VerifyShopFilter({required this.onFilterChanged});

  @override
  _VerifyShopFilterState createState() => _VerifyShopFilterState();
}

class _VerifyShopFilterState extends State<VerifyShopFilter> {
  String? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;

  void _selectDate({required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      widget.onFilterChanged(_selectedStatus, _startDate, _endDate);
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = null;
      _startDate = null;
      _endDate = null;
    });
    widget.onFilterChanged(_selectedStatus, _startDate, _endDate);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Under Review':
        return Colors.yellow;
      case 'Verified':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return isMobile
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40), // Add spacing at the top
        ..._buildFilterWidgets(),
      ],
    )
        : Wrap(
      spacing: 10.0,
      runSpacing: 4.0,
      children: _buildFilterWidgets(),
    );
  }

  List<Widget> _buildFilterWidgets() {
    return [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.filter_list),
          const SizedBox(width: 8),
          DropdownButton<String>(
            hint: const Text('Select Status'),
            value: _selectedStatus,
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue;
              });
              widget.onFilterChanged(_selectedStatus, _startDate, _endDate);
            },
            items: <String>['Under Review', 'Verified', 'Rejected']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  color: _getStatusColor(value),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      const SizedBox(height: 12.0),
      ElevatedButton(
        onPressed: () => _selectDate(isStartDate: true),
        child: const Text('Select Start Date'),
      ),
      const SizedBox(height: 12.0),
      ElevatedButton(
        onPressed: () => _selectDate(isStartDate: false),
        child: const Text('Select End Date'),
      ),
      const SizedBox(height: 12.0),
      ElevatedButton(
        onPressed: _resetFilters,
        child: const Text('Reset Filters'),
      ),
    ];
  }
}