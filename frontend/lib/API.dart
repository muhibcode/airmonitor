import 'package:air_monitor/widgets/Storage.dart';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final dio = Dio();

var flaskUrl = getlocData('flaskUrl');

var baseUrl = 'http://$flaskUrl/';
IO.Socket socket = IO.io('http://$flaskUrl', {
  'autoConnect': false,
  'transports': ['websocket'],
});
Future<Response> getReq(String url) async {
  Response response;
  response = await dio.get(baseUrl + url);

  return response;
}

Future<Response> getWithParams(String url, Map<String, dynamic> params) async {
  Response response;

  response = await dio.get(
    baseUrl + url,
    queryParameters: params,
  );

  return response;
}

Future<Response> postData(url, body) async {
  Response response;
  print(baseUrl);
  response = await dio.post(baseUrl + url, data: body);

  return response;
}
