// Define a custom Form widget.
//adapted from https://flutter.dev/docs/cookbook/forms/focus
import 'package:flutter/material.dart';
import 'package:fam_repo2/image_banner.dart';

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.
  FocusNode nameFocusNode;
  FocusNode descriptionFocusNode;
  FocusNode dateFocusNode;
  FocusNode tagFocusNode;

  FocusNode currentFocusNode;
  TextEditingController _editingController;
  ScrollController scrollController;

  String name;
  String description;
  DateTime dateTime;
  var tagList = new List();

  String text = "Nothing to show";

  @override
  void initState() {
    super.initState();

    nameFocusNode = new FocusNode();
    descriptionFocusNode = new FocusNode();
    dateFocusNode = new FocusNode();

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

  void stringToDate(String dateEntered) {
    if(dateEntered != null) {
      var dateTime = DateTime.parse('12-12-2012 0:0');
      print(dateTime);
    }
  }


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
          Color: Colors.transparent,
          bottomOpacity: 1.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
      body: Padding(
        // padding: EdgeInsets.only(
        //      bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          controller: scrollController,
          children: [
            ImageBanner('images/Sitar-British-museum.jpg'),
            TextFormField(
              autofocus: true,
              controller: _editingController,
              validator: (value) {
                if(value.isEmpty){
                  return 'Please enter a date in this format dd/mm/yyyy';
                }
                //TODO: convert value to date
                return null;
              },
              decoration: InputDecoration(
              labelText: 'Enter the name of the artefact',
              hintText:'Name '
              ),
              onFieldSubmitted: (nameEntered) {
                this.name = nameEntered;
                print(this.name);
                currentFocusNode = descriptionFocusNode;
              }
            ),
            TextFormField(
              focusNode: descriptionFocusNode,
              decoration: InputDecoration(
                hintText: 'Enter a description about the artefact',
                labelText: 'Description ',
              ),
              onFieldSubmitted: (descriptionEntered) {
                this.description = descriptionEntered;
                print(this.description);
                currentFocusNode = dateFocusNode;
              },
              // onTap: (){
              //   scrollController.jumpTo(-200);}
              
            ),
            // The first text field is focused on as soon as the app starts.
            TextFormField(
              focusNode: dateFocusNode,
              decoration: InputDecoration(
                hintText: 'Enter the date the artefact originated',
                labelText: 'Date (dd/mm/yyyy) ',
              ),
              
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
            TextField(
              controller: _editingController,
              focusNode: tagFocusNode,
              decoration: InputDecoration(
                hintText: 'Enter tags related to the artefact',
                labelText: 'Tags: ',
              ),
              onSubmitted: (tag) {
                addTagToList(tag);
              },
            ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the button is pressed,
        // give focus to the text field using myFocusNode.
        onPressed: () => FocusScope.of(context).requestFocus(currentFocusNode),
        tooltip: 'Focus Second Text Field',
        child: Icon(Icons.edit),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

   

}