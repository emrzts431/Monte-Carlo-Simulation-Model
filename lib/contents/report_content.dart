import 'dart:math';

import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:ICARA/widgets/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportContentState();
}

class ReportContentState extends State<ReportContent> {
  //kfactors
  List<Color> randomColorsKFactor = [];

  //lossTypes
  List<Color> randomColorsLossTypes = [];

  double maxValue = 0.0;

  double curValue = -1;

  List<double> riskRankings = [];
  List<String>? riskDescriptions = [];

  List<double> kFactors = [];
  List<double> lossTypes = [];
  List<double> lossesFromRisks = [];

  List<String> kFactorNames = [];
  List<String> lossTypeNames = [];

  final _pageController = PageController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      try {
        var riskRankingsStrings = await locator<NavigationService>()
            .navigatorKey
            .currentContext
            ?.read<IcarasdkViewModel>()
            .readFileLines(
                locator<NavigationService>().navigatorKey.currentContext ??
                    context,
                'VariablePercentiles.txt');
        var kFactorsStrings = await locator<NavigationService>()
            .navigatorKey
            .currentContext
            ?.read<IcarasdkViewModel>()
            .readFileLines(
                locator<NavigationService>().navigatorKey.currentContext ??
                    context,
                'BUPercentiles.txt');

        var lossTypesStrings = await locator<NavigationService>()
            .navigatorKey
            .currentContext
            ?.read<IcarasdkViewModel>()
            .readFileLines(
                locator<NavigationService>().navigatorKey.currentContext ??
                    context,
                'GroupPercentiles.txt');
        var lossesFromRisksStrings = await locator<NavigationService>()
            .navigatorKey
            .currentContext
            ?.read<IcarasdkViewModel>()
            .readFileLines(
                locator<NavigationService>().navigatorKey.currentContext ??
                    context,
                'VariableAggregate.txt');
        riskDescriptions = await locator<NavigationService>()
            .navigatorKey
            .currentContext
            ?.read<IcarasdkViewModel>()
            .readFileLines(
                locator<NavigationService>().navigatorKey.currentContext ??
                    context,
                'var1_desc.txt');

        riskRankings = riskRankingsStrings
                ?.map((e) =>
                    e == 'NaN' ? 0.0 : double.parse(e.replaceAll(',', '.')))
                .toList() ??
            [];
        if (riskRankings.isNotEmpty) {
          maxValue = riskRankings.last;
          riskRankings.remove(riskRankings.last);
        }
        kFactors = kFactorsStrings
                ?.map((e) =>
                    e == 'NaN' ? 0.0 : double.parse(e.replaceAll(',', '.')))
                .toList() ??
            [];
        lossTypes = lossTypesStrings
                ?.map((e) =>
                    e == 'NaN' ? 0.0 : double.parse(e.replaceAll(',', '.')))
                .toList() ??
            [];
        lossesFromRisks = lossesFromRisksStrings
                ?.map((e) =>
                    e == 'NaN' ? 0.0 : double.parse(e.replaceAll(',', '.')))
                .toList() ??
            [];

        kFactorNames = await Preferences.getBucketCategories(
            Preferences.BUCKET_1_CATEGORIES);
        lossTypeNames = await Preferences.getBucketCategories(
            Preferences.BUCKET_2_CATEGORIES);
        randomColorsKFactor = List.generate(
            kFactorNames.length,
            (index) => Color((Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0));
        randomColorsLossTypes = List.generate(
            lossTypeNames.length,
            (index) => Color((Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0));

        setState(() {});
      } on Exception catch (error, stacktrace) {
        AppLogger.instance.error(error, stacktrace);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.8,
        child: !dataLoaded()
            ? const Text('No available data')
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        ),
                        child: const Text('Tables'),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      ElevatedButton(
                        onPressed: () => _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        ),
                        child: const Text('Graphs'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _page1(),
                        _page2(),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _page1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _factorsListView(kFactorNames, kFactors, 'K-Factors'),
              _factorsListView(lossTypeNames, lossTypes, 'Loss Types'),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          _riskRankingsListView(),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget _factorsListView(
      List<String> names, List<double> values, String listName) {
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width * 0.33,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(30),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
        ),
        itemCount: names.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              leading: const SizedBox.shrink(),
              title: Text(
                listName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                'Loss in Millions',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListTile(
            minTileHeight: 0,
            minVerticalPadding: 0,
            leading: Text("${(index - 1) + 1}"),
            title: Text(
              names[index - 1],
            ),
            trailing:
                Text('${(values[index - 1] / 1000000).toStringAsFixed(2)}M'),
          );
        },
      ),
    );
  }

  Widget _riskRankingsListView() {
    List<double> sortedList = List.from(riskRankings);

    sortedList.sort((a, b) {
      if (a > b) {
        return -1;
      } else if (a == b) {
        return 0;
      } else {
        return 1;
      }
    });
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width * 0.705,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(30),
      child: ListView.separated(
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                minTileHeight: 0,
                minVerticalPadding: 6,
                title: Text(
                  'Risks',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  'Loss in millions',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            int indexOfRisk = riskRankings.indexOf(sortedList[index]);

            return ListTile(
              minTileHeight: 0,
              minVerticalPadding: 4,
              leading: Text('Risk ${indexOfRisk + 1}'),
              title: Text('${riskDescriptions?[indexOfRisk]}'),
              trailing:
                  Text('${(sortedList[index] / 1000000).toStringAsFixed(2)}M'),
            );
          },
          separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
              ),
          itemCount: riskRankings.length),
    );
  }

  Widget _page2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (kFactors.any((e) => e != 0))
                _getPie(
                  kFactors,
                  kFactorNames,
                  randomColorsKFactor,
                  'Breakdown into K-Factors (Loss in Millions)',
                ),
              if (lossTypes.any((e) => e != 0))
                _getPie(
                  lossTypes,
                  lossTypeNames,
                  randomColorsLossTypes,
                  'Breakdown into Loss Types (Loss in Millions)',
                ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          _getBarPlotRiskRankings(),
          const SizedBox(
            height: 40,
          ),
          _getHistogram(),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _getBarPlotRiskRankings() {
    return riskRankings.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(30),
            height: 500,
            width: MediaQuery.of(context).size.width * 0.73,
            child: Column(
              children: [
                Text(
                  'Risk Ranking',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY:
                          ((riskRankings.reduce(max)) / 1000000).ceilToDouble(),
                      //minY: riskRankings?.reduce(min),
                      barGroups: riskRankings
                          .map(
                            (value) => BarChartGroupData(
                              x: riskRankings.indexOf(value) + 1,
                              barRods: [
                                BarChartRodData(
                                  toY: value / 1000000,
                                  borderRadius: BorderRadius.zero,
                                  color: const Color.fromARGB(255, 4, 63, 112),
                                  width: 45,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }

  Widget _getPie(List<double> values, List<String> titles, List<Color> colors,
      String chartTitle) {
    return values.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(30),
            height: 400,
            width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  chartTitle,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  flex: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              curValue = -1;
                              return;
                            }
                            curValue = pieTouchResponse
                                    .touchedSection!.touchedSection?.value ??
                                -1;
                          });
                        },
                      ),
                      sections: values.map((v) {
                        int index = values.indexOf(v);
                        bool onSection = v == curValue;
                        return PieChartSectionData(
                          radius: onSection ? 65 : 50,
                          value: v,
                          title: onSection
                              ? (v / 1000000).toStringAsFixed(2)
                              : titles[index],
                          color: colors[index],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: titles
                      .map(
                        (n) => Indicator(
                          color: colors[titles.indexOf(n)],
                          text: n,
                          isSquare: true,
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          )
        : const CircularProgressIndicator();
  }

  Widget _getHistogram() {
    List<int> bins = [];
    if (lossesFromRisks.isNotEmpty) {
      bins = _createHistogramBins(lossesFromRisks, 50);
    }
    return lossesFromRisks.isNotEmpty && bins.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(30),
            height: 500,
            width: MediaQuery.of(context).size.width * 0.73,
            child: Column(
              children: [
                Text(
                  'Losses from all Risks',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      groupsSpace: 10,
                      maxY: (bins.reduce(max)).ceil().toDouble(),
                      gridData: FlGridData(
                        show: true,
                        checkToShowHorizontalLine: (value) => value % 10 == 0,
                        getDrawingHorizontalLine: (value) => const FlLine(
                          color: Colors.black,
                          strokeWidth: 1,
                        ),
                        drawVerticalLine: false,
                      ),
                      barGroups: bins.asMap().entries.map((entry) {
                        int index = entry.key;
                        int frequency = entry.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: (frequency).toDouble(),
                              borderRadius: BorderRadius.zero,
                              color: const Color.fromARGB(255, 4, 63, 112),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ))
        : const CircularProgressIndicator();
  }

  List<int> _createHistogramBins(List<double> data, int binCount) {
    try {
      double minValue = 0;

      double binSize = ((maxValue) - (minValue)) / binCount;
      List<int> bins = List.filled(binCount, 0);

      for (var value in data) {
        int binIndex = (((value) - (minValue)) / binSize).floor();
        if (binIndex >= binCount) binIndex = 49;

        bins[binIndex]++;
      }

      return bins;
    } on UnsupportedError catch (e, stacktrace) {
      //AppLogger.instance.error(e, stacktrace);
      return List.filled(binCount, 0);
    }
  }

  bool dataLoaded() {
    return riskRankings.isNotEmpty &&
        kFactors.isNotEmpty &&
        lossesFromRisks.isNotEmpty &&
        lossesFromRisks.isNotEmpty;
  }
}
