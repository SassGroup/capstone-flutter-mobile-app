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

class IncomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final _incomeForm = GlobalKey<FormState>();

  String _error = "";

  final List<String> _employmentListType = [
    "Select Employment Type",
    "Salaried",
    "Self Employed",
    "Retired"
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> formlist = [];

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: const Text("Let us get to know you better!🥳",
                        style: TextStyle(
                            color: Color(0xff22d2b0),
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: "Tell us your ",
                        style: TextStyle(
                            color: Color(0xff6758ea),
                            fontSize: 30,
                            fontWeight: FontWeight.w400),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Income",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 40),
                    child: const Text(
                        "We will let you know the eligible loan amount!!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff6758ea),
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                      border: Border.all(width: 2, color: Colors.grey.shade300),
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        value: _employmentListType[0],
                        dropdownColor: Colors.grey.shade200,
                        items: _employmentListType
                            .map((String item) => DropdownMenuItem(
                                  child: Text(
                                    item,
                                    overflow: TextOverflow.fade,
                                  ),
                                  value: item,
                                ))
                            .toList(),
                        onChanged: (dynamic value) {
                          print(value);
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    width: double.infinity,
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // key: _emailNmobileFormKey,
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
                              // _otp = text;
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
            _error = "asfasg";
          });
          // if (_emailNmobileFormKey.currentState?.validate() ?? false) {

          // } else {
          //   setState(() {
          //     _error = "first finish the shit";
          //   });
          // }
        },
        tooltip: 'Continue',
        child: const Icon(Icons.navigate_next),
        backgroundColor: const Color(0xff6758EA),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
