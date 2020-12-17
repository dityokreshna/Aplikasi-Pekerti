import 'package:aplikasipekerti/home_page/video_diplay.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class CctvPage extends StatelessWidget {
  final String userId;
  CctvPage({this.userId});

  var cctvLists = [];

  final cctvReference =
      FirebaseDatabase.instance.reference().child("cctv").onValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'CCTV',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: cctvReference,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map values = snapshot.data.snapshot.value;
              cctvLists.clear();
              // print(values.toString());
              values.forEach((key, values) {
                cctvLists.add(values);
              });

              return ListView.builder(
                  itemCount: cctvLists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChewieListItem(
                        // videoPlayerController: VideoPlayerController.network(
                            urlCCTV:cctvLists[index]["linkurl"],
                        namaCCTV: cctvLists[index]["name"],
                        deskripsiCCTV: cctvLists[index]["deskripsi"]
                        
                        );
                  });
            }
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ));
          }),
    );
  }
}
