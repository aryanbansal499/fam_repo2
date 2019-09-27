// Define a custom Form widget.
//adapted from https://flutter.dev/docs/cookbook/forms/focus
import 'package:flutter/material.dart';
import 'package:fam_repo2/artefact_type.dart';
import 'package:fam_repo2/background.dart';
import 'package:fam_repo2/image_banner.dart';
import 'package:fam_repo2/validation.dart';

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.

  //Each field has a different focus node, will focus on field when tapped
  FocusNode nameFocusNode;
  FocusNode descriptionFocusNode;
  FocusNode dateFocusNode;
  FocusNode tagFocusNode;
  FocusNode currentFocusNode;

  //controllers
  TextEditingController _editingController;
  ScrollController scrollController;

  //store artefact details
  String name;
  String description;
  DateTime dateTime;
  var tagList = new List<String>();

  // String text = "Nothing to show";

  // final ArtefactType _artefactType;
  // final var _artefact;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameFocusNode = new FocusNode();
    descriptionFocusNode = new FocusNode();
    dateFocusNode = new FocusNode();
    tagFocusNode = new FocusNode();

    currentFocusNode = nameFocusNode;
    _editingController = new TextEditingController();
    scrollController = new ScrollController();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    currentFocusNode.dispose();

    super.dispose();
  }

  //converting string to a date formate. still no idea how
  void stringToDate(String dateEntered) {
    if(dateEntered != null) {
      var dateTime = DateTime.parse('12-12-2012 0:0');
      print(dateTime);
    }
  }


  //add a user-defined tag to the tagList
  void addTagToList(String tag) {
    tagList.add(tag);

    print("=======================");
    for(int i=0; i < tagList.length; i++) {
      print(tagList[i]);

    }
    print("=======================");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 1.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            //children: arrow + title
            children: const <Widget>[
              Icon(
                Icons.arrow_back,
                color: Colors.brown,
                size: 30.0,
                semanticLabel: 'icon to go back to previous page'
              ),
              Text('ADD ARTEFACT', textAlign: TextAlign.center)]
              ),
            centerTitle: true),
      body:
      //background is first in stack, then the column
      Stack(
        children: <Widget>[
          new Background(),
          //whole column wrapped in padding
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              controller: scrollController,
              children: [
                ImageBanner('images/abaca-gold.jpg'),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                      validator: (value) {
                        return value.isEmpty ? 'Enter a name for the artefact' : null;
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey,
                        labelText: 'Enter the name of the artefact',
                        hintText:'Name ',
                      ),
                      onFieldSubmitted: (nameEntered) {
                        this.name = nameEntered;
                        print(this.name);
                        currentFocusNode = descriptionFocusNode;
                      }
                    ),
                    TextFormField(
                      focusNode: descriptionFocusNode,
                      validator: (value) {
                        return value.isEmpty ? 'Enter a description for the artefact' : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter a description about the artefact',
                        labelText: 'Description ',
                      ),
                      onFieldSubmitted: (descriptionEntered) {
                        this.description = descriptionEntered;
                        print(this.description);
                        currentFocusNode = dateFocusNode;
                      },

                    ),
                    FlatButton(
                      onPressed: () {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1500),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                  data: ThemeData.light(),
                                  child: child
                              );
                            }
                        );
                      },
                      child: Text(
                          'Date',
                          style: TextStyle(color: Colors.blue),
                        )
                    ),


                    // The first text field is focused on as soon as the app starts.
                    TextFormField(
                      focusNode: dateFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter the date the artefact originated',
                        labelText: 'Date (dd/mm/yyyy) ',
                      ),
                      validator: DateValidator.validate,
                      onFieldSubmitted: (dateEntered) {
                        stringToDate(dateEntered);
                        //TODO: dateEntered to datetime type
                        print(this.dateTime);
                        currentFocusNode = tagFocusNode;

                      },
                      // onTap: (){
                      //   scrollController.jumpTo(-400);
                      // }
                    ),
                    // The second text field is focused on when a user taps the
                    // FloatingActionButton.
                    TextFormField(
                      controller: _editingController,
                      focusNode: tagFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter tags related to the artefact',
                        labelText: 'Tags: ',
                      ),
                      onTap: (){
                        _editingController.text = "";
                      },
                      onFieldSubmitted: (tag){
                        addTagToList(tag);
                        _editingController.text = "";
                        _editingController.text = tagList.toString();

                        //TODO: displayTag(tag), deleting tags;
                      },
                    )
                  ]
                )
              )
            ]
          )
        )
      ]
    ),


      floatingActionButton: FloatingActionButton(
        // When the button is pressed,
        // give focus to the text field using myFocusNode.
        onPressed: () => FocusScope.of(context).requestFocus(currentFocusNode),
        tooltip: 'Focus Second Text Field',
        child: Icon(Icons.edit),
        backgroundColor: Colors.white70,
        hoverColor: Colors.black,

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

   

}