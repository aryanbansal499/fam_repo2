import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_repo2/models/Profile.dart';
import 'package:fam_repo2/pages/home.dart';
import 'package:flutter/material.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  clearSearch()
  {
    searchController.clear();
  }
  handleSearch(String query)
  {
    Future<QuerySnapshot> users =usersRef.where("displayName",isGreaterThanOrEqualTo: query)
    .getDocuments();
    setState(() {
     searchResultsFuture = users; 
    });
  }
  AppBar buildSearchField() {
    return AppBar(
        backgroundColor: Colors.brown,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search for a user...",
            filled: false,
            prefixIcon: Icon(
              Icons.account_box,
              size: 25.0,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              color: Colors.black,
              icon: Icon(Icons.clear),
              onPressed: () => clearSearch,
            ),
          ),

          onFieldSubmitted: handleSearch,
        ));
  }

  Container buildNoContent() {
    return Container(
      decoration: BoxDecoration(
         image: DecorationImage(
              image: AssetImage('images/bg.png'),
              fit: BoxFit.cover)
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
            
              Text(
                "Find Users",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 60.0,
                ),
              ),
            ],
          ),
        ),
    );
  }

buildSearchResults()
{
  return FutureBuilder
  (
    future: searchResultsFuture,
    builder: (context, snapshot)
    {
      if(!snapshot.hasData)
      {
        return CircularProgressIndicator();
      }
      List<Text> searchResults = [];
      snapshot.data.documents.forEach((doc)
      {
        Profile user = Profile.fromDocument(doc);
        searchResults.add(Text(user.username));
        

      });
      return ListView
      (
        children: searchResults,

      );
    }
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildNoContent(): buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}
