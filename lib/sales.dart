import 'package:flutter/material.dart';
import 'package:store_invetory/models/product.dart';
import 'package:store_invetory/service/sqllite.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  late SqlliteService _sqliteService;

  @override
  void initState() {
    super.initState();
    this._sqliteService = SqlliteService();
    this._sqliteService.initializeDB().whenComplete(() async {
      _refreshSales();
      setState(() {});
    });
  }

  List<Sale> _product = [];

  void _refreshSales() async {
    final data = await _sqliteService.getSales();
    setState(() {
      _product = data;
    });
    print(_product.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sales")),
      body: ListView.builder(
        itemCount: _product.length,
        itemBuilder: ((context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                        "${_product[index].name.toString().toUpperCase()}"),
                  ),
                  Expanded(
                    child:
                        Text("${_product[index].pricePerProduct.toString()}"),
                  ),
                  Expanded(
                    child: Text(
                        "${_product[index].totalPrice.toString().toUpperCase()}"),
                  ),
                  Expanded(
                    child: Text(
                        "${_product[index].quantity.toString().toUpperCase()}"),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                        "${_product[index].date.toString().toUpperCase()}"),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
