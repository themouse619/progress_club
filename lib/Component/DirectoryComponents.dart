import 'package:flutter/material.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Screens/MemberDirectory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DirectoryComponents extends StatefulWidget {
  var directory;

  DirectoryComponents(this.directory);

  @override
  _DirectoryComponentsState createState() => _DirectoryComponentsState();
}

class _DirectoryComponentsState extends State<DirectoryComponents> {

  saveChapterId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.tempChapterId,widget.directory["ChapterId"].toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberDirectory(
            chapterName:widget.directory["ChapterName"],
      ),
    ));
    //Navigator.pushNamed(context, '/MemberDirectory');
  }

  saveCommitiesId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.tempChapterId,widget.directory["ChapterId"].toString());
    await prefs.setString(Session.CommitieId,widget.directory["ChapterId"].toString());
    Navigator.pushNamed(context, '/CommitieScreen');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemberDetails()));
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: cnst.appcolor)),
            side: BorderSide(width: 0.50, color: cnst.appPrimaryMaterialColor),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 8, left: 5),
                  child: Text(
                    '${widget.directory["ChapterName"]}',
                    style: TextStyle(
                        color: cnst.appPrimaryMaterialColor, fontSize: 18),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          //Navigator.pushReplacementNamed(context, '/MemberDirectory');
                          saveChapterId();
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 10) / 2.3,
                          height: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Text(''), Text('Acceptances')
                              Text(
                                '${widget.directory["MemberCount"]}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: cnst.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Member',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: cnst.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: Colors.grey[400],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, '/JustJoined');
                          saveCommitiesId();
                        },
                        child: Container(
                          height: 60,
                          width: (MediaQuery.of(context).size.width - 10) / 2.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Text('0'), Text('Just Joined')
                              Text(
                                '${widget.directory["CommitieCount"]}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: cnst.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Commities',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: cnst.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
