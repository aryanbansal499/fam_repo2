import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../views/edit_page3.dart';

class YearList extends StatefulWidget {
  final Function function;
  const YearList({Key key, this.function}): super(key: key);

  @override
  _YearListState createState() => _YearListState(function);
}

class _YearListState extends State<YearList> {


  Function setYear;
  static String _dropdownValue;

  _YearListState(this.setYear);

  static const int START_YEAR = 2020;
  static const int LAST_YEAR = 1500;
  List<String> decades = [];
  List<DropdownMenuItem> listDrop = [];

//  @override
//  void initState() {
//    // TODO: implement initState
//    getYearList();
//  }

//

  void
  loadData() {
    //decades = [];
    decades = new List();

    for(int i = START_YEAR; i >= LAST_YEAR; i-=10) {
      decades.add(i.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    loadData();

    return new FormField(
        builder: (FormFieldState state) {

          return InputDecorator(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(40.0,5.0,40.0, 5.0),
              labelText: 'Year of Origin',

            ),
            isEmpty: _dropdownValue == '',
            child: new DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isDense: true,
                value: _dropdownValue,
                icon: Icon(Icons.arrow_drop_down, color: Colors.brown,),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black54),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {

                  setState(() {
                    setYear(_dropdownValue);
                    _dropdownValue = newValue;
                  });
                },
                hint: Text('Decade of Origin'),
                items: decades.map((decade) {
                  return new DropdownMenuItem(
                      value: decade,
                      child: new Text(decade)
                  );
                }).toList(),
              ),
            ),
          );
      },
    );


  }

  String getDropDownValue() {
    return _dropdownValue;
  }


}
