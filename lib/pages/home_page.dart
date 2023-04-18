import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadgethive/core/store.dart';
import 'package:gadgethive/model/cart.dart';
import 'package:gadgethive/model/catalog.dart';
import 'package:gadgethive/pages/home_detail_page.dart';
import 'package:gadgethive/pages/home_widgets/catalog_Header.dart';
import 'package:gadgethive/pages/home_widgets/catalog_List.dart';
import 'package:gadgethive/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int days = 30;

  final String name = "GadgetHive";

  final url = "https://vanraj8169.github.io/gadgethivejson/catalog.json";

  List<Item> filteredItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Future.delayed(Duration(seconds: 2));

    final response = await http.get(Uri.parse(url));
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    var productsData = decodedData["products"];

    CatalogModel.items = List.from(productsData)
        .map<Item>((item) => Item.fromMap(item))
        .toList();
    setState(() {
      filteredItems = CatalogModel.items;
      isLoading = false;
    });
  }

  void updateList(String value) {
    setState(() {
      filteredItems = CatalogModel.items
          .where((element) =>
          element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _cart = (VxState.store as MyStore).cart;

    return Scaffold(
        backgroundColor: context.canvasColor,
        floatingActionButton: VxBuilder(
          mutations: {AddMutation, RemoveMutation},
          builder: (ctx, _, __) => FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, MyRoutes.cartRoute),
            backgroundColor: context.theme.buttonColor,
            child: Icon(
              CupertinoIcons.cart,
              color: Colors.white,
            ),
          ).badge(
              color: Vx.gray200,
              size: 22,
              count: _cart.items.length,
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: SafeArea(
          child: Container(
            padding: Vx.m32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CatalogHeader(),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) => updateList(value),
                  style: TextStyle(color: context.theme.accentColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xff000000FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "eg: iPhone 14 Pro max",
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.purple.shade900,
                  ),
                ),
                if (filteredItems != null && filteredItems.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final catalog = filteredItems[index];
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeDetailPage(catalog: catalog))
                          ),
                          child: CatalogItem(catalog: catalog),
                        );
                      },
                    ),
                  )
                else if (filteredItems != null &&
                    filteredItems.isEmpty &&
                    isLoading != true)
                  "Item Not Found".text.center.make().expand()
                else
                  CircularProgressIndicator().centered().expand(),
              ],
            ),
          ),
        ));
  }
}
