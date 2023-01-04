// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_invetory/keyboard.dart';
import 'package:store_invetory/models/product.dart';
import 'package:store_invetory/sales.dart';
import 'package:store_invetory/service/sqllite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SqlliteService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All items

  late SqlliteService _sqliteService;

  @override
  void initState() {
    super.initState();
    this._sqliteService = SqlliteService();
    this._sqliteService.initializeDB().whenComplete(() async {
      _refreshProducts();
      setState(() {});
    });
  }

  List<Sale> _product = [];
// This function is used to fetch all data from the database
  void _refreshProducts() async {
    final data = await _sqliteService.getSales();
    setState(() {
      _product = data;
    });
    print(_product.length);
  }

  // text controller
  final TextEditingController _myController = TextEditingController();

  double retailPrice = 5000;
  double wholesalePrice = 4500;
  double totalPrice = 0;

  calculateTotal(double numberOfFish) {
    if (numberOfFish > 5 || numberOfFish == 5) {
      double _totalPrice = wholesalePrice * numberOfFish;
      print(_totalPrice);
      setState(() {
        totalPrice = _totalPrice;
      });
    } else {
      double _totalPrice = retailPrice * numberOfFish;
      print(_totalPrice);
      setState(() {
        totalPrice = _totalPrice;
      });
    }
  }

  String result = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(child: Text('SAMAKI ATLAS')),
            ),
            ListTile(
              title: const Text('Sales'),
              onTap: () {
                // Update the state of the app
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Sales(),
                  ),
                );
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(child: Text('Samaki Atlas')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            // color: Colors.red,
            child: ListView.builder(
              itemCount: _product.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Card(
                    child: Center(
                      child: Text(
                          "${_product[index].name.toString().toUpperCase()}"),
                    ),
                  ),
                );
              }),
            ),
          ),
          // display the entered numbers
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 70,
              child: Center(
                child: TextField(
                  controller: _myController,
                  textAlign: TextAlign.center,
                  showCursor: false,
                  style: const TextStyle(fontSize: 20),
                  // Disable the default soft keybaord
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    hintText: "Number of Fish",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              height: 70,
              child: Center(
                child: _myController.text == null
                    ? Text(
                        "Price per Fish",
                        style: TextStyle(fontSize: 20),
                      )
                    : Text(
                        "${retailPrice.toString()}",
                        style: TextStyle(fontSize: 20),
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              height: 70,
              child: Center(
                child: Text(
                  "${totalPrice}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          // implement the custom NumPad
          NumPad(
            buttonSize: 75,
            buttonColor: Colors.blue,
            iconColor: Colors.green,
            controller: _myController,
            delete: () {
              _myController.text = _myController.text
                  .substring(0, _myController.text.length - 1);
            },
            // do something with the input numbers
            onSubmit: () {
              calculateTotal(double.parse(_myController.text));
              // print(double.parse(_myController.text));
              // debugPrint('Your code: ${_myController.text}');
              // showDialog(
              //     context: context,
              //     builder: (_) => AlertDialog(
              //           content: Text(
              //             "You code is ${_myController.text}",
              //             style: const TextStyle(fontSize: 30),
              //           ),
              //         ));
            },
            saveSale: () {
              // Product product = Product(
              //   name: "test",
              //   retailPrice: 5000,
              //   wholesalePrice: 4500,
              // );

              // Provider.of<SqlliteService>(context, listen: false)
              //     .createItem(product);

              Sale sale = Sale(
                  name: "Sangara",
                  pricePerProduct: double.parse(_myController.text) < 5
                      ? retailPrice
                      : wholesalePrice,
                  totalPrice: totalPrice,
                  quantity: int.parse(_myController.text),
                  date: DateTime.now().toString());

              Provider.of<SqlliteService>(context, listen: false)
                  .createSale(sale);

              // print(_product[0].retailPrice);
            },
          ),
        ],
      ),
    );
  }
}
