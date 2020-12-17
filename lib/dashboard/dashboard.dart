import 'dart:async';
import 'dart:io' as io;
import 'dart:math';
import 'package:aplikasipekerti/auth_page/login_page/login_home.dart';
import 'package:aplikasipekerti/dashboard/background.dart';
import 'package:aplikasipekerti/firebase_service/database_service.dart';
import 'package:aplikasipekerti/firebase_service/firebase_auth_service.dart';
import 'package:aplikasipekerti/home_page/akun.dart';
import 'package:aplikasipekerti/home_page/akun_list/admin_list.dart';
import 'package:aplikasipekerti/home_page/akun_list/anakkos_list.dart';
import 'package:aplikasipekerti/home_page/akun_list/warga_list.dart';
import 'package:aplikasipekerti/home_page/broadcast_page.dart';
import 'package:aplikasipekerti/home_page/cctv.dart';
import 'package:http/http.dart' as http;

//import 'package:audio_recorder/audio_recorder.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  DashboardPage({this.userId});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
//  DateTime now = DateTime.now();
  String kirimNama;
  String kirimAlamat;
  String noKTP;
  String status;
//  String _userId;
  String woroState;
  var userprofileLists = [];
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Stopped;
  final LocalFileSystem localFileSystem = LocalFileSystem();
  bool _selectedSpeakerR = false;
  bool _selectedSpeakerC = true;
  bool _selectedSpeakerL = false;
  String _currentSpeaker = "tengah";
  bool _isRecording = false;
  io.File _image;
  String _uploadedFileURL;
  final picker = ImagePicker();
  // loadCurrentUser() async {
  //   var userId = await _getCurrentUID();
  //   setState(() {
  //     this._userId = userId;
  //   });
  // }

  // Future<String> _getCurrentUID() async {
  //   FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   return user.uid;
  // }
    Future httpResponse() async {
      // This example uses the Google Books API to search for books about http.
      // https://developers.google.com/books/docs/overview
      var url = "https://firebasestorage.googleapis.com/v0/b/pengabdiancctv.appspot.com/o/profile%2F" +
                                                                widget.userId +
                                                                "%2Fprofilepicture?alt=media";

      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(url);
      if (response.statusCode == 400) {
        setState(() {
          _image = null;
        });
      }
    }

  @override
  void initState() {
    super.initState();
//    loadCurrentUser();
    httpResponse();
  }

  @override
  Widget build(BuildContext context) {
//    print(widget.userId);
    final myprofileReference = FirebaseDatabase.instance
        .reference()
        .child("profile")
        .child(widget.userId)
        .once();
    final StorageReference profileimageReference = FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(widget.userId)
        .child("profilepicture");

    return SafeArea(
      child: FutureBuilder(
        future: myprofileReference,
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data.value;
//            print(values);
            userprofileLists.clear();
            kirimNama = values["name"];
            kirimAlamat = values["alamat"];
            status = values["status"];
            noKTP = values["noktp"];
            values.forEach((key, values) {
//              print(values);
              userprofileLists.add(values);
            });
            return Scaffold(
              body: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: CustomPaint(painter: CurvePainter()),
                      ),
                      Column(children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 75,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Hi,',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: status.toUpperCase(),
                                      )
                                    ],
                                  ),
                                ),
                                status == "admin"
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AkunPage()));
                                        },
                                        child: Container(
                                            height: 100,
                                            width: 100,
                                            child: Icon(Icons.settings)))
                                    : InkWell(
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            color: Colors.red,
                                            elevation: 10,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.exit_to_app,
                                                      color: Colors.white),
                                                  Text(
                                                    "Keluar",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ]),
                                          ),
                                        ),
                                        onTap: () async {
                                          await AuthServices.signOut();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()));
                                        },
                                      ),
                              ]),
                        ),
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Card(
                            elevation: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8,0,0,0),
                                        child: Text("Nama : ", style: TextStyle(fontSize:14),),
                                      ),
                                      _textOnCard(kirimNama),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8,0,0,0),
                                        child: Text("No KTP : ", style: TextStyle(fontSize:14),),
                                      ),
                                      _textOnCard(noKTP),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8,0,0,0),
                                        child: Text("Status : ", style: TextStyle(fontSize:14),),
                                      ),
                                      _textOnCard(status),

//                              Text("Email     :", textAlign: TextAlign.left)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: InkWell(
                                    onTap: () async {
                                      await chooseFile();
                                      uploadFile();
                                    },
                                    child:
                                        //                                   Container(
                                        //   height: 100,
                                        //   width: 100,
                                        //   decoration: BoxDecoration(
                                        //       shape: BoxShape.circle,
                                        //       image: DecorationImage(
                                        //           fit: BoxFit.fill,
                                        //           image: NetworkImage(
                                        //               profileimageReference
                                        //                   .getDownloadURL()
                                        //                   .toString()))),
                                        // ),
                                        // _image == null
                                        //     ? Container(
                                        //         width: 100,
                                        //         height: 100,
                                        //         child:
                                        //             Text('No image selected.'))
                                        //     :
                                             Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            "https://firebasestorage.googleapis.com/v0/b/pengabdiancctv.appspot.com/o/profile%2F" +
                                                                widget.userId +
                                                                "%2Fprofilepicture?alt=media"))),
                                                // child: Image.file(_image,fit:BoxFit.fill)),

                                                //     Container(
                                                //   height: 100,
                                                //   width: 100,
                                                //   decoration: BoxDecoration(
                                                //       shape: BoxShape.circle,
                                                //       image: DecorationImage(
                                                //           fit: BoxFit.fill,
                                                //           image: AssetImage(
                                                //               'images/logo_pekerti.png')
                                                //               )),
                                                // ),
                                              ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   height: 75,
                        //   width: MediaQuery.of(context).size.width * 0.7,
                        //   child: Card(
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(10))),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //         children: <Widget>[
                        //           Column(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: <Widget>[
                        //               Text("20"),
                        //               Text("Jumlah Warga")
                        //             ],
                        //           ),
                        //           VerticalDivider(),
                        //           Column(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: <Widget>[
                        //                 Text("40"),
                        //                 Text("Jumlah Anak Kos")
                        //               ])
                        //         ],
                        //       )),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                "Fitur Anda",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            // height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            child: Column(children: <Widget>[
                              status == "admin"
                                  ? _speakerFeature()
                                  : SizedBox(),
                              _userList(
                                  Icons.message,
                                  "BroadCast Message",
                                  BroadcastPage(
                                    myStatus: status,
                                    kirimNama: kirimNama,
                                  )),
                              _userList(
                                  Icons.photo_camera,
                                  "Lihat CCTV",
                                  CctvPage(
                                    userId: widget.userId,
                                  )),
                              InkWell(
                                onTap: () {
                                  _showEmergencyDialog(context);
                                  // DatabaseService()
                                  //     .sendEmergency(kirimNama, kirimAlamat);
                                },
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.info_outline,
                                                  size: 25,
                                                ),
                                              ),
                                              VerticalDivider(),
                                              Text(
                                                  "Kirim Pemberitahuan bahaya"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              status == "admin"
                                  ? _daftarPenduduk()
                                  : SizedBox(),
                            ]),
                          ),
                        ),
                      ]),
                    ],
                  )),
            );
          }
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        },
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
//        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
//          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });
      int x = 0;
      const tick = const Duration(seconds: 1);
      new Timer.periodic(tick, (Timer t) async {
        // print("recording : " + tick.toString());
        // print("Tiemr R : ");
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        x++;
        // print(x);
        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
        if (x == 5) {
          t.cancel();
          setState(() {
            _isRecording = false;
          });
          _selectedSpeakerC ? _stopTengah() : _stopAndsend();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  _initv2() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      String customPath = '/flutter_audio_recorder_';
      io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }

      // can add extension like ".mp4" ".wav" ".m4a" ".aac"
      customPath = appDocDirectory.path +
          customPath +
          DateTime.now().millisecondsSinceEpoch.toString();

      // .wav <---> AudioFormat.WAV
      // .mp4 .m4a .aac <---> AudioFormat.AAC
      // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
      _recorder =
          FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

      await _recorder.initialized;
      // after initialization
      var current = await _recorder.current(channel: 0);
      //    print(current);
      // should be "Initialized", if all working fine
      setState(() {
        _current = current;
        _currentStatus = current.status;
        // print(_currentStatus);
      });
      //     print("Init Done");
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
      //     print("Start Done");
    } else {
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("You must accept permissions")));
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    String formattedDate = DateTimeFormat.format(DateTime.now());
    var result = await _recorder.stop();
    // print("Stop recording: ${result.path}");
    // print("Stop recording: ${result.duration}");
    File file = localFileSystem.file(result.path);
    final StorageReference fbStorage =
        FirebaseStorage().ref().child("adminaudio").child("speaker_timur.mp3");
    final StorageUploadTask uploadTask =
        fbStorage.putFile(file, StorageMetadata(contentType: 'audio/mp3'));
    await uploadTask.onComplete;
    // print("File length: ${await file.length()}");
    file.delete();
    DatabaseService().sendSpeaker("timur", formattedDate);
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  _stopAndsend() async {
    String formattedDate = DateTimeFormat.format(DateTime.now());

    var result = await _recorder.stop();
    // print("Stop recording: ${result.path}");
    // print("Stop recording: ${result.duration}");
    File file = localFileSystem.file(result.path);
    final StorageReference fbStorage = FirebaseStorage()
        .ref()
        .child("adminaudio")
        .child("speaker_" + _currentSpeaker + ".mp3");
    final StorageUploadTask uploadTask =
        fbStorage.putFile(file, StorageMetadata(contentType: 'audio/mp3'));
    await uploadTask.onComplete;
    DatabaseService().sendSpeaker(_currentSpeaker, formattedDate);
    // print("File length: ${await file.length()}");

    file.delete();
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  _stopCancel() async {
    String formattedDate = DateTimeFormat.format(DateTime.now());

    var result = await _recorder.stop();
    // print("Stop recording: ${result.path}");
    // print("Stop recording: ${result.duration}");
    File file = localFileSystem.file(result.path);
    // print("File length: ${await file.length()}");

    file.delete();
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  _stopTengah() async {
    String formattedDate = DateTimeFormat.format(DateTime.now());
    var result = await _recorder.stop();
    // print("Stop recording: ${result.path}");
    // print("Stop recording: ${result.duration}");
    File file = localFileSystem.file(result.path);
    final StorageReference fbStorage =
        FirebaseStorage().ref().child("adminaudio").child("speaker_timur.mp3");
    final StorageUploadTask uploadTask =
        fbStorage.putFile(file, StorageMetadata(contentType: 'audio/mp3'));
    await uploadTask.onComplete;
    final StorageReference fbbStorage =
        FirebaseStorage().ref().child("adminaudio").child("speaker_barat.mp3");
    final StorageUploadTask uploadbTask =
        fbbStorage.putFile(file, StorageMetadata(contentType: 'audio/mp3'));
    await uploadbTask.onComplete;
    DatabaseService().sendSpeaker("tengah", formattedDate);
    // print("File length: ${await file.length()}");

    file.delete();
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      //  case RecordingStatus.Initialized:
      //    {
      //      text = 'Start';
      //      break;
      //    }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Start';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }
/*
  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }
}*/

  Widget _userList(IconData listIcon, String judulList, apaList) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => apaList));
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        listIcon,
                        size: 25,
                      ),
                    ),
                    VerticalDivider(),
                    Text(judulList),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _speakerFeature() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: <Widget>[
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.82,
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     "Speaker",
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RotatedBox(
                      quarterTurns: 2,
                      child: IconButton(
                          icon: Icon(Icons.volume_up,
                              color: _selectedSpeakerL
                                  ? Colors.blue
                                  : Colors.grey),
                          onPressed: _selectedSpeakerL
                              ? null
                              : () {
                                  setState(() {
                                    _currentSpeaker = "timur";
                                    _selectedSpeakerL = true;
                                    _selectedSpeakerC = false;
                                    _selectedSpeakerR = false;
                                    // print("rest");
                                  });
                                }),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: IconButton(
                          icon: Icon(Icons.volume_up,
                              color: _selectedSpeakerC
                                  ? Colors.blue
                                  : Colors.grey),
                          onPressed: _selectedSpeakerC
                              ? null
                              : () {
                                  setState(() {
                                    _currentSpeaker = "keduanya";
                                    _selectedSpeakerL = false;
                                    _selectedSpeakerC = true;
                                    _selectedSpeakerR = false;
                                  });
                                }),
                    ),
                    IconButton(
                        icon: Icon(Icons.volume_up,
                            color:
                                _selectedSpeakerR ? Colors.blue : Colors.grey),
                        onPressed: _selectedSpeakerR
                            ? null
                            : () {
                                setState(() {
                                  _currentSpeaker = "barat";
                                  _selectedSpeakerL = false;
                                  _selectedSpeakerC = false;
                                  _selectedSpeakerR = true;
                                });
                              }),
                  ],
                )),
                Row(
                  children: <Widget>[
                    _isRecording
                        ? IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              _stopCancel();
                              setState(() {
                                _isRecording = false;
                              });
                            })
                        : SizedBox(),
                    IconButton(
                        icon: _isRecording
                            ? Icon(Icons.send, color: Colors.blue)
                            : Icon(Icons.mic, color: Colors.blue),
                        onPressed: () {
                          switch (_currentStatus) {
                            case RecordingStatus.Recording:
                              {
                                _isRecording = false;
                                _selectedSpeakerC
                                    ? _stopTengah()
                                    : _stopAndsend();
                                break;
                              }
                            case RecordingStatus.Stopped:
                              {
                                _isRecording = true;
                                _init();
                                break;
                              }
                            default:
                              break;
                          }
                        }),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showEmergencyDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("YES"),
      onPressed: () {
        String waktukirim = DateFormat.yMd().add_Hms().format(DateTime.now());
        DatabaseService().sendEmergency(kirimNama, kirimAlamat, waktukirim);
        _showSuccessDialog(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Pesan Bahaya"),
      content: Text("Pesan bahaya akan dikirimkan. Apakah kamu yakin?"),
      actions: [
        cancelButton,
        continueButton,
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

  _showSuccessDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardPage(userId: widget.userId)),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Pesan Bahaya Sudah Terkirim"),
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
  // _successDialog(context) {
  //   Alert(
  //     context: context,
  //     title: "SUCCESS !",
  //     desc: "Message has been sent",
  //     image: Image.asset('images/success.png'),
  //   ).show();
  // }

  // _emergencyButtonsPressed(context) {
  //   Alert(
  //     context: context,
  //     type: AlertType.warning,
  //     title: "RFLUTTER ALERT",
  //     desc: "Flutter is more awesome with RFlutter Alert.",
  //     image: Image.asset('images/success.png'),
  //     buttons: [
  //       DialogButton(
  //         child: Text(
  //           "NO",
  //           style: TextStyle(color: Colors.white, fontSize: 20),
  //         ),
  //         onPressed: () => Navigator.pop(context),
  //         color: Color.fromRGBO(0, 179, 134, 1.0),
  //       ),
  //       DialogButton(
  //         child: Text(
  //           "YES",
  //           style: TextStyle(color: Colors.white, fontSize: 20),
  //         ),
  //         onPressed: () {
  //           DatabaseService().sendEmergency(kirimNama, kirimAlamat);
  //           _successDialog(context);
  //         },
  //         color: Color.fromRGBO(0, 179, 134, 1.0),
  //       ),
  //     ],
  //   ).show();
  // }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(widget.userId)
        .child("profilepicture");
    StorageUploadTask uploadTask = storageReference.putFile(
        _image,
        StorageMetadata(
          contentType: "images",
        ));
    await uploadTask.onComplete;
    // print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
    // print(_uploadedFileURL.toString());
  }

  Future chooseFile() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = io.File(pickedFile.path);
    });
  }

  Widget _textOnCard(String dataCard) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8,0,0,4),
      child: Text(dataCard, style: TextStyle(fontSize: 18),),
    );
  }

  Widget _daftarPenduduk() {
    return Container(
        child: Column(
      children: <Widget>[
        _userList(Icons.person, "Daftar Admin", AdminList()),
        _userList(Icons.person, "Daftar Warga", WargaList()),
        _userList(Icons.person, "Daftar Anak Kos", AnakkosList()),
      ],
    ));
  }
}
