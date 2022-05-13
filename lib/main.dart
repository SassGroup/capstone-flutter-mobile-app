import 'package:capstone_mobile/pages/page_one.dart';
import 'package:capstone_mobile/pages/pagethree.dart';
import 'package:capstone_mobile/pages/pagetwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'component/logo.dart';
import 'configvar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
        create: (context) => Data(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          initialRoute: '/',
          routes: <String, Widget Function(BuildContext)>{
            "/": (context) => const MyHomePage(),
            "/one": (context) => EmailAndMobileLogin(),
            "/two": (context) => EmailOtpPage(),
            "/three": (context) => IncomePage(),
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bool _submit = false;
  String? _host =
      "https://capstone-express-backend-load-service-shatrustg.cloud.okteto.net";
  final _form_key = GlobalKey<FormState>();

  void _fuckNext() {
    if (simulationDebug || (_form_key.currentState?.validate() ?? false)) {
      print((_host ?? "") + " DebugShatru");
      Provider.of<Data>(context, listen: false).updateIp(_host);
      Navigator.pushNamed(context, '/one');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Logo.singleton(),
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      ),
      body: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _form_key,
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: Row(children: [
                    const Flexible(
                        child: Text(
                            "Select the check box to simulate the app without hitting the backend api")),
                    Checkbox(
                        value: simulationDebug,
                        onChanged: (val) {
                          simulationDebug = val ?? false;
                          setState(() {});
                        }),
                  ]),
                ),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[\s]'))
                  ],
                  initialValue: _host,
                  decoration: const InputDecoration(
                      labelText: "IP Address or the Hostname",
                      labelStyle:
                          TextStyle(color: Color.fromARGB(193, 207, 207, 207))),
                  validator: (text) {
                    return simulationDebug || (text?.isNotEmpty ?? false)
                        ? null
                        : "Enter you fucker";
                  },
                  onChanged: (text) {
                    _host = text;
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fuckNext,
        tooltip: 'Increments',
        child: const Icon(Icons.navigate_next),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Data extends ChangeNotifier {
  Map<String, dynamic>? data = {"testData": "fuck"};

  late String? host;

  void updatedata(Map<String, dynamic> input) {
    data = input;
    notifyListeners();
  }

  void updateIp(String? host, [int? port]) {
    this.host = host;
    notifyListeners();
  }
}
