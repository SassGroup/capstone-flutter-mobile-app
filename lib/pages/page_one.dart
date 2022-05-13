import 'dart:convert';

import 'package:capstone_mobile/component/overlayLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../component/logo.dart';
import '../component/progress.dart';
import '../configvar.dart';
import '../https/post.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class EmailAndMobileLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailAndMobileLoginState();
}

class _EmailAndMobileLoginState extends State<EmailAndMobileLogin> {
  final _emailNmobileFormKey = GlobalKey<FormState>();
  String? _emailId = "";
  String? _mobile = "";

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
                      margin: const EdgeInsets.only(bottom: 40),
                      width: double.infinity,
                      child: const Text("Let’s Get Started!!",
                          style: TextStyle(
                              color: Color(0xff22d2b0),
                              fontSize: 40,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center)),
                  const SizedBox(
                      width: double.infinity,
                      child: Text(
                          "Please enter your mobile number and email id linked to your",
                          style: TextStyle(
                              color: Color(0xff838383),
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start)),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                        "Bank, PAN and Aadhaar to validate your Identity",
                        style: TextStyle(
                            color: Color(0xff838383),
                            fontSize: 10,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _emailNmobileFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'[\s]'))
                            ],
                            decoration: const InputDecoration(
                                labelText: "Mobile Number",
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(193, 207, 207, 207))),
                            validator: (text) {
                              return RegExp(r"^\d{10}$").hasMatch(text ?? "")
                                  ? null
                                  : "Enter Valid Mobile Number you fucker";
                            },
                            onChanged: (text) {
                              _mobile = text;
                              if (_error.isNotEmpty) {
                                setState(() {
                                  _error = "";
                                });
                              }
                            },
                          ),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'[\s]'))
                            ],
                            decoration: const InputDecoration(
                                labelText: "Email ID",
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(193, 207, 207, 207))),
                            validator: (text) {
                              return RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(text ?? "")
                                  ? null
                                  : "Enter Valid Email you fucker";
                            },
                            onChanged: (text) {
                              if (_error.isNotEmpty) {
                                setState(() {
                                  _error = "";
                                });
                              }
                              _emailId = text;
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
          if (_emailNmobileFormKey.currentState?.validate() ?? false) {
            // print(_ip);
            Map<String, dynamic> m = {
              "emailID": _emailId!,
              "mobileNumber": _mobile!
            };

            Provider.of<Data>(context, listen: false).updatedata(
                Provider.of<Data>(context, listen: false).data!..addAll(m));
            print(Provider.of<Data>(context, listen: false).data);

            LoadingOverlay overlay = LoadingOverlay.of(context);
            Future<http.Response> resFuture = OtpRequest(
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
                print(jsonDecode(res.body));
                Provider.of<Data>(context, listen: false).updatedata(
                    Provider.of<Data>(context, listen: false).data!
                      ..addAll(jsonDecode(res.body)));
                Navigator.pushNamed(context, '/two');
                break;
              case 400:
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
