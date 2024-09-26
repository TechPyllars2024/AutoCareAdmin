import 'package:flutter/material.dart';
import 'package:autocareadmin/Authentication/screens/admin_login.dart';
import 'package:autocareadmin/Dashboard/screens/admin_verify_shop.dart';

class DashboardSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Auto',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Care',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.storefront_rounded),
            title: const Text('Verify Shops'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminVerifyShop()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminLogin()),
              );
            },
          ),
        ],
      ),
    );
  }
}