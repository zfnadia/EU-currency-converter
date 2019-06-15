import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:eu_currency_converter/tax.dart';
import 'package:eu_currency_converter/country_drop_down_list.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'My app', // used by the OS task switcher
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CountryTaxWidget();
  }
}

class CountryTaxWidget extends StatefulWidget {
  @override
  _CountryTaxWidgetState createState() => _CountryTaxWidgetState();
}

class _CountryTaxWidgetState extends State<CountryTaxWidget> {
  List<Tax> taxes = new List<Tax>();
  Tax currentCountryTax;
  final currentAmntController = TextEditingController();
  double currentAmnt = 0;
  double selectedTaxRate = 0;
  String pickedRate;

  Future<String> loadTaxRatesFromAssets() async {
    return await rootBundle.loadString('json/tax_rates.json');
  }

  Future<void> loadTaxRates() async {
    //String jsonString = await loadTaxRatesFromAssets();
    final resp = await http
        .get("http://jsonvat.com", headers: {"Accept": "aplication/json"});
    final jsonResponse = json.decode(resp.body);
    var jsonRateList = jsonResponse['rates'] as List;
    List<Tax> rateList =
        jsonRateList.map((item) => Tax.fromJson(item)).toList();
    print(rateList);
    setState(() {
      this.taxes = rateList;
    });
  }

  void onCountrySelected(Tax selectedTax) {
//    print("HHHHHH");
    setState(() {
      currentCountryTax = selectedTax;
      selectedTaxRate = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTaxRates();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(40, 55, 40, 20),
//              color: Colors.blue,
                child: Text(
                  "EU CURRENCY CONVERTER",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
            Expanded(
              child: Container(
//                color: Colors.yellow,
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Country Name:",
                            style:
                                TextStyle(fontSize: 19.0, color: Colors.grey),
                          ),
                          CountryDropDownList(
                            taxList: taxes,
                            onCountrySelectedCallback: this.onCountrySelected,
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Center(
                            child: new Theme(
                          data: new ThemeData(
                            primaryColor: Colors.pink,
                            primaryColorDark: Colors.pink[800],
                          ),
                          child: TextField(
                            cursorColor: Colors.pink[800],
                            keyboardType: TextInputType.number,
                            style: Theme.of(context).textTheme.title,
                            decoration: InputDecoration(
                              labelText: "Currency Amount (Euro)",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: currentAmntController,
                            onChanged: (value) {
                              setState(() {
                                currentAmnt = value != null && value.length != 0
                                    ? double.parse(value)
                                    : 0;
                              });
                            },
                          ),
                        )),
                      ),
                      Container(
//                    color: Colors.blueGrey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "VAT rates:",
                              style:
                                  TextStyle(fontSize: 19.0, color: Colors.grey),
                            ),
                            RadioButtonGroup(
                              margin: EdgeInsets.symmetric(vertical: 0),
                              orientation: GroupedButtonsOrientation.VERTICAL,
                              picked: pickedRate,
                              onChange: (label, index) {
                                setState(() {
                                  pickedRate = label;
                                  //selectedTaxRate = currentCountryTax.rates[index];
                                  selectedTaxRate = (currentCountryTax
                                          .rates.values
                                          .toList()[index])
                                      .toDouble();
                                  print(selectedTaxRate);
                                });
                              },
                              labels: currentCountryTax == null
                                  ? []
                                  : currentCountryTax.rates.keys
                                      .toList()
                                      .map((f) =>
                                          "$f (${currentCountryTax.rates[f]}%)")
                                      .toList(),
                              itemBuilder: (Radio rb, Text txt, int i) {
                                return Row(
                                  children: <Widget>[
                                    rb,
                                    txt,
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          //tax is calculated here
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Original Amount = ",
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          "Tax = ",
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "$currentAmnt",
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          "${(currentAmnt * selectedTaxRate / 100).toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                              Container(
                                alignment: Alignment.bottomLeft,
                                margin: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "(+)",
                                  style: TextStyle(
                                      fontSize: 19.0, color: Colors.grey),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    child: Divider(
                                      color: Colors.black,
                                      height: 36,
                                    ),
                                  ))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Total = ",
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "${(currentAmnt * (1 + selectedTaxRate / 100)).toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ],
                          )),
                      Expanded(
                          child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Text(
                          "NB: The calculation is based on the data fetched from http://jsonvat.com/",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
