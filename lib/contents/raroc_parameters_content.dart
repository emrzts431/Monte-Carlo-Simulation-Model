import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class RarocParametersContent extends StatefulWidget {
  const RarocParametersContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return RarocParametersContentState();
  }
}

class RarocParametersContentState extends State<RarocParametersContent> {
  String _expectedReturn = '1000000';
  final _expectedReturnController = TextEditingController();

  @override
  void initState() {
    _expectedReturnController.text = _expectedReturn;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "RAROC Input",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 160,
                              child: Text("Expected Return p.a."),
                            ),
                            SizedBox(
                              width: 100,
                              height: 36,
                              child: TextField(
                                controller: _expectedReturnController,
                                onChanged: (value) {
                                  setState(() {
                                    _expectedReturn = value;
                                  });
                                },
                                cursorHeight: 16,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                      width: 1.4,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 14),
                                cursorColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: context.watch<IcarasdkViewModel>().isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton.icon(
                              icon: const Icon(
                                Icons.save,
                                size: 20,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Save",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 16),
                                backgroundColor: const Color(0xff00B0F0),
                                textStyle: GoogleFonts.poppins(fontSize: 16),
                              ),
                              onPressed: () {
                                try {
                                  context
                                          .read<IcarasdkViewModel>()
                                          .expectedReturn =
                                      double.parse(_expectedReturn);

                                  SnackbarHolder.showSnackbar(
                                      "Successfully saved expected return",
                                      false,
                                      context);
                                } on Exception catch (e, s) {
                                  AppLogger.instance.error(e, s);
                                  SnackbarHolder.showSnackbar(
                                      "Error while saving expected return",
                                      true,
                                      context);
                                }
                              },
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
