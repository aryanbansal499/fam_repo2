// Define a custom Form widget.
//adapted from https://flutter.dev/docs/cookbook/forms/focus
import 'package:flutter/material.dart';
import 'package:fam_repo2/artefact_type.dart';
import 'package:fam_repo2/background.dart';
import 'package:fam_repo2/image_banner.dart';
import 'package:fam_repo2/validation.dart';
import 'package:intl/intl.dart';
import 'package:fam_repo2/drop_down_button.dart';

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
  TextEditingController _dateController;
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
  bool _autoValidate = false;
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


  //add a user-defined tag to the tagList
  void addTagToList(String tag) {
    tagList.add(tag);

    print("=======================");
    for(int i=0; i < tagList.length; i++) {
      print(tagList[i]);

    }
    print("=======================");
  }

  void removeTagFromList(String tag) {
    int tagIndex;

    if(tagList.contains(tag)) {

    }
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
              IconButton(
                icon: Icon(Icons.arrow_back,
                color: Colors.brown,
                size: 30.0,
                semanticLabel: 'icon to go back to previous page'
                ),
              ),
              Text('ADD ARTEFACT', textAlign: TextAlign.center)]
              ),
            centerTitle: true),
      body:
      //background is first in stack, then the column
      Stack(
        children: <Widget>[
          //background, then padding on top
          new Background(),
          //whole column wrapped in padding
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: scrollController,
              children: [
                ImageBanner('images/abaca-gold.jpg'),
                Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: NameValidator.validate,
                        focusNode: nameFocusNode,
                        autofocus: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          labelText: 'Enter the name of the artefact',
                          hintText:'Name ',
                        ),
                        onSaved: (String value) {
                          this.name = value;
                        },
                        onFieldSubmitted: (nameEntered) {
                          this.name = nameEntered;
                          print(this.name);

                          _fieldFocusChange(context, nameFocusNode, descriptionFocusNode);
                        },
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: descriptionFocusNode,
                        validator: DescriptionValidator.validate,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Enter a description about the artefact',
                          labelText: 'Description ',
                        ),
                        onSaved: (String value) {
                          this.description = value;
                        },
                        onFieldSubmitted: (descriptionEntered) {
                          _fieldFocusChange(context, descriptionFocusNode, dateFocusNode);
                        },
                      ),
                      YearList(),
                        // The first text field is focused on as soon as the app starts.
                      TextFormField(
                        controller: _dateController,
                        textInputAction: TextInputAction.next,
                        focusNode: dateFocusNode,
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.datetime,
                        maxLines: 1,
                        onTap: _pickDate,
                        decoration: InputDecoration(
                          hintText: 'Enter the date the artefact originated',

                          labelText: 'Date (dd/mm/yyyy) ',
                        ),
                        validator: DateValidator.validate,

                        onFieldSubmitted: (dateEntered) {
//                        stringToDate(dateEntered);
//                        //TODO: dateEntered to datetime type
//                        print(this.dateTime);
//
//                        //validate if date entered is correct
//                        bool validated = _formKey.currentState.validate() == null;
//                        print('date validated: ' + validated.toString());
//
//                        if(!validated) {
//                          print('validated');
                          _fieldFocusChange(context, dateFocusNode, tagFocusNode);
//                        }

                        },
//                      onEditingComplete: () {
//                        _formKey.currentState.validate();
//                        currentFocusNode = tagFocusNode;
//                      },
                      ),
                      FlatButton(
                        onPressed: _pickDate,
                        child: Text(
                        'Date',
                        style: TextStyle(color: Colors.blue),
                        )
                      ),
                    // The second text field is focused on when a user taps the
                    // FloatingActionButton.
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: _editingController,
                        focusNode: tagFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Enter tags related to the artefact',
                          labelText: 'Tags: ',
                        ),
                        maxLines: 1,
                        onTap: (){
                          _editingController.text = "";
                        },
                        onFieldSubmitted: (tag){
                          addTagToList(tag);
                          _editingController.text = "";
                          _editingController.text = tagList.toString();

                          //TODO: displayTag(tag), deleting tags;
                          //validate if description entered is correct
                        },
                      ),
                      RaisedButton.icon(
                          onPressed: _validateInputs,
                          icon: Icon(Icons.add),
                          label: Text('Submit'),
                      )
                  ]
                )
              )
            ],
          )
        )
      ]
    ),
    floatingActionButton: FloatingActionButton(
        // When the button is pressed,
        // give focus to the text field using myFocusNode.
        onPressed: () {
          FocusScope.of(context).requestFocus(currentFocusNode);
        },
        tooltip: 'Focus Second Text Field',
        child: Icon(Icons.edit),
        backgroundColor: Colors.white70,
        hoverColor: Colors.black,

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //goes to the next text field
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
    currentFocusNode = nextFocus;
  }


  void
  _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms was validated.
      form.save();
    } else {
      setState(() => _autoValidate = true);
    }
  }

  YearList
  _pickYear() {
    return new YearList();
  }

  void
  _pickDate() async {
    DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
    DateTime picked;


    picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.year,
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

    if (picked != null && picked != dateTime){
      setState(() {
        dateTime = picked;
      }
      );
    }
    dateFormat.format(picked);

    print(" picked: " + picked.toString());

  }


}