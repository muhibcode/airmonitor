import 'package:localstorage/localstorage.dart';

var storage = LocalStorage('AM.json');

getlocData(key) => storage.getItem(key);

setlocData(String k, dynamic v) async => await storage.setItem(k, v);
