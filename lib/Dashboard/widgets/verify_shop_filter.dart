import 'package:flutter/material.dart';

class VerifyShopFilter extends StatefulWidget {
  final Function(String?) onFilterChanged;

  const VerifyShopFilter({required this.onFilterChanged});

  @override
  _VerifyShopFilterState createState() => _VerifyShopFilterState();
}

class _VerifyShopFilterState extends State<VerifyShopFilter> {
  String? _selectedStatus;

  void _resetFilters() {
    setState(() {
      _selectedStatus = null;
    });
    widget.onFilterChanged(_selectedStatus);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xffffe599);
      case 'Verified':
        return const Color(0xffd9ead3);
      case 'Rejected':
        return const Color(0xfff4cccc);
      default:
        return Colors.transparent;
    }
  }

  TextStyle _getStatusTextStyle(String status) {
    switch (status) {
      case 'Pending':
        return TextStyle(color: Colors.orange[700], fontWeight: FontWeight.bold);
      case 'Verified':
        return TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold);
      case 'Rejected':
        return TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold);
      default:
        return const TextStyle();
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
              widget.onFilterChanged(_selectedStatus);
            },
            items: <String>['Pending', 'Verified', 'Rejected']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  color: _getStatusColor(value),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    value,
                    style: _getStatusTextStyle(value),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      const SizedBox(height: 12.0),
      ElevatedButton(
        onPressed: _resetFilters,
        child: const Text('Reset Filters'),
      ),
    ];
  }
}