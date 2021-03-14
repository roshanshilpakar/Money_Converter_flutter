import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unit_converter/services/api_client.dart';
import 'package:unit_converter/widgets/drop_down.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,

    );
  }
}

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  //first create an instance of the API client
  ApiClient client = ApiClient();
  //setting the main colors
  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);
  //setting the variables
  List<String> currencies;
  String from;
  String to;

//variables for exchange rate
  double rate;
  String result = "";


  //Function to call the api

  @override
  void initState(){
    super.initState();
    // ignore: unnecessary_statements
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });

    })();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0,vertical:18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200.0,
                child: Text(
                  "Currency Converter",
                   style: TextStyle(
                      color: Colors.blue,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
            ),
              ),
              ),
               Expanded(
                  child: Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Let's set the text field
                    TextField(
                      onSubmitted: (value) async {
                        // making the function to get the exchange rate
                        rate = await client.getRate(from, to);
                        setState(() {
                          result =
                              (rate * double.parse(value)).toStringAsFixed(3);
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Input value to convert",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          color: secondColor,
                        )

                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //creating a custom widget for the currencies drop down button
                        customDropDown(currencies, from, (val){
                        setState(() {
                          from = val;
                        });
                        }),
                        FloatingActionButton(
                            onPressed: (){
                              String temp = from;
                              setState(() {
                                from = to;
                                to=temp;
                              });
                            },
                            child: Icon(Icons.swap_horiz),
                            elevation: 0.0,
                            backgroundColor:secondColor,
                        ),
                        customDropDown(currencies, to, (val){
                          setState(() {
                            to = val;
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          Text("Result", style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),),
                          Text(result, style: TextStyle(
                            color: secondColor,
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ))
            ],
          ),
        ),
      ),
    );
  }
}
