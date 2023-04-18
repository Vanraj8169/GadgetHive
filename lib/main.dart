import 'package:flutter/material.dart';
import 'package:gadgethive/core/store.dart';
import 'package:gadgethive/pages/home_page.dart';
import 'package:gadgethive/pages/login_page.dart';
import 'package:gadgethive/utils/routes.dart';
import 'package:gadgethive/widgets/themes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'pages/cart_page.dart';

void main() {
  runApp(VxState(store: MyStore(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      initialRoute: MyRoutes.loginRoute,
      routes: {
        "/": (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.cartRoute: (context) => CartPage(),
      },
    );
  }
}
