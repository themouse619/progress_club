import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class WebViewPayment extends StatefulWidget {
  var data;

  WebViewPayment(this.data);

  @override
  _WebViewPaymentState createState() => _WebViewPaymentState();
}

class _WebViewPaymentState extends State<WebViewPayment> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  String cancelLbl="Cancel";
  ProgressDialog pr;
  bool isLoading=true;
  void initState() {
    super.initState();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal,isDismissible: false);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(cnst.appPrimaryMaterialColor),),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    createRequest(); //creating the HTTP request
// Add a listener on url changed
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if (url.contains('http://www.example.com/redirect')) {
          Uri uri = Uri.parse(url);
//Take the payment_id parameter of the url.
          String paymentRequestId = uri.queryParameters['payment_id'];
//calling this method to check payment status
          _checkPaymentStatus(paymentRequestId);
        }
      }
    });

  }


  @override
  void dispose() {
    flutterWebviewPlugin.close();
  } //
  Future createRequest() async {
    //pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String FirstName = prefs.getString(Session.Name);
    String Email = prefs.getString(Session.Email);
    String Mobile = prefs.getString(Session.Mobile);

    print("Mobile No = ${Mobile}");

    Map<String, String> body = {
      "amount": "${widget.data["Charges"]}", //amount to be paid
      "purpose": "Guest",
      "buyer_name": "${FirstName}",
      "email": "${Email}",
      "phone": "${Mobile}",
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url": "http://www.example.com/redirect/",
      "webhook": "http://www.example.com/webhook/"
    };

//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http.post(
        Uri.encodeFull("https://www.instamojo.com/api/1.1/payment-requests/"),
        //Uri.encodeFull("https://test.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "5eeea98dca59fb1f315874bcefb0a65f",
          "X-Auth-Token": "744c6d69d38c4687c02953e26445764b",
          /*"X-Api-Key": "test_377f6f04fa940336f8448abb7cf",
          "X-Auth-Token": "test_b2f632c60012c57c4d156a9e462",*/
        },
        body: body);
    print("Respo = ${resp.body}");

    if (json.decode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      //pr.hide();
      String selectedUrl =
          json.decode(resp.body)["payment_request"]['longurl'].toString() +
              "?embed=form";
      flutterWebviewPlugin.close();
//Let's open the url in webview.
      flutterWebviewPlugin.launch(
        selectedUrl,
        rect: new Rect.fromLTRB(
            5.0,
            MediaQuery.of(context).size.height / 7,
            MediaQuery.of(context).size.width - 5.0,
            7 * MediaQuery.of(context).size.height / 7),
        //userAgent: kAndroidUserAgent
      );
    } else {
      //_showSnackbar(json.decode(resp.body)['message'].toString());
      //pr.hide();
      flutterWebviewPlugin.close();
      showFailedDialog();
      print(
          "GGGGGG = ${json.decode(resp.body)['message']["amount"].toString()}");
    }
    setState(() {
      isLoading=false;
    });
  }

  showSucDialog(String PaymentIs) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Success!',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        'Your payment is complete.',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        "Your Transaction ID Is ${PaymentIs}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    /*SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )*/
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      margin: EdgeInsets.only(top: 40),
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0)),
                        color: Colors.green,
                        minWidth: MediaQuery.of(context).size.width / 2,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/Dashboard', (Route<dynamic> route) => false);
                        },
                        child: Text(
                          "Continue",
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
        });
  }

  showFailedDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: cnst.appPrimaryMaterialColor,
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Oh no!',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        'Something went wrong.\nPlease try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor, fontSize: 18),
                      ),
                    ),
                    /*SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )*/
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      margin: EdgeInsets.only(top: 40),
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0)),
                        color: cnst.appPrimaryMaterialColor,
                        minWidth: MediaQuery.of(context).size.width / 2,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/Dashboard', (Route<dynamic> route) => false);
                        },
                        child: Text(
                          "OK",
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
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        /*if(flutterWebviewPlugin.show()==false){
          flutterWebviewPlugin.close();
          Navigator.pushReplacementNamed(context, '/Dashboard');
        }*/
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upgrading"),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                flutterWebviewPlugin.close();
                //showSucDialog();
                showFailedDialog();
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${cancelLbl}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
          /*leading: GestureDetector(
            onTap: () {
              if(flutterWebviewPlugin.show()==false){
                flutterWebviewPlugin.close();
                Navigator.pushReplacementNamed(context, '/Dashboard');
              }
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),*/
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoading==true?LoadinComponent():Container(),
        ),
      ),
    );
  }

  _checkPaymentStatus(String id) async {

    var response = await http.get(
        Uri.encodeFull("https://www.instamojo.com/api/1.1/payments/$id/"),
       // Uri.encodeFull("https://test.instamojo.com/api/1.1/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "5eeea98dca59fb1f315874bcefb0a65f",
          "X-Auth-Token": "744c6d69d38c4687c02953e26445764b",
          /*"X-Api-Key": "test_377f6f04fa940336f8448abb7cf",
          "X-Auth-Token": "test_b2f632c60012c57c4d156a9e462",*/
          "X-XSS-Protection": "0; mode=block"
        });
    setState(() {
      cancelLbl="";
    });
    var realResponse = json.decode(response.body);
    print("Final Response = ${realResponse}");
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
//payment is successful.
        /*SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(cnst.Session.MemberPayment, "true");*/

        flutterWebviewPlugin.close();
        await RegisterForMeeting(realResponse["payment"]['payment_id'].toString());
        await showSucDialog(realResponse["payment"]['payment_id'].toString());
        //Navigator.pushReplacementNamed(context, '/Suc');
      } else {
        /*SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(cnst.Session.MemberPayment, "false");*/
        flutterWebviewPlugin.close();
//payment failed or pending.
        showFailedDialog();
        //Navigator.pushReplacementNamed(context, '/failed');
      }
    } else {
      /*SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(cnst.Session.MemberPayment, "false");*/
      flutterWebviewPlugin.close();
      showFailedDialog();
      print("PAYMENT STATUS FAILED");
    }
  }

  showMsg(String msg, {String title = 'Saubhagya'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
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

  RegisterForMeeting(String tId) async {
    print('Call');
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var data = {
          'Id': 0,
          'MemberId': MemberId,
          'MeetingId': widget.data["Id"].toString(),
          'Date': DateTime.now().toString(),
          'SubstituteName': "",
          'SubstituteMobile': "",
          'Reg_Type': "coming",
          'PaymentRefNo': tId.toString(),
          'PaymentAmount': widget.data["Charges"],
        };
        Services.AddMeetingConformation(data).then((data) async {
          if (data.Data == "1" && data.IsSuccess == true) {
            setState(() {
              isLoading = false;
            });
            showMsg("Progress Club",title: data.Message);
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("Progress Club",title: data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Error",title: "Try Again.");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("Progress Club",title: "No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Progress Club",title: "No Internet Connection.");
    }
  }

  /*sendMemberPaymentId(String tId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Duration dd=new Duration(days: int.parse(widget.data["Duration"].toString()));
        DateTime selectExpDate = new DateTime.now().add(dd);
        await prefs.setString(cnst.Session.MemberPaymentEXPDate,
            selectExpDate.toString());
        print("Final Date = ${selectExpDate}");

        var formData = {
          "Id": "0",
          "MemberId": MemberId,
          "PackageId": widget.data["Id"].toString(),
          "ExpDate": selectExpDate.toString(),
          "RefNo": tId.toString(),
          "PaymentMode": "Instamojo",
          "Amount": widget.data["Amount"].toString(),
        };
        print("SaveMemberPackage Data = ${formData}");
        //widget.onChange("show");
        Services.PostServiceForSave("SaveMemberPackage", formData).then((data) async {
          //widget.onChange("hide");
          if (data.Data == "1" && data.IsSuccess == true) {
          } else {
            //showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          //widget.onChange("hide");
          //showMsg("Try Again.");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }*/
}
