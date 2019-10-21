import 'package:flutter/material.dart';

import '../style.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
        ButtonBar(
        children: <Widget>[
          Text('Back to family',
              style: TextStyle(fontFamily: FontNameSubtitle,
                fontSize: 23,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.underline,
                color: GoldAccentColourDark,),),
        ],
        ),
      ],
    );
  }

}
