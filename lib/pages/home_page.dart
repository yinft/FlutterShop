import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHotGood();
    print('开始初始化项目首页');
  }

  @override
  Widget build(BuildContext context) {
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    return Scaffold(
        appBar: AppBar(
          title: Text('小商店'),
        ),
        body: FutureBuilder(
          future: request('homePageContent', data: formData),
          builder: (context, val) {
            if (val.hasData) {
              var data = json.decode(val.data.toString());
              List<Map> swiperDataList =
                  (data['data']['slides'] as List).cast();
              List<Map> navgatorList =
                  (data['data']['category'] as List).cast(); // 顶部轮播组件数
              String picture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];

              String leaderImage = data['data']['shopInfo']['leaderImage'];
              String leaderPhone = data['data']['shopInfo']['leaderPhone'];
              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast();

              String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
              String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
              String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              List<Map> floor2 = (data['data']['floor2'] as List).cast();
              List<Map> floor3 = (data['data']['floor3'] as List).cast();
              if (navgatorList.length > 10) {
                navgatorList.removeRange(10, navgatorList.length);
              }

              return EasyRefresh(
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDataList: swiperDataList), //页面顶部轮播组件
                    TopNavigator(
                      navgatorList: navgatorList,
                    ),
                    AdBanner(picture: picture),
                    LeaderPhone(
                        leaderImage: leaderImage, ledaderPhone: leaderPhone),
                    Recommend(recommendList: recommendList),
                    FloorTitle(picture_address: floor1Title),
                    FloorContent(floorGoodList: floor1),
                    FloorTitle(picture_address: floor2Title),
                    FloorContent(floorGoodList: floor2),
                    FloorTitle(picture_address: floor3Title),
                    FloorContent(floorGoodList: floor3),
                    _hotGoods(),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('加载中'),
              );
            }
          },
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

//获取热销商品数据
  void _getHotGood() {
    var formData = {'page', page};
    request('homePageBelowConten', data: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodList = (data['data'] as List).cast();
      setState(() {
        hotGoodList.addAll(newGoodList);
        page++;
      });
    });
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(5),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text('火爆专区'),
  );

  Widget _getWrapList() {
    if (hotGoodList.length != 0) {
      List<Widget> listWidget = hotGoodList.map((val) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 2),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(372)),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink, fontSize: ScreenUtil().setSp(25)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('暂无火爆商品');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, _getWrapList()],
      ),
    );
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

//拨打电话组件
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String ledaderPhone; //店长电话
  const LeaderPhone({Key key, this.leaderImage, this.ledaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + ledaderPhone;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能访问';
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  //标题方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //商品单独项方法
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 0.5, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  //横向列表方法

  Widget _recommedList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(400),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[_titleWidget(), _recommedList()],
      ),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;
  const FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Image.network(picture_address),
      ),
    );
  }
}

//楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodList;
  FloorContent({Key key, this.floorGoodList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(), _otherGoods()],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodList[1]),
            _goodsItem(floorGoodList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodList[3]),
        _goodsItem(floorGoodList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击了楼层商品');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}
