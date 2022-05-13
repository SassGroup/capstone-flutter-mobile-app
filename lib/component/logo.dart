import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);
  factory Logo.singleton() {
    return const Logo();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          //   const Expanded(child: Text("")),
          SvgPicture.asset(
            "assets/svg/logoBank.svg",
            width: 40,
          ),
          const Text(
            "Blue",
            style: TextStyle(
                fontSize: 30,
                color: Color(0xff6758ea),
                fontWeight: FontWeight.w700),
          ),
          const Text(
            "Bank",
            style: TextStyle(
                fontSize: 30,
                color: Color(0xff22d2b0),
                fontWeight: FontWeight.w700),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
