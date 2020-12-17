import 'package:aplikasipekerti/firebase_service/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BroadcastPage extends StatefulWidget {
  final String kirimNama;
  final String myStatus;
  BroadcastPage({this.myStatus, this.kirimNama});
  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  var chatLists = [];
  var emergencyLists = [];
  int indexx = 0;
  final _chatSend = TextEditingController();

  final chatReference = FirebaseDatabase.instance
      .reference()
      .child("chatlist")
      .orderByChild("waktukirimp").limitToFirst(10);
  final emergencyReference = FirebaseDatabase.instance
      .reference()
      .child("emergency")
      .orderByChild("waktukirime")
      .limitToFirst(10);

  void dispose() {
    super.dispose();
    _chatSend.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Broadcast Message",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _streamBroadcast(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Emergency Message",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _streamEmergency(),
                  widget.myStatus == "admin"
                      ? _textForm("Ketikkan Sesuatu", Icons.security, _chatSend)
                      : SizedBox(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _textForm(String formText, IconData formIcon, formState) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 75,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.80,
            height: 40,
            child: TextFormField(
              controller: formState,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  prefixIcon: Icon(formIcon),
                  //prefixText: "Email:",
                  prefixStyle: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                  hintText: formText,
                  hintStyle: TextStyle(
                      color: Colors.black12,
                      fontWeight: FontWeight.w400,
                      height: 0.5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Colors.blue))),
              //validator: (val) => val.isEmpty ? 'Isi Email Yang bener Woy' : null,
              /* onChanged: (val) {
                  setState(() {
                    formState = val;
                    print(formState);
                  });
                }*/
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
            onPressed: () async {
              String waktukirim =
                  DateFormat.yMd().add_Hms().format(DateTime.now());

              await DatabaseService.instance
                  .sendChat(_chatSend.text, widget.kirimNama, waktukirim);
              setState(() {
                _chatSend.text = "";
              });
            },
          )
        ],
      ),
    );
  }

  Widget _streamBroadcast() {
    return StreamBuilder(
        stream: chatReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.snapshot.value != null) {
              Map values = snapshot.data.snapshot.value;
              chatLists.clear();
              //print (values.toString());
              values.forEach((key, values) {
                chatLists.add(values);
              });
              chatLists.sort((a, b) {
                return a["waktukirimp"].compareTo(b["waktukirimp"]);
              });
              return chatLists.isNotEmpty
                  ? SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(border: Border.all()),
                        child: ListView.builder(
                          itemCount: chatLists.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 20,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            chatLists[index]["nama"],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            chatLists[index]["waktukirimp"],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        chatLists[index]["chat"],
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Text("There is no Data");
            } else {
              return Text("There is no Data");
            }
          }
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        });
  }

  Widget _streamEmergency() {
    return StreamBuilder(
        stream: emergencyReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.snapshot.value != null) {
              Map values = snapshot.data.snapshot.value;
              emergencyLists.clear();
              // print(values.toString());
              values.forEach((key, values) {
                emergencyLists.add(values);
              });
              emergencyLists.sort((a, b) {
                return a["waktukirime"].compareTo(b["waktukirime"]);
              });
              return emergencyLists.isNotEmpty
                  ? SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: ListView.builder(
                          itemCount: emergencyLists.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 20,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            emergencyLists[index]["name"],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            emergencyLists[index]
                                                ["waktukirime"],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        emergencyLists[index]["alamat"],
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Text("There is no Data");
            } else {
              return Text("There is no Data");
            }
          }
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        });
  }
}
