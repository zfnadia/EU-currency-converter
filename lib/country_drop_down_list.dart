import 'package:flutter/material.dart';
import 'package:eu_currency_converter/tax.dart';

class CountryDropDownList extends StatefulWidget {
  final List<Tax> taxList;
  final Function onCountrySelectedCallback;

  CountryDropDownList({this.taxList, this.onCountrySelectedCallback});

  @override
  _CountryDropDownListState createState() => new _CountryDropDownListState();
}

class _CountryDropDownListState extends State<CountryDropDownList> {
  Tax selectedTax;

  @override
  Widget build(BuildContext context) {
//    selectedTax = widget.taxList[0];
    return Container(
      width: 210.0,
      margin: EdgeInsets.only(left: 20.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
            alignedDropdown: true,
            child: Center(
              child: DropdownButton<Tax>(
                isExpanded: true,
                hint: Text("Select"),
                style: Theme.of(context).textTheme.title,
                value: selectedTax,
                onChanged: (Tax changedValue) {
                  setState(() {
                    selectedTax = changedValue;
                  });
                  widget.onCountrySelectedCallback(changedValue);
                  //Navigator.pop(context);
                },
                items: widget.taxList.map((tax) {
                  return DropdownMenuItem<Tax>(
                    value: tax,
                    child: Text(tax.countryName),
                  );
                }).toList(),
              ),
            )),
      ),
    );
  }
}
