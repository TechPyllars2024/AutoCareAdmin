import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/dashboard_sidebar.dart';
import '../widgets/verify_shop_filter.dart';

class AdminVerifyShop2 extends StatefulWidget {
  @override
  _AdminVerifyShop2State createState() => _AdminVerifyShop2State();
}

class _AdminVerifyShop2State extends State<AdminVerifyShop2> {
  String? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;

  void _onFilterChanged(String? status, DateTime? startDate, DateTime? endDate) {
    setState(() {
      _selectedStatus = status;
      _startDate = startDate;
      _endDate = endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout with Drawer
          return Scaffold(
            appBar: AppBar(
              title: const Text('AutoCare Admin'),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            drawer: DashboardSidebar(),
            body: _buildContent(),
          );
        } else {
          // Desktop layout with permanent sidebar
          return Scaffold(
            body: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: DashboardSidebar(),
                ),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Verify Shops',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: VerifyShopFilter(onFilterChanged: _onFilterChanged),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columnSpacing: constraints.maxWidth / 18,
                      columns: const [
                        DataColumn(
                          label: SizedBox(
                            width: 150, // Fixed width for the column
                            child: Text('Status'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 150, // Fixed width for the column
                            child: Text('Email'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 150, // Fixed width for the column
                            child: Text('Shop Name'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 150, // Fixed width for the column
                            child: Text('Submission Date'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 150, // Fixed width for the column
                            child: Text('File'),
                          ),
                        ),
                      ],
                      rows: _getFilteredRows(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<DataRow> _getFilteredRows() {
    final DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    final rows = [
      DataRow(cells: [
        const DataCell(StatusDropdown(initialStatus: 'Under Review')),
        const DataCell(Text('example1@example.com')),
        const DataCell(Text('Car Shop ni Rap')),
        DataCell(Text(dateFormat.format(DateTime(2024, 9, 4)))),
        const DataCell(Text('File1.pdf')),
      ]),
      DataRow(cells: [
        const DataCell(StatusDropdown(initialStatus: 'Verified')),
        const DataCell(Text('example2@example.com')),
        const DataCell(Text('Paint and Accessories ni Paul')),
        DataCell(Text(dateFormat.format(DateTime(2024, 9, 6)))),
        const DataCell(Text('File2.pdf')),
      ]),
      DataRow(cells: [
        const DataCell(StatusDropdown(initialStatus: 'Rejected')),
        const DataCell(Text('example3@example.com')),
        const DataCell(Text('Car Shop sng Lambunao')),
        DataCell(Text(dateFormat.format(DateTime(2024, 9, 7)))),
        const DataCell(Text('File3.pdf')),
      ]),
      DataRow(cells: [
        const DataCell(StatusDropdown(initialStatus: 'Under Review')),
        const DataCell(Text('example1@example.com')),
        const DataCell(Text('Car Shop Car Shop Car Shop Car Shop')),
        DataCell(Text(dateFormat.format(DateTime(2024, 9, 9)))),
        const DataCell(Text('File1.pdf')),
      ]),
      DataRow(cells: [
        const DataCell(StatusDropdown(initialStatus: 'Verified')),
        const DataCell(Text('example2@example.com')),
        const DataCell(Text('Shop1')),
        DataCell(Text(dateFormat.format(DateTime(2024, 9, 20)))),
        const DataCell(Text('File2.pdf')),
      ]),
      DataRow(cells: [
        const DataCell(StatusDropdown(initialStatus: 'Rejected')),
        const DataCell(Text('example3@example.com')),
        const DataCell(Text('Shop1')),
        DataCell(Text(dateFormat.format(DateTime(2024, 9, 12)))),
        const DataCell(Text('File3.pdf')),
      ]),
      DataRow(cells: [
        const DataCell(StatusDropdown(initialStatus: 'Under Review')),
        const DataCell(Text('example1@example.com')),
        const DataCell(Text('Shop12')),
        DataCell(Text(dateFormat.format(DateTime(2024, 9, 4)))),
        const DataCell(Text('File1.pdf')),
      ]),
      DataRow(cells: [
        const DataCell(StatusDropdown(initialStatus: 'Verified')),
        const DataCell(Text('example2@example.com')),
        const DataCell(Text('Shop1')),
        DataCell(Text(dateFormat.format(DateTime(2024, 9, 6)))),
        const DataCell(Text('File2.pdf')),
      ]),
      DataRow(cells: [
        const DataCell(StatusDropdown(initialStatus: 'Rejected')),
        const DataCell(Text('example3@example.com')),
        const DataCell(Text('Shop1')),
        DataCell(Text(dateFormat.format(DateTime(2024, 9, 7)))),
        const DataCell(Text('File3.pdf')),
      ]),
    ];

    return rows.where((row) {
      final status = (row.cells[0].child as StatusDropdown).initialStatus;
      final date = dateFormat.parse((row.cells[3].child as Text).data!);

      final statusMatches = _selectedStatus == null || _selectedStatus == status;
      final dateMatches = (_startDate == null || date.isAfter(_startDate!)) &&
          (_endDate == null || date.isBefore(_endDate!));

      return statusMatches && dateMatches;
    }).toList();
  }
}

class StatusDropdown extends StatefulWidget {
  final String initialStatus;

  const StatusDropdown({required this.initialStatus});

  @override
  _StatusDropdownState createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {
  late String _selectedStatus;

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
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedStatus,
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue!;
        });
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
    );
  }
}