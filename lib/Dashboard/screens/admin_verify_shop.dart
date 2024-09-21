import 'package:flutter/material.dart';
import '../widgets/dashboard_sidebar.dart';

class AdminVerifyShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DashboardSidebar(),
          Expanded(
            child: Column(
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
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Shop Name')),
                                DataColumn(label: Text('Submission Date')),
                                DataColumn(label: Text('File')),
                              ],
                              rows: const [
                                DataRow(cells: [
                                  DataCell(StatusDropdown(initialStatus: 'Under Review')),
                                  DataCell(Text('example1@example.com')),
                                  DataCell(Text('Shop1')),
                                  DataCell(Text('September 19, 2024')),
                                  DataCell(Text('File1.pdf')),
                                ]),
                                DataRow(cells: [
                                  DataCell(StatusDropdown(initialStatus: 'Verified')),
                                  DataCell(Text('example2@example.com')),
                                  DataCell(Text('Shop1')),
                                  DataCell(Text('September 20, 2024')),
                                  DataCell(Text('File2.pdf')),
                                ]),
                                DataRow(cells: [
                                  DataCell(StatusDropdown(initialStatus: 'Rejected')),
                                  DataCell(Text('example3@example.com')),
                                  DataCell(Text('Shop1')),
                                  DataCell(Text('September 21, 2024')),
                                  DataCell(Text('File3.pdf')),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          child: Text(value),
        );
      }).toList(),
    );
  }
}