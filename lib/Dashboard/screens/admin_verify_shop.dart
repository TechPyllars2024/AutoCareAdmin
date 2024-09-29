import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/verifyShop_service.dart';
import '../widgets/dashboard_sidebar.dart';

class AdminVerifyShopScreen extends StatefulWidget {
  const AdminVerifyShopScreen({super.key});

  @override
  State<AdminVerifyShopScreen> createState() => _AdminVerifyShopScreenState();
}

class _AdminVerifyShopScreenState extends State<AdminVerifyShopScreen> {
  String? _selectedStatus;
  List<Map<String, dynamic>> _shopsData = [];
  final VerifyShopService _verifyShopService = VerifyShopService();

  @override
  void initState() {
    super.initState();
    _fetchVerificationData();
  }

  // void _onFilterChanged(String? status) {
  //   setState(() {
  //     _selectedStatus = status;
  //   });
  // }

  Future<void> _fetchVerificationData() async {
    List<Map<String, dynamic>> data = await _verifyShopService.fetchVerificationData();
    setState(() {
      _shopsData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: VerifyShopFilter(onFilterChanged: _onFilterChanged),
        //   ),
        // ),
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
                        DataColumn(label: SizedBox(width: 100, child: Text('Status'))),
                        DataColumn(label: SizedBox(width: 100, child: Text('Shop Name'))),
                        DataColumn(label: SizedBox(width: 100, child: Text('Shop Address'))),
                        DataColumn(label: SizedBox(width: 100, child: Text('Submission Date'))),
                        DataColumn(label: SizedBox(width: 100, child: Text('Submission Time'))),
                        DataColumn(label: SizedBox(width: 100, child: Text('File'))),
                      ],
                      rows: _buildRows(),
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

  List<DataRow> _buildRows() {
    return _shopsData.map((shop) {
      return DataRow(cells: [
        DataCell(StatusDropdown(
          initialStatus: shop['verificationStatus'] ?? '',
          shopId: shop['uid'] ?? '',
        )),
        DataCell(Text(shop['shopName'] ?? 'N/A')),
        DataCell(Text(shop['location'] ?? 'N/A')),
        DataCell(Text(shop['dateSubmitted'] ?? 'N/A')),
        DataCell(Text(shop['timeSubmitted'] ?? 'N/A')),
        DataCell(
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(shop['fileUrl'] ?? '');
              if (await canLaunch(url.toString())) {
                await launch(url.toString());
              } else {
                // Handle the error (e.g., show a snackbar)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch URL')),
                );
              }
            },
            child: Text(
              _shortenUrl(shop['fileUrl'] ?? 'N/A'),
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ),
      ]);
    }).toList();
  }

  String _shortenUrl(String url) {
    const int maxLength = 30; // Maximum length before shortening
    if (url.length > maxLength) {
      return '${url.substring(0, maxLength)}...'; // Shorten the URL
    }
    return url; // Return full URL if it's short enough
  }

}


class StatusDropdown extends StatefulWidget {
  final String initialStatus;
  final String shopId;

  const StatusDropdown({
    super.key,
    required this.initialStatus,
    required this.shopId,
  });

  @override
  State<StatusDropdown> createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {
  late String _selectedStatus;
  bool _isLoading = false;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      _isLoading = true; // Set loading state
    });
      await VerifyShopService().updateVerificationStatus(widget.shopId, newStatus);
      await VerifyShopService().updateVerificationStatusForValidationModel(widget.shopId, newStatus);
    setState(() {
      _isLoading = false; // Reset loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Initial Status: $_selectedStatus');

    List<String> statuses = ['Pending', 'Verified', 'Rejected'];

    // Debugging log to check dropdown items
    print('Dropdown Items: $statuses');

    // Ensure the initial status is one of the items
    if (!statuses.contains(_selectedStatus)) {
      print('Warning: Initial status $_selectedStatus is not in the dropdown items.');
      _selectedStatus = statuses.first; // Fallback to the first status if not found
    }

    return _isLoading
        ? const CircularProgressIndicator() // Show loading indicator
        : DropdownButton<String>(
      value: _selectedStatus,
      onChanged: (String? newValue) async {
        if (newValue != null) {
          setState(() {
            _selectedStatus = newValue;
          });
          await _updateStatus(newValue);
        }
      },
      items: statuses.map<DropdownMenuItem<String>>((String value) {
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
    );
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
}

