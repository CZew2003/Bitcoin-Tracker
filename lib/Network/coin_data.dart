import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bitcoin_tracker/Utils/coin_lists.dart';

const apiKey = '6D904ED6-D54B-4321-820A-797E2D93F786';

class CoinData {
  String selectedCurrency;

  CoinData({required this.selectedCurrency});

  Future getCoinData() async {
    Map<String, String> values = {};

    for (String cryptoCurrency in cryptoList) {
      Uri uri = Uri.https(
          'rest.coinapi.io',
          '/v1/exchangerate/$cryptoCurrency/$selectedCurrency',
          {'apikey': apiKey});
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        double price = body['rate'];
        values[cryptoCurrency] = price.toStringAsFixed(2);
      } else {
        print(response.statusCode);
        throw 'Problem with get request';
      }
    }

    return values;
  }
}
