/**
 * To use this class, you must wrap it in a stack widget in body:,
 *  first stack: background, second is the column widget etc.
 */
import 'package:flutter/material.dart';

class Background extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return new Center(
      child: new Image.asset(
              'images/bg.png',
              width: screenSize.width,
              height: screenSize.height,
              fit: BoxFit.fitHeight)
      );
  }
}

//  Scaffold buildUnAuthScreen() {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//          image: DecorationImage(
//               image: AssetImage('images/bg.png'),
//               fit: BoxFit.cover)
//         ),
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Family Repository',
//               style: TextStyle(
//                 fontFamily: "Signatra",
//                 fontSize: 70.0,
//                 color: Colors.white,
//               ),
//             ),
//             GestureDetector(
//               onTap: login,
//               child: Container(
//                 width: 200.0,
//                 height: 40.0,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(
//                       'images/google_signin_button.png',
//                     ),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );