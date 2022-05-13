import 'dart:convert';

import 'package:capstone_mobile/component/overlayLoading.dart';
import 'package:capstone_mobile/util/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../component/logo.dart';
import '../component/progress.dart';
import '../configvar.dart';
import '../https/get.dart';
import '../https/post.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class EmailOtpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends State<EmailOtpPage> {
  final _otpForm = GlobalKey<FormState>();
  String? _otp = "";

  String _error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Logo.singleton(),
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProgressBar(
              total: totalProgress,
              current: currentProgress,
            ),
            Container(
              // alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: const Text("OTP Verification!!",
                        style: TextStyle(
                            color: Color(0xff22d2b0),
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    width: double.infinity,
                    child: const Text("Take a moment to verify your OTP",
                        style: TextStyle(
                            color: Color(0xff6758ea),
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                        "Please fill the field below with OTP code that we sent to",
                        style: TextStyle(
                            color: Color(0xff838383),
                            fontSize: 10,
                            fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      text: TextSpan(
                        text: "your registered email id ",
                        style: const TextStyle(
                            color: Color(0xff838383),
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                            text: Provider.of<Data>(context, listen: true)
                                .data!["emailID"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    width: double.infinity,
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _otpForm,
                      child: Column(
                        children: [
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'[\s]'))
                            ],
                            decoration: const InputDecoration(
                                labelText: "OTP",
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(193, 207, 207, 207))),
                            validator: (text) {
                              return RegExp(r'^\d+$').hasMatch(text ?? "")
                                  ? null
                                  : "Enter integers you fucker";
                            },
                            onChanged: (text) {
                              if (_error.isNotEmpty) {
                                setState(() {
                                  _error = "";
                                });
                              }
                              _otp = text;
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  RichText(
                      text: TextSpan(
                    text: _error.isEmpty ? "" : "Error: ",
                    style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w700),
                    children: <TextSpan>[
                      TextSpan(
                        text: _error,
                        style: TextStyle(
                          color: Colors.red.shade200,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _error = "";
          });
          if (_otpForm.currentState?.validate() ?? false) {
            // print(_ip);
            Map<String, dynamic> m = {
              "OTPReceived": {"OTP": _otp},
              "stage": "1_three"
            };
            BuildPayloadWithLoanInfoAndApplicantInfo(m);
            Provider.of<Data>(context, listen: false).updatedata(
                Provider.of<Data>(context, listen: false).data!..addAll(m));
            print(Provider.of<Data>(context, listen: false).data);

            LoadingOverlay overlay = LoadingOverlay.of(context);
            Future<http.Response> resFuture = ValidateOTP(
                Provider.of<Data>(context, listen: false).data!,
                Provider.of<Data>(context, listen: false).host!);
            print(resFuture);
            // overlay.during(Future.delayed(Duration(seconds: 2)));
            overlay.during(resFuture);
            http.Response? res;
            try {
              res = await resFuture;
            } catch (e) {
              return setState(() {
                _error = e.toString();
              });
            }
            print("hey");
            print(res.statusCode);

            switch (res.statusCode) {
              case 200:
                var resMap = jsonDecode(res.body);
                Provider.of<Data>(context, listen: false).updatedata(
                    Provider.of<Data>(context, listen: false).data!
                      ..addAll(resMap));
                if (((resMap!["id with which it is active"] as String?) ?? "")
                    .isNotEmpty) {
                  var resFetchFuture = fetchPayload(
                      resMap!["id with which it is active"] as String,
                      Provider.of<Data>(context, listen: false).host!);
                  overlay.during(resFetchFuture);
                  http.Response? resFetch;
                  try {
                    resFetch = await resFetchFuture;
                    switch (resFetch.statusCode) {
                      case 200:
                        Map<String, dynamic>? payload =
                            jsonDecode(resFetch.body);
                        Map<String, dynamic> flat = {};
                        flatMap(payload!, flat);
                        var tempMap =
                            Provider.of<Data>(context, listen: false).data;
                        tempMap
                          ?..addAll(payload)
                          ..addAll(flat);
                        tempMap!["payload"] = payload;
                        Provider.of<Data>(context, listen: false)
                            .updatedata(tempMap);
                        String? stageString = tempMap["stage"];
                        if (stageString != null) {
                          stageString = stageString.split("_")[2];
                          currentProgress++;
                          Navigator.pushNamed(context, '/' + stageString);
                          return;
                        }
                        currentProgress++;
                        Navigator.pushNamed(context, '/three');
                        break;
                      case 400:
                        setState(() {
                          _error = res?.body ??
                              "Some unknown error, please try again later";
                        });
                        break;
                      default:
                        setState(() {
                          _error = res?.body ??
                              "Some unknown error, please try again later";
                        });
                    }
                  } catch (e) {
                    return setState(() {
                      _error = e.toString();
                    });
                  }
                } else {
                  currentProgress++;
                  Navigator.pushNamed(context, '/three');
                }
                break;
              case 400:
                setState(() {
                  _error =
                      res?.body ?? "Some unknown error, please try again later";
                });
                break;
              default:
                setState(() {
                  _error =
                      res?.body ?? "Some unknown error, please try again later";
                });
            }
            // Navigator.pushNamed(context, '/one');
          } else {
            setState(() {
              _error = "first finish the shit";
            });
          }
        },
        tooltip: 'Continue',
        child: const Icon(Icons.navigate_next),
        backgroundColor: const Color(0xff6758EA),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
