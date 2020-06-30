import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterdemo/util/log/logUtil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget{
  final String url;
  WebPage({Key key, this.url}) : super(key: key);

  @override
  WebPageState createState() =>  WebPageState();
}

class WebPageState extends State<WebPage>{
  WebViewController _controller;
  String _title = "";
  String url = "";
  @override
  void initState() {
    super.initState();
    url = widget.url;
//    url = "https://www.baidu.com";
    LogUtil.v(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("$_title")
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
        },

        onPageStarted: (url){
          LogUtil.v("onPageStarted");
        },

        onWebResourceError: (e){
          LogUtil.v("onWebResourceError");
        },

        onPageFinished: (url) {
          LogUtil.v("onPageFinished");
          _controller.evaluateJavascript("document.title").then((result){
            setState(() {
              _title = result;
            });
          }
          );
        },

        navigationDelegate: (NavigationRequest request) {
          if(request.url.startsWith("myapp://")) {
            print("即将打开 ${request.url}");
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        } ,

        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
              name: "share",
              onMessageReceived: (JavascriptMessage message) {
                print("参数： ${message.message}");
              }
          ),
        ].toSet(),
      ),
    );
  }
}