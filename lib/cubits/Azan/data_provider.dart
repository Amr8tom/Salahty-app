import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../../models/azan_by_city/azan_model.dart';

class AzanDataProvider{
  static final cache = Hive.box('data');
  static Dio ins = Dio();
  static Future<AzanModel> azanFetchApi({required String latitude,required String longitude}) async {
    try {
// GET http://api.aladhan.com/v1/timings?latitude={latitude}&longitude={longitude}&method={method}

final res = await ins.get(
        // 'https://api.aladhan.com/v1/timingsByCity?city=Riyadh&country=Saudi%20Arabia&method=2',
        'http://api.aladhan.com/v1/timings?latitude=$latitude}&longitude=$longitude&method=2',
      );
      final Map<String,dynamic> response= res.data;
      print(response);
      final Azan =  AzanModel.fromJson(response);
      print(Azan.data);
      await cache.put(
        'Azan',
        Azan.toJson(),
      );
      return Azan;
    } catch (e) {
      throw Exception("Internal Server Error");
    }
  }
}