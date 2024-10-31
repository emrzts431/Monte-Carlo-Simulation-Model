import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static String SDK_LOCATION = "icara_sdk_location";
  static String BUCKET_NAMES = "bucket_names";
  static String BUCKET_1_CATEGORIES = "bucket_1_categories";
  static String BUCKET_2_CATEGORIES = "bucket_2_categories";
  static String GLOBAL_CORRELATIONS = "global_correlations";
  static String DEGREES_OF_FREEDOM = "degrees_of_freedom";
  static String MODEL_ASSUMPTIONS_WORST_CASE = "model_assumptions_worst_case";
  static String MODEL_ASSUMPTIONS_TYPICAL_CASE =
      "model_assumptions_typical_case";
  static String MODEL_ASSUMPTIONS_SEVERITY_MODEL =
      "model_assumptions_severity_model";

  static Future setSdkLocation(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SDK_LOCATION, path ?? "");
  }

  static Future<String?> getSdkLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SDK_LOCATION);
  }

  static Future updateBucketNames(String? name1, String? name2) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(BUCKET_NAMES, "$name1,$name2");
  }

  static Future<List<String>> getBucketNames() async {
    final prefs = await SharedPreferences.getInstance();
    String? buckets = prefs.getString(BUCKET_NAMES);
    if (buckets == null || buckets.isEmpty) {
      return ['K-Factors', 'Loss Types'];
    } else {
      return buckets.split(',');
    }
  }

  static Future setBucketCategories(
      List<String> categories, String bucket) async {
    final prefs = await SharedPreferences.getInstance();
    String categoriesString = "";
    for (String category in categories) {
      categoriesString += '$category,';
    }
    categoriesString =
        categoriesString.substring(0, categoriesString.length - 1);
    await prefs.setString(bucket, categoriesString);
  }

  static Future<List<String>> getBucketCategories(String bucket) async {
    final prefs = await SharedPreferences.getInstance();
    String? categories = prefs.getString(bucket);
    if (categories == null || categories.isEmpty) {
      if (bucket == BUCKET_1_CATEGORIES) {
        return ['K-AUM', 'K-CMH', 'K-COH', 'K-Other'];
      } else {
        return ['IF', 'EF', 'EPWS', 'CPBP', 'DPA', 'BDSF', 'EDPM'];
      }
    } else {
      return categories.split(',');
    }
  }

  static Future setGlobalCorrelation(double correlation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(GLOBAL_CORRELATIONS, correlation);
  }

  static Future<double> getGlobalCorrelation() async {
    final prefs = await SharedPreferences.getInstance();
    double? correlation = prefs.getDouble(GLOBAL_CORRELATIONS);
    return correlation ?? 0.5;
  }

  static Future setDegreesOfFreedom(int freedom) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(DEGREES_OF_FREEDOM, freedom);
  }

  static Future<int> getDegreesOfFreedom() async {
    final prefs = await SharedPreferences.getInstance();
    int? degreesOfFreedom = prefs.getInt(DEGREES_OF_FREEDOM);
    return degreesOfFreedom ?? 10;
  }

  static Future setModelAssumptions(
      double defOfWorstCase, double defOfTypicalCase, String sevModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(MODEL_ASSUMPTIONS_WORST_CASE, defOfWorstCase);
    await prefs.setDouble(MODEL_ASSUMPTIONS_TYPICAL_CASE, defOfTypicalCase);
    await prefs.setString(MODEL_ASSUMPTIONS_SEVERITY_MODEL, sevModel);
  }

  static Future<Map<String, dynamic>> getModelAssumptions() async {
    final prefs = await SharedPreferences.getInstance();
    double defWorstCase = prefs.getDouble(MODEL_ASSUMPTIONS_WORST_CASE) ?? 0.95;
    double defTypicalCase =
        prefs.getDouble(MODEL_ASSUMPTIONS_TYPICAL_CASE) ?? 0.75;
    String sevModel =
        prefs.getString(MODEL_ASSUMPTIONS_SEVERITY_MODEL) ?? "LogNormal";
    return {
      'worstCase': defWorstCase,
      'typicalCase': defTypicalCase,
      'sevModel': sevModel,
    };
  }
}
