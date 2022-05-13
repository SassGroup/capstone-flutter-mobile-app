import 'package:http/http.dart' as http;

Future<http.Response> fetchPayload(String id, String host) {
  Uri url = Uri.parse(host + "/loan/application/" + id);
  return http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );
}
