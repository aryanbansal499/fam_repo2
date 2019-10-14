import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YearList extends StatefulWidget {
  @override
  _YearListState createState() => _YearListState();
}

class _YearListState extends State<YearList> {

  String _dropdownValue;
  static const int START_YEAR = 2019;
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

    for(int i = START_YEAR; i >= LAST_YEAR; i--) {
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
                icon: Icon(Icons.arrow_downward, color: Colors.black,),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black54),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
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
}
