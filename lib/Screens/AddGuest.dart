import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class AddGuest extends StatefulWidget {
  @override
  _AddGuestState createState() => _AddGuestState();
}

class _AddGuestState extends State<AddGuest> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtCity = new TextEditingController();
  TextEditingController txtState = new TextEditingController();

  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  bool isLoading = false;
  String temp = "Select your state";
  String temp1 = "Select your City";

  _addGuest() async {
    print(temp);
    print(temp1);
    if (txtName.text != "" &&
        txtMobile.text != "" &&
        txtMobile.text.length == 10 &&
        temp1 != "Select your City" &&
        temp != "Select your state") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String memberId = prefs.getString(Session.MemberId);

          var data = {
            'type': 'insertguest',
            'Name': txtName.text.trim(),
            'MobileNo': txtMobile.text.trim(),
            'MemberId': memberId,
            'City': temp1.trim(),
            'State': temp.trim(),
          };

          Services.AddGuest(
            'insertguest',
            txtName.text.trim(),
            txtMobile.text.trim(),
            memberId,
            temp1.trim(),
            temp.trim(),
          ).then((data) async {
            print("data");
            print(data);
            setState(() {
              isLoading = false;
            });
            if (data.IsSuccess == true) {
              Fluttertoast.showToast(
                  msg: "Guest Added Successfully",
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_SHORT);
              Navigator.pushReplacementNamed(context, "/EventGuest");
            } else {
              // showMsg(data.);
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showMsg("Try Again.");
          });
        } else {
          showMsg("No Internet Connection.");
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please Try Again",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  void initState() {
    super.initState();
    _getStatesCities();
  }

  List stateandcities = [];
  List<String> states = [], cities = [];

  _getStatesCities() async {
    // if (txtName.text != "" &&
    //     txtMobile.text != "" &&
    //     txtMobile.text.length == 10 &&
    //     txtCity.text != "" &&
    //     txtState.text != "") {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.MemberId);

        Services.getStatesCities().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != "") {
            print("statecitiesdata");
            stateandcities = data;
            for (int i = 0; i < stateandcities.length; i++) {
              if (!states.contains(stateandcities[i]["state"])) {
                states.add(stateandcities[i]["state"]);
                states.sort();
              }
            }
            print("states");
            print(states);
            // Fluttertoast.showToast(
            //     msg: "Guest Added Successfully",
            //     backgroundColor: Colors.green,
            //     gravity: ToastGravity.TOP,
            //     toastLength: Toast.LENGTH_SHORT);
            // Navigator.pushReplacementNamed(context, "/EventGuest");
          } else {
            //showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
    // }
    // else {
    //   Fluttertoast.showToast(
    //       msg: "Please Try Again",
    //       backgroundColor: Colors.redAccent,
    //       textColor: Colors.white,
    //       gravity: ToastGravity.BOTTOM,
    //       toastLength: Toast.LENGTH_SHORT);
    // }
  }

  showMsg(String msg) {
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
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
    if (permissionRequestResult[permission] == PermissionStatus.granted)
      Navigator.pushReplacementNamed(context, "/ContactList");
    else
      Fluttertoast.showToast(
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
  }

  // Map<String,List> frequencyOptions = stateandcities;

  @override
  Widget build(BuildContext context) {
    print(stateandcities);
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/EventGuest");
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/EventGuest");
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: cnst.appPrimaryMaterialColor,
            ),
          ),
          actionsIconTheme: IconThemeData.fallback(),
          title: Text(
            "Add Guest",
            style: TextStyle(
                color: cnst.appPrimaryMaterialColor,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: isLoading
            ? LoadinComponent()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 6),
                      child: TextFormField(
                        controller: txtName,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(
                              Icons.person,
                              //color: cnst.appPrimaryMaterialColor,
                            ),
                            hintText: "Guest Name"),
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: txtMobile,
                        scrollPadding: EdgeInsets.all(0),
                        maxLength: 10,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(
                              Icons.call,
                            ),
                            counterText: "",
                            hintText: "Mobile Number"),
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 10, top: 6),
                    //   child: TextFormField(
                    //     controller: txtCity,
                    //     scrollPadding: EdgeInsets.all(0),
                    //     decoration: InputDecoration(
                    //         border: new OutlineInputBorder(
                    //             borderSide: new BorderSide(color: Colors.black),
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(10))),
                    //         prefixIcon: Icon(
                    //           Icons.place,
                    //           //color: cnst.appPrimaryMaterialColor,
                    //         ),
                    //         hintText: "City"),
                    //     keyboardType: TextInputType.text,
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 10),
                    //   child: TextFormField(
                    //     controller: txtState,
                    //     scrollPadding: EdgeInsets.all(0),
                    //     maxLength: 10,
                    //     decoration: InputDecoration(
                    //         border: new OutlineInputBorder(
                    //             borderSide: new BorderSide(color: Colors.black),
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(10))),
                    //         prefixIcon: Icon(
                    //           Icons.location_city,
                    //         ),
                    //         counterText: "",
                    //         hintText: "State"),
                    //     keyboardType: TextInputType.text,
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    // ),
                    SizedBox(
                      child: InputDecorator(
                        decoration: new InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          //labelText: "",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            //isDense: true,
                            hint: new Text(temp),
                            // value: _memberClass,
                            onChanged: (val) {
                              print(val);
                              cities = [];
                              for (int i = 0; i < stateandcities.length; i++) {
                                if (stateandcities[i]["state"] ==
                                    val.toString()) {
                                  cities.add(stateandcities[i]["name"]);
                                  cities.sort();
                                }
                              }
                              print("cities");
                              print(cities);
                              setState(() {
                                temp = val;
                              });
                            },
                            //value: temp,
                            items: states
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: new TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      width: (MediaQuery.of(context).size.width - 40),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: InputDecorator(
                        decoration: new InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          //labelText: "",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            //isDense: true,
                            hint: new Text(temp1),
                            // value: _memberClass,
                            onChanged: (val) {
                              setState(() {
                                temp1 = val;
                              });
                            },
                            //value: temp1,
                            items: cities
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: new TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      width: (MediaQuery.of(context).size.width - 40),
                    ),
                    // Text(
                    //   "OR",
                    //   style: TextStyle(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w600,
                    //       color: cnst.appPrimaryMaterialColor),
                    // ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width / 1.6,
                    //   margin: EdgeInsets.only(top: 10),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.all(Radius.circular(10))),
                    //   child: MaterialButton(
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: new BorderRadius.circular(10.0)),
                    //     color: Colors.green,
                    //     onPressed: () {
                    //       requestPermission(PermissionGroup.contacts);
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: <Widget>[
                    //         Icon(
                    //           Icons.contact_phone,
                    //           color: Colors.white,
                    //           size: 17,
                    //         ),
                    //         Text(
                    //           "Choose From Contact List",
                    //           style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 13,
                    //               fontWeight: FontWeight.w600),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      margin: EdgeInsets.only(top: 10),
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: cnst.appPrimaryMaterialColor,
                        minWidth: MediaQuery.of(context).size.width - 20,
                        onPressed: () {
                          _addGuest();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
