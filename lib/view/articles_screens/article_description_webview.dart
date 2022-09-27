import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleDescriptionWebView extends StatefulWidget {
  const ArticleDescriptionWebView({Key? key, required this.url})
      : super(key: key);
  final url;
  @override
  State<ArticleDescriptionWebView> createState() =>
      _ArticleDescriptionWebViewState(url: url);
}

class _ArticleDescriptionWebViewState extends State<ArticleDescriptionWebView> {
  _ArticleDescriptionWebViewState({required this.url});
  String url;
  late WebViewController _webViewController;
  double _webProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          url,
          overflow: TextOverflow.fade,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () async {
                if (await _webViewController.canGoBack()) {
                  _webViewController.goBack();
                }
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                _webViewController.reload();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () async {
                if (await _webViewController.canGoForward()) {
                  _webViewController.goForward();
                }
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(children: [
        _webProgress < 1
            ? SizedBox(
                height: 5,
                child: LinearProgressIndicator(
                  value: _webProgress,
                  color: Colors.red,
                  backgroundColor: Colors.black,
                ),
              )
            : SizedBox(),
        Expanded(
          child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            onProgress: (progress) {
              setState(() {
                _webProgress = progress / 100;
              });
            },
          ),
        ),
      ]),
    );
  }
}
