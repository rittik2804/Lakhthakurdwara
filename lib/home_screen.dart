// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'no_internet.dart';

import 'connectivity.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();

    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if (Platform.isIOS) WebView.platform = CupertinoWebView();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    // ignore: prefer_const_constructors
    return Consumer<ConnectivityProvider>(
        builder: (consumerContext, model, child) {
      if (model.isOnline != null) {
        return model.isOnline! ? pageUi() : NoInternet();
      }
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}

class pageUi extends StatefulWidget {
  const pageUi({Key? key}) : super(key: key);

  @override
  _pageUiState createState() => _pageUiState();
}

class _pageUiState extends State<pageUi> {
  late WebViewController controller;
  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExistingWarning = difference >= Duration(seconds: 2);
          timeBackPressed = DateTime.now();

          if (isExistingWarning) {
            final massage = 'Press back again to exit';
            Fluttertoast.showToast(msg: massage, fontSize: 18);
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: Scaffold(
            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(76, 68, 108, 1),
                          image: DecorationImage(
                              image: AssetImage("assets/logo.png")),
                          borderRadius: BorderRadius.circular(5)),
                      // child: Image(

                      //     image: AssetImage("assets/logo.png")),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Home',
                      style: TextStyle(fontSize: 21),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) => pageUi())));
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                      title: const Text(
                        'Become A Seller',
                        style: TextStyle(fontSize: 21),
                      ),
                      onTap: () {
                        final url = controller.currentUrl();
                        controller.loadUrl(
                            "https://lakhthakurdwara.com/shops/create");
                      }),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                      title: const Text(
                        "User Login",
                        style: TextStyle(fontSize: 21),
                      ),
                      onTap: () {
                        final url = controller.currentUrl();
                        controller
                            .loadUrl("https://lakhthakurdwara.com/users/login");
                      }),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    title: const Text(
                      'All Categories',
                      style: TextStyle(fontSize: 21),
                    ),
                    onTap: () {
                      final url = controller.currentUrl();
                      controller.loadUrl("https://lakhthakurdwara.com/search");
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                      title: const Text(
                        "Register As Customer",
                        style: TextStyle(fontSize: 21),
                      ),
                      onTap: () {
                        final url = controller.currentUrl();
                        controller.loadUrl(
                            "https://lakhthakurdwara.com/users/registration");
                      }),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                      title: const Text(
                        "Cart",
                        style: TextStyle(fontSize: 21),
                      ),
                      onTap: () {
                        final url = controller.currentUrl();
                        controller.loadUrl("https://lakhthakurdwara.com/cart");
                      }),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(76, 68, 108, 1),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => pageUi())));
                },
                child: Container(
                  height: size.height / 15,
                  child: Image(
                    image: AssetImage("assets/appbar_logo.png"),
                  ),
                ),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: Container(
              child: WebView(
                initialUrl: ('https://lakhthakurdwara.com/'),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: ((WebViewController controller) {
                  this.controller = controller;
                }),
                onProgress: (url) async {
                  controller.evaluateJavascript(
                      "document.getElementsByTagName('header')[0].style.display='none'");
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith("https://lakhthakurdwara.com/")) {
                    return NavigationDecision.navigate;
                  } else {
                    _launchURL(request.url);
                    return NavigationDecision.prevent;
                  }
                },
              ),
            )));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  
}





          
          // body: WebView(
          //   onWebViewCreated: ((controller) {
          //     this.controller = controller;
          //   }),
            // onProgress: (url) async {
            //   controller.evaluateJavascript(
            //       "document.getElementsByTagName('header')[0].style.display='none'");
            // },
          //   initialUrl: ('https://lakhthakurdwara.com/'),
          //   javascriptMode: JavascriptMode.unrestricted,
          // ),