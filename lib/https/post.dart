import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> OtpRequest(Map<String, dynamic> payload, String host) {
  Uri url = Uri.parse(host + "/verifyEmail");
  return http.post(
    url,
    body: jsonEncode(payload),
    headers: {"Content-Type": "application/json"},
  );
}

Future<http.Response> ValidateOTP(Map<String, dynamic> payload, String host) {
  Uri url = Uri.parse(host + "/verifyEmailOTP");
  return http.post(
    url,
    body: jsonEncode(payload),
    headers: {"Content-Type": "application/json"},
  );
}
