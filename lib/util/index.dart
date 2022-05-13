import 'package:flutter/cupertino.dart';

flatMap(Map<String, dynamic> source, Map<String, dynamic> target) {
  for (String key in source.keys) {
    dynamic value = source[key];
    if (value != null) {
      target[key] = value;
      if (value is Map<dynamic, dynamic>) {
        flatMap(value as Map<String, dynamic>, target);
      }
    }
  }
}

BuildPayloadWithLoanInfoAndApplicantInfo(Map<String, dynamic> payload) {
  var map = {};
  map["loanApplicationInfo"] = {
    "productConfigKey": "PL",
    "stage": payload["stage"]
  };
  map["loanApplicationInfo"]["requestTimestamp"] =
      DateTime.now().millisecondsSinceEpoch.toString();
  map["applicantInfo"] = {
    "mobileNumber": payload["mobileNumber"],
    "emailID": payload["emailID"]
  };
  payload["payload"] = map;
  return payload;
}
