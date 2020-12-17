import 'package:aplikasipekerti/firebase_service/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AnakkosList extends StatefulWidget {
  @override
  _AnakkosListState createState() => _AnakkosListState();
}

class _AnakkosListState extends State<AnakkosList> {
  var anakkosLists = [];
  String _valChange;
  final anakkosReference =
      FirebaseDatabase.instance.reference().child("profile").onValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
              stream: anakkosReference,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map values = snapshot.data.snapshot.value;
                  //  print("Data Mentah : " + snapshot.data.snapshot.value);
                  //print("Data Mentah data : " + snapshot.data.toString());
                  //print("Data Mentah snapshot : " + snapshot.toString());
//                   print(values);
                  anakkosLists.clear();
                  // values["status"] == "anakkos" ? jumlahanakkos++ :null;
                  //print(values.toString());
                  values.forEach((key, values) {
                    //   values["status"] == "anakkos"
                    //       ? jumlahanakkos++
                    //       : values["status"] == "warga"
                    //           ? jumlahWarga++
                    //           : jumlahanakKos++;
                    anakkosLists.add(values);
                  });
                  // print("anakkos :" + jumlahanakkos.toString());
                  // print("warga :" + jumlahWarga.toString());
                  // print("kos :" + jumlahanakKos.toString());

                  // return FutureBuilder(
                  //     future: anakkosReference,
                  //     builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  //       if (snapshot.hasData) {
                  //         Map<dynamic, dynamic> values = snapshot.data.value;
                  //         print(values);
                  //         anakkosLists.clear();
                  //         //values["status"] == "anakkos" ? jumlahanakkos++ :null;
                  //         values.forEach((key, values) {
                  //           values["status"] == "anakkos"
                  //               ? jumlahanakkos++
                  //               : values["status"] == "warga"
                  //                   ? jumlahWarga++
                  //                   : jumlahanakKos++;
                  //           anakkosLists.add(values);
                  //         });
                  //         print("anakkos :" + jumlahanakkos.toString());
                  //         print("warga :" + jumlahWarga.toString());
                  //         print("kos :" + jumlahanakKos.toString());

                  return new ListView.builder(
                      itemCount: anakkosLists.length,
                      itemBuilder: (BuildContext context, int index) {
                        List _statusChange = ["admin", "warga"];

                        return anakkosLists[index]["status"] == "anakkos"
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.white,
                                elevation: 10,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 75,
                                        width: 75,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/pengabdiancctv.appspot.com/o/profile%2F"+
                                                anakkosLists[index]["uid"]
                                                +"%2Fprofilepicture?alt=media&token=00a3a705-7df0-48da-8d96-74b2b9dbf459"))),
                                      ),
                                    ),
                                    VerticalDivider(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
//                                          height: 75,
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Text(
                                                    "Nama   : " +
                                                        anakkosLists[index]
                                                            ["name"],
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                      "No KTP :" +
                                                          anakkosLists[index]
                                                              ["noktp"],
                                                      textAlign:
                                                          TextAlign.left),
                                                  Container(
                                                    width: 230,
                                                    child: Text(
                                                      "Alamat : " +
                                                          anakkosLists[index]
                                                              ["alamat"],
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                              child: InkWell(
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: ShapeDecoration(
                                                      shape: CircleBorder(),
                                                      color: Colors.red,
                                                    ),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 19,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    DatabaseService.instance
                                                        .userremoveData(
                                                            anakkosLists[index]
                                                                    ["uid"]
                                                                .toString());
                                                  }),
                                            ),
                                            DropdownButton(
                                              hint: Text("Ganti Status"),
                                              value: _valChange,
                                              items: _statusChange.map((value) {
                                                return DropdownMenuItem(
                                                  child: Text(value),
                                                  value: value,
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _valChange = value;
                                                });
                                              },
                                            ),
                                            InkWell(
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: ShapeDecoration(
                                                    shape: CircleBorder(),
                                                    color: Colors.blue,
                                                  ),
                                                  child: Icon(
                                                    Icons.send,
                                                    color: Colors.white,
                                                    size: 19,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  await DatabaseService.instance
                                                      .changeStatus(
                                                          anakkosLists[index]
                                                                  ["uid"]
                                                              .toString(),
                                                          _valChange);
                                                  _showSuccessDialog(context);
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                            : SizedBox();
                      });
                }
                return Center(child: CircularProgressIndicator());
                //       });
              }),
        ),
      ),
    );
  }

  _showSuccessDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AnakkosList()),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Emergency Message has sent"),
      content: Image.asset('images/success.png'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
