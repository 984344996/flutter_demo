import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutterdemo/module/Web/WebPage.dart';
import 'package:flutterdemo/util/log/logUtil.dart';
import 'package:flutterdemo/util/network/DioManager.dart';
import 'package:flutterdemo/util/network/NetworkAPI.dart';

import 'NewsModel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<News> news = [];
  ScrollController _scrollController = ScrollController();
  var _refreshKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var pix = _scrollController.position.pixels;
      var max = _scrollController.position.maxScrollExtent;
      if (pix == max) {
        //已下拉到底部，调用加载更多方法
        _loadData();
      }
    });
    _loadData();
  }

  Future<Null> _loadData() async{
    LogUtil.v("_loadData start");
    await DioManager.shared.request(NetworkMethod.GET,
      NetworkAPI.news,
      params: {"type": "头条", "key": "bfa0aab6d18acb93324463ccd5c63d64"}, success: (data) {
          NewsResponse resp = NewsResponse.fromJson(data);
          var newNews = news;
          newNews.addAll(resp.result.data);
          setState(() {
            news = newNews;
          });
          LogUtil.v("_loadData success");
        }, error: (e) {

        }).then((value) => null);
    LogUtil.v("_loadData end");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
              key: _refreshKey,
              child: ListView.builder(
                itemCount: news == null ? 0 : news.length + 1,
                itemBuilder: (content, index) {
                  return _listItem(index);
                },
        controller: _scrollController,
      ),
      onRefresh: _loadData,
    )));
  }

  //item
  Widget _listItem(int index) {
    if (index == news.length) {
      return Center(
        child: Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.all(5),
          child: CircularProgressIndicator(
            backgroundColor: Colors.green,
          ),
        ),
      );
    } else {
      News data = news[index];
      return GestureDetector(
          child: Container(
              height: 100,
              margin: EdgeInsets.only(left: 5, right: 5, top: 16, bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)), //设置圆角
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                color: Colors.black
                              ),
                              maxLines: 2,
                            ),

                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(data.authorName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.grey[500]
                                  ),
                                ),
                              ),

                            )

                          ],
                        ),
                    ),
                  ),
                  Container(
                    height: 90,
                    width: 120,
                    margin: EdgeInsets.all(5),
                    child: Image.network(data.thumbnailPicS),
                  ),
                ],
              )
          ),
        onTap: () {
          Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
            return new WebPage(url: data.url);
          })).then( (String result){

            //处理代码

          });
        },
      );
    }
  }
}
