import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Utils/coin_lists.dart';
import '../Network/coin_data.dart';
import 'dart:io' show Platform;
import '../Widgets/crypto_card.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'USD';

  Map<String, String> currentPrices = {};

  DropdownButton<String> getDropdown() {
    List<DropdownMenuItem<String>> widgets = [];
    for (String currency in currenciesList) {
      widgets.add(
        DropdownMenuItem(
          value: currency,
          child: Text(currency),
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency ?? 'USD',
      items: widgets,
      onChanged: (String? value) {
        setState(() {
          selectedCurrency = value;
          setPrice();
        });
      },
    );
  }

  CupertinoPicker getPicker() {
    List<Widget> widgets = [];
    for (String currency in currenciesList) {
      widgets.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (index) {
        setState(() {
          selectedCurrency = currenciesList[index];
          setPrice();
        });
      },
      children: widgets,
    );
  }

  bool isWaiting = false;

  Future<dynamic> setPrice() async {
    isWaiting = true;
    CoinData coinData = CoinData(selectedCurrency: selectedCurrency ?? 'USD');
    try {
      var prices = await coinData.getCoinData();
      isWaiting = false;
      setState(() {
        currentPrices = prices;
        ;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Widget> getCards() {
    List<Widget> cards = [];
    for (String cryptoCurrency in cryptoList) {
      cards.add(CryptoCard(
        value: isWaiting ? '?' : currentPrices[cryptoCurrency]!,
        selectedCurrency: selectedCurrency ?? 'USD',
        cryptoCurrency: cryptoCurrency,
      ));
    }
    return cards;
  }

  @override
  void initState() {
    super.initState();

    setPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getCards(),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
            ),
            width: double.infinity,
            height: 150.0,
            alignment: Alignment.center,
            child: Platform.isIOS ? getPicker() : getDropdown(),
          )
        ],
      ),
    );
  }
}
