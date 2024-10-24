import 'package:ICARA/pages/capital_modeling.dart';
import 'package:ICARA/pages/home_page.dart';
import 'package:ICARA/pages/risk_inputs.dart';
import 'package:ICARA/pages/settings.dart';
import 'package:flutter/material.dart';

class CustomNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/mc_risk_modelling.png',
                  scale: 5,
                ),
                Text(
                  'Monte Carlo Plus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Capital Modeling'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CapitalModeling()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline),
            title: const Text('RAROC'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RiskInputs()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.stacked_line_chart),
            title: const Text('Insurance Pricing'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RiskInputs()),
              );
            },
          ),
          const Divider(
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle navigation here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              ); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark_rounded),
            title: const Text('Help'),
            onTap: () {
              // Handle navigation here
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
