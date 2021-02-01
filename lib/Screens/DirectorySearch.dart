import 'dart:io';

import 'package:flutter/material.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/MemberSearchComponent.dart';

import '../Component/LoadinComponent.dart';
import '../Component/MemberDirectoryComponent.dart';

class DirectorySearch extends StatefulWidget {
  @override
  _DirectorySearchState createState() => _DirectorySearchState();
}

class _DirectorySearchState extends State<DirectorySearch> {
  bool isLoading = false;
  TextEditingController searchController = new TextEditingController();
  List list = new List();

  _getSearchData() async {
    try {
      if (searchController.text != null && searchController.text != "") {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          Future res = Services.getSearchMember(searchController.text);
          res.then((data) async {
            if (data != null && data.length > 0) {
              setState(() {
                isLoading = false;
                list = data;
              });
            } else {
              setState(() {
                list.clear();
                isLoading = false;
              });
              showMsg("Try Again.");
            }
          }, onError: (e) {
            print("Error : on searchMember Call $e");
            showMsg("Something went wrong.Please try agian.");
            setState(() {
              isLoading = false;
            });
          });
        }
      }else

        showMsg("Please Enter Any Value");
      //check Internet Connection
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    setState(() {
      list=[];
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cnst.appPrimaryMaterialColor,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'Search',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 110,
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, size: 22),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        hintText: "Search Member Name",
                        hintStyle: TextStyle(fontSize: 13)),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if(!isLoading){
                          _getSearchData();
                        }
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: cnst.appPrimaryMaterialColor,
                        ),
                        child: Center(
                            child: Text("Search",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white))),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                child: isLoading
                    ? LoadinComponent()
                    : list.length != 0 && list != null
                        ? ListView.builder(
                            padding: EdgeInsets.only(top: 5),
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MemberSearchComponent(list[index]);
                            })
                        : Container(
                            child: Center(
                                child: Text('No Data Found.',
                                    style: TextStyle(
                                        color: cnst.appPrimaryMaterialColor,
                                        fontSize: 20))),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
