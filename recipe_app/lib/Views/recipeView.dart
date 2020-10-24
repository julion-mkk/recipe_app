import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
    final String postUrl;
    RecipeView({this.postUrl});
    RecipeViewState createState()=> RecipeViewState();
}

class RecipeViewState extends State<RecipeView> {
    String finalUrl;
    final Completer<WebViewController> _completer = Completer<WebViewController>();
    initState() {
        super.initState();
        if(widget.postUrl.contains("http://"))
            finalUrl = widget.postUrl.replaceAll("http://", "https://");
        else
            finalUrl = widget.postUrl;
        print("final url is $finalUrl");
    }
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                        const Color(0xff213A50),
                                        const Color(0xff071930),
                                    ]
                                )
                            ),
                            padding: EdgeInsets.only(top: Platform.isIOS? 60 : 30, right: 24, left: 24, bottom: 24),
                            child: Row(
                                mainAxisAlignment: kIsWeb? MainAxisAlignment.start : MainAxisAlignment.center,
                                children: [
                                    Text("Recipe",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontFamily: 'Overpass',),
                                    ),
                                    Text("App",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue,
                                            fontFamily: 'Overpass'
                                        ),)
                                ],
                            ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - (Platform.isIOS ? 120 : 80),
                            child: WebView(
                                initialUrl: finalUrl,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated: (WebViewController webViewController) {
                                    setState(() {
                                        _completer.complete(webViewController);
                                    });
                                },
                            ),
                        )

                    ],
                ),
            ),
        );
    }
}