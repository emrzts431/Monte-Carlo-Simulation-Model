import 'package:ICARA/pages/capital_modeling.dart';
import 'package:ICARA/pages/home_page.dart';
import 'package:ICARA/pages/raroc.dart';
import 'package:ICARA/pages/insurance_pricing.dart';
import 'package:ICARA/pages/settings.dart';
import 'package:flutter/material.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff00B0F0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/mc_risk_modelling.png',
                  scale: 5,
                ),
                const Text(
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
                MaterialPageRoute(
                    builder: (context) => const CapitalModeling()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline),
            title: const Text('RAROC'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Raroc()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.stacked_line_chart),
            title: const Text('Insurance Pricing'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InsurancePricing()),
              );
            },
          ),
          const Divider(
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark_rounded),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
