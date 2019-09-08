import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('小商店'),
        ),
        body: FutureBuilder(
          future: getHomePageContent(),
          builder: (context, val) {
            if (val.hasData) {
              var data = json.decode(val.data.toString());
              List<Map> swiperDataList =
                  (data['data']['slides'] as List).cast();
              List<Map> navgatorList =
                  (data['data']['category'] as List).cast(); // 顶部轮播组件数
              String picture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];
              if (navgatorList.length > 10) {
                navgatorList.removeRange(10, navgatorList.length);
              }
              return Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiperDataList), //页面顶部轮播组件
                  TopNavigator(
                    navgatorList: navgatorList,
                  ),
                  AdBanner(picture: picture)
                ],
              );
            } else {
              return Center(
                child: Text('加载中'),
              );
            }
          },
        ));
  }
}

// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swiperDataList[index]['image']}",
              fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//gridView组件
class TopNavigator extends StatelessWidget {
  final List navgatorList;
  const TopNavigator({Key key, this.navgatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print("点击了导航");
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navgatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//广告Banner组件
class AdBanner extends StatelessWidget {
  final String picture;

  const AdBanner({Key key, this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Image.network(picture));
  }
}
