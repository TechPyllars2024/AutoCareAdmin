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
                              columnSpacing: constraints.maxWidth / 8,
                              columns: const [
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Location')),
                                DataColumn(label: Text('File')),
                              ],
                              rows: const [
                                DataRow(cells: [
                                  DataCell(StatusDropdown(initialStatus: 'In Review')),
                                  DataCell(Text('example1@example.com')),
                                  DataCell(Text('Location 1')),
                                  DataCell(Text('File 1')),
                                ]),
                                DataRow(cells: [
                                  DataCell(StatusDropdown(initialStatus: 'Verified')),
                                  DataCell(Text('example2@example.com')),
                                  DataCell(Text('Location 2')),
                                  DataCell(Text('File 2')),
                                ]),
                                DataRow(cells: [
                                  DataCell(StatusDropdown(initialStatus: 'Rejected')),
                                  DataCell(Text('example3@example.com')),
                                  DataCell(Text('Location 3')),
                                  DataCell(Text('File 3')),
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
      items: <String>['In Review', 'Verified', 'Rejected']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}