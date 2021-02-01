import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/BookScreenComponent.dart';

class BookScreen extends StatefulWidget {
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  Widget appBarTitle = Text("Books");
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  TextEditingController txtSearch = TextEditingController();
  bool isLoading = false;
  List booklistData = [];
  List _searchList = new List();

  @override
  void initState() {
    getBookListing();
  }

  List<BookScreen> _bookList = [];
  BookScreen _bookClass;

  bool isSearching = false;

  Widget buildAppbar(BuildContext context) {
    return AppBar(
      title: appBarTitle,
      actions: <Widget>[
        IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = Container(
                    child: TextField(
                      controller: txtSearch,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          prefixIcon:
                              new Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  );
//                  Padding(padding: EdgeInsets.only(top: 8));
//                  _bookClass != null
//                      ? booklistData.length > 0
//                          ? isSearching
//                              ? _searchList.length > 0
//                                  ? Expanded(
//                                      child: ListView.builder(
//                                        padding: EdgeInsets.all(0),
//                                        itemCount: _searchList.length,
//                                        itemBuilder:
//                                            (BuildContext context, int index) {
//                                          return Container(
//                                            width: MediaQuery.of(context)
//                                                .size
//                                                .width,
//                                            child: ExpansionTile(
//                                              trailing: Icon(
//                                                Icons.keyboard_arrow_down,
//                                                color: Color(0xff4c362f),
//                                              ),
//                                              title: Padding(
//                                                padding: const EdgeInsets.only(
//                                                    top: 15.0),
//                                                child: Column(
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.start,
//                                                  children: <Widget>[
//                                                    Text(
//                                                      "${_searchList[index]["Title"]}",
//                                                      style: TextStyle(
//                                                          fontWeight:
//                                                              FontWeight.bold,
//                                                          fontSize: 15,
//                                                          fontFamily:
//                                                              'Montserrat',
//                                                          color: Colors.black),
//                                                    ),
//                                                    Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              top: 3.0),
//                                                      child: Text(
//                                                        "${_searchList[index]["Author"]}",
//                                                        style: TextStyle(
//                                                            fontFamily:
//                                                                'Montserrat',
//                                                            fontSize: 15,
//                                                            color:
//                                                                Colors.black),
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                              ),
//                                              children: <Widget>[
//                                                Column(
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.start,
//                                                  children: <Widget>[
//                                                    Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              top: 10,
//                                                              left: 15.0,
//                                                              right: 15,
//                                                              bottom: 5),
//                                                      child: Row(
//                                                        mainAxisAlignment:
//                                                            MainAxisAlignment
//                                                                .spaceBetween,
//                                                        children: <Widget>[
//                                                          Padding(
//                                                            padding:
//                                                                const EdgeInsets
//                                                                        .only(
//                                                                    right: 15,
//                                                                    bottom: 3),
//                                                            child: Text(
//                                                              "${_searchList[index]["Subject"]}",
//                                                              style: TextStyle(
//                                                                  fontSize: 14,
//                                                                  color: Colors
//                                                                      .black,
//                                                                  fontFamily:
//                                                                      'Montserrat'),
//                                                            ),
//                                                          ),
//                                                          Padding(
//                                                            padding:
//                                                                const EdgeInsets
//                                                                        .only(
//                                                                    right: 5.0),
//                                                            child: Text(
//                                                              "${cnst.Inr_Rupee + " " + _searchList[index]["Price"]}",
//                                                              style: TextStyle(
//                                                                  color: Colors
//                                                                      .black),
//                                                            ),
//                                                          ),
//                                                        ],
//                                                      ),
//                                                    ),
//                                                    Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              left: 15.0,
//                                                              right: 15,
//                                                              bottom: 5),
//                                                      child: Text(
//                                                        "${_searchList[index]["NoOfPages"]} pages",
//                                                        style: TextStyle(
//                                                            fontSize: 14,
//                                                            color: Colors.black,
//                                                            fontFamily:
//                                                                'Montserrat'),
//                                                      ),
//                                                    ),
//                                                    Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              left: 8.0),
//                                                      child: SmoothStarRating(
//                                                          allowHalfRating:
//                                                              false,
//                                                          isReadOnly: true,
//
//                                                          /*onRatingChanged:
//                                      (v) {
//                                    rating = v;
//                                    setState(() {});
//                                  },*/
//                                                          starCount: 5,
//                                                          rating: _searchList[
//                                                                          index]
//                                                                      [
//                                                                      "Rating"] ==
//                                                                  ""
//                                                              ? 0
//                                                              : double.parse(
//                                                                  "${_searchList[index]["Rating"]}",
//                                                                ),
//                                                          size: 25.0,
//                                                          color: Colors.amber,
//                                                          //borderColor: Colors.green,
//                                                          spacing: 0.0),
//                                                    ),
//                                                    Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              left: 15.0,
//                                                              right: 15,
//                                                              bottom: 10),
//                                                      child: Row(
////                            crossAxisAlignment: CrossAxisAlignment.start,
//                                                        mainAxisAlignment:
//                                                            MainAxisAlignment
//                                                                .spaceBetween,
//                                                        children: <Widget>[
//                                                          Text(
//                                                            "${_searchList[index]["Language"]}",
//                                                            style: TextStyle(
//                                                                fontSize: 14,
//                                                                color: Colors
//                                                                    .black,
//                                                                fontFamily:
//                                                                    'Montserrat'),
//                                                          ),
//                                                          SizedBox(
//                                                            height: 35,
//                                                            width: MediaQuery.of(
//                                                                        context)
//                                                                    .size
//                                                                    .width -
//                                                                200,
//                                                            child: FlatButton(
//                                                              onPressed: () {
////                                              Navigator.push(
////                                                context,
////                                                MaterialPageRoute(
////                                                  builder: (context) =>
////                                                      IssueBook(
////                                                          title: "${widget
////                                                              .bookData["Title"]}",
////                                                          author: "${widget
////                                                              .bookData["Author"]}",
////                                                          id: "${widget
////                                                              .bookData["BookId"]}"),
////                                                ),
////                                              );
//                                                              },
//                                                              shape:
//                                                                  new RoundedRectangleBorder(
//                                                                borderRadius:
//                                                                    BorderRadius
//                                                                        .circular(
//                                                                            10),
//                                                              ),
//                                                              color: Colors
//                                                                  .deepPurple,
//                                                              child: Text(
//                                                                "Issue Book",
//                                                                style: TextStyle(
//                                                                    fontSize:
//                                                                        18,
//                                                                    color: Colors
//                                                                        .white),
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        ],
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                              ],
//                                            ),
//                                          );
//                                        },
//                                      ),
//                                    )
//                                  : NoDataComponent()
//                              : Expanded(
//                                  child: Expanded(
//                                    child: ListView.separated(
//                                      itemCount: booklistData.length,
//                                      itemBuilder:
//                                          (BuildContext context, int index) {
//                                        return BookScreenComponent(
//                                            booklistData[index]);
//                                      },
//                                      separatorBuilder:
//                                          (BuildContext context, int index) =>
//                                              Divider(),
//                                    ),
//                                  ),
//                                )
//                          : NoDataComponent()
//                      : Container();
                } else {
                  this.actionIcon = Icon(
                    Icons.search,
                    color: Colors.white,
                  );
                  this.appBarTitle = Text("Books");
                  // txtSearch.clear();
                }
              });
            }),
      ],
    );
  }

  getBookListing() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetBookListing();
        res.then((data) async {
          if (data != "" && data.length > 0) {
            setState(() {
              isLoading = false;
              booklistData = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppbar(context),
        body: isLoading == true
            ? Container(child: Center(child: CircularProgressIndicator()))
            : booklistData.length > 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ListView.separated(
                          itemCount: booklistData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BookScreenComponent(booklistData[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                        ),
                      ),
                    ],
                  )
                : Container(
                    child: Center(
                      child: Text("No Books available"),
                    ),
                  ));
  }
}
