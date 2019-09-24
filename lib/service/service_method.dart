import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

//集成通用请求方法
Future request(url, data) async {
  try {
    print('开始获取数据.................');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    // var formData = {'lon': '115.02932', 'lat': '35.76189'};
    if (data == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: data);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常......');
    }
  } catch (e) {
    return print('ERROR: ==================>$e');
  }
}

// 获取首页主体内容
Future getHomePageContent() async {
  try {
    print('开始获取首页数据.................');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    response = await dio.post(servicePath['homePageContent'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常......');
    }
  } catch (e) {
    return print('ERROR: ==================>$e');
  }
}

// 获取火爆专区的商品方法
Future getHomePageBelowContent() async {
  try {
    print('开始获取火爆专区数据.................');
    print(servicePath['homePageBelowConten']);
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    int page = 1;
    response = await dio.post(servicePath['homePageBelowConten'], data: page);
    print(response);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常......');
    }
  } catch (e) {
    return print('ERROR: ==================>$e');
  }
}
