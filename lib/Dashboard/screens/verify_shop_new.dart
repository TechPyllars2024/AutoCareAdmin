import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VerifyShopNew extends StatelessWidget {
  final List<Map<String, dynamic>> verificationData = [
    {
      'shopName': 'Car Shop ni Rap',
      'location': 'St. Barbara, Iloilo City',
      'dateSubmitted': DateTime(2024, 9, 4),
      'timeSubmitted': DateTime(2024, 9, 4, 10, 30),
      'file': 'File1.pdf',
    },
    {
      'shopName': 'Paint and Accessories ni Paul',
      'location': 'Calinog, Iloilo City',
      'dateSubmitted': DateTime(2024, 9, 6),
      'timeSubmitted': DateTime(2024, 9, 6, 14, 45),
      'file': 'File2.pdf',
    },
    // Add more data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: verificationData.length,
        itemBuilder: (context, index) {
          final data = verificationData[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity, // Full width
                  height: 150.0, // Custom height
                  padding: const EdgeInsets.all(18.0), // Custom padding
                  child: ElevatedButton(
                    onPressed: () => _showDetailsDialog(context, data),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Rounded corners
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data['shopName'],
                          style: const TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data['location'],
                          style: const TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        Text(
                          '${DateFormat('MMMM d, yyyy').format(data['dateSubmitted'])} ${DateFormat('hh:mm a').format(data['timeSubmitted'])}',
                          style: const TextStyle(fontSize: 14.0, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ), // Add spacing between buttons
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
    const TextStyle detailTextStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.black,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Shop Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Shop Name: ${data['shopName']}', style: detailTextStyle),
              Text('Location: ${data['location']}', style: detailTextStyle),
              Text('Date Submitted: ${DateFormat('MMMM d, yyyy').format(data['dateSubmitted'])}', style: detailTextStyle),
              Text('Time Submitted: ${DateFormat('hh:mm a').format(data['timeSubmitted'])}', style: detailTextStyle),
              Text('File: ${data['file']}', style: detailTextStyle),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}