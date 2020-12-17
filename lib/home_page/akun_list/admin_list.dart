import 'package:aplikasipekerti/firebase_service/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminList extends StatefulWidget {
  @override
  _AdminListState createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  var adminLists = [];
  String _valChange;
  int jumlahAdmin = 0;
  int jumlahWarga = 0;
  int jumlahanakKos = 0;
  final adminReference =
      FirebaseDatabase.instance.reference().child("profile").onValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
              stream: adminReference,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map values = snapshot.data.snapshot.value;
                  adminLists.clear();
                  // values["status"] == "admin" ? jumlahAdmin++ :null;
                  //print(values.toString());
                  values.forEach((key, values) {
                    //   values["status"] == "admin"
                    //       ? jumlahAdmin++
                    //       : values["status"] == "warga"
                    //           ? jumlahWarga++
                    //           : jumlahanakKos++;
                    adminLists.add(values);
                  });
                  // print("admin :" + jumlahAdmin.toString());
                  // print("warga :" + jumlahWarga.toString());
                  // print("kos :" + jumlahanakKos.toString());

                  // return FutureBuilder(
                  //     future: adminReference,
                  //     builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  //       if (snapshot.hasData) {
                  //         Map<dynamic, dynamic> values = snapshot.data.value;
                  //         print(values);
                  //         adminLists.clear();
                  //         //values["status"] == "admin" ? jumlahAdmin++ :null;
                  //         values.forEach((key, values) {
                  //           values["status"] == "admin"
                  //               ? jumlahAdmin++
                  //               : values["status"] == "warga"
                  //                   ? jumlahWarga++
                  //                   : jumlahanakKos++;
                  //           adminLists.add(values);
                  //         });
                  //         print("admin :" + jumlahAdmin.toString());
                  //         print("warga :" + jumlahWarga.toString());
                  //         print("kos :" + jumlahanakKos.toString());

                  return new ListView.builder(
                      itemCount: adminLists.length,
                      itemBuilder: (BuildContext context, int index) {
                        List _statusChange = ["anakkos", "warga"];

                        return adminLists[index]["status"] == "admin"
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
                                                adminLists[index]["uid"]
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
                                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Text(
                                                    "Nama   : " +
                                                        adminLists[index]["name"],
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                      "No KTP :" +
                                                          adminLists[index]
                                                              ["noktp"],
                                                      textAlign: TextAlign.left),
                                                  Container(
                                                    width: 230,
                                                    child: Text(
                                                      "Alamat : " +
                                                          adminLists[index]
                                                              ["alamat"],
                                                      textAlign: TextAlign.left,
                                                      overflow: TextOverflow.fade,
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
                                                            adminLists[index]
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
                                                          adminLists[index]
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
          MaterialPageRoute(builder: (context) => AdminList()),
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
