//initially let's add the http package
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient{
  final Uri currencyURL= Uri.https("free.currconv.com","/api/v7/currencies",
      {"apiKey":"98371064097b6b9589c2"});
  //the first parameter of URI should be just the main url, without http or any kind of special char like / or $ or ?
  //the second parameter will be the endpoint path
  //third parameter is for a map for different properties

  //lets make the function to get the currencies list
  Future<List<String>> getCurrencies() async{
    http.Response res = await http.get(currencyURL);
    if(res.statusCode ==200){
      var body = jsonDecode(res.body);
      var list= body["results"];
      // List<String> String = [];

      List<String> currencies = (list.Keys).toList();
      print(currencies);
      return currencies;
    }
    else{
      throw Exception("Failed to connect to API");
    }
  }

  //getting exchange rates
Future<double> getRate( String from, String to) async{
    final Uri rateUrl = Uri.http("free.currconv.com","/api/v7/currencies",
        {"apiKey": "98371064097b6b9589c2",
          "q": "${from}_${to}",
          "compact": "ultra",
        });
    http.Response res = await http.get(rateUrl);
    if(res.statusCode==200){
      var body = jsonDecode(res.body);
      return body["${from}_${to}"];

    }else{
      throw Exception("Failed to connect to API");
    }
}

}