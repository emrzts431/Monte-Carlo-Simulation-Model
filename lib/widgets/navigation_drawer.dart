import 'package:ICARA/contents/correlation_inputs_content.dart';
import 'package:ICARA/pages/capital_modeling.dart';
import 'package:ICARA/pages/home_page.dart';
import 'package:ICARA/pages/raroc.dart';
import 'package:ICARA/pages/insurance_pricing.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
//import 'package:ICARA/pages/settings.dart';
import 'package:flutter/material.dart';

import 'package:ICARA/dialogs/bucket_names_dialog.dart';
import 'package:ICARA/dialogs/bucket_1_categories_dialog.dart';
import 'package:ICARA/dialogs/bucket_2_categories_dialog.dart';
import 'package:ICARA/dialogs/degrees_of_freedom_dialog.dart';
import 'package:ICARA/dialogs/global_correlation_dialog.dart';
import 'package:ICARA/dialogs/model_assumption_dialog.dart';
import 'package:provider/provider.dart';

class CustomNavigationDrawer extends StatelessWidget {
  CustomNavigationDrawer({super.key});
  int currentIndex = 0;
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CapitalModeling(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline),
            title: const Text('RAROC'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Raroc()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.stacked_line_chart),
            title: const Text('Insurance Pricing'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const InsurancePricing()),
              );
            },
          ),
          const Divider(
            thickness: 1,
            indent: 15,
            endIndent: 15,
            color: Colors.grey,
          ),
          ExpansionTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              children: <Widget>[
                ListTile(
                  title: const Text("Bucket Names"),
                  leading: Image.asset(
                    'assets/icons/manageBucketSettings.png',
                    scale: 10,
                    width: 20,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const BucketNamesDialog();
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text("Bucket 1 Categories"),
                  leading: Image.asset(
                    'assets/icons/Sand_bucket.png',
                    scale: 10,
                    width: 18,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Bucket1CategoriesDialog();
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text("Bucket 2 Categories"),
                  leading: Image.asset(
                    'assets/icons/Sand_bucket.png',
                    scale: 10,
                    width: 20,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Bucket2CategoriesDialog();
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text("Global Corellation"),
                  leading: Image.asset(
                    'assets/icons/global_correlation.png',
                    scale: 10,
                    width: 20,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const GlobalCorrelationDialog();
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text("Degrees of Freedom"),
                  leading: Image.asset(
                    'assets/icons/degrees_of_freedom.png',
                    scale: 10,
                    width: 20,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const DegreesOfFreedomDialog();
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text("Model Assumptions"),
                  leading: Image.asset(
                    'assets/icons/model_assumption.png',
                    scale: 10,
                    width: 20,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ModelAssumptionDialog();
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text("Change SDK Location"),
                  leading: const Icon(Icons.edit),
                  onTap: () async =>
                      await context.read<IcarasdkViewModel>().pickSdkFile(),
                ),
              ]),
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
