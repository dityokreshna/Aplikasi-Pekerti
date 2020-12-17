import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static DatabaseService _instance = DatabaseService();
  static DatabaseService get instance => _instance;

  final profilReference =
      FirebaseDatabase.instance.reference().child("profile");
  final adminReference =
      FirebaseDatabase.instance.reference().child("profile").child("admin");
  final wargaReference =
      FirebaseDatabase.instance.reference().child("profile").child("warga");
  final anakkosReference =
      FirebaseDatabase.instance.reference().child("profile").child("anakkos");
  final emergencyReference =
      FirebaseDatabase.instance.reference().child("emergency");
  final speakerReference =
      FirebaseDatabase.instance.reference().child("speaker");
  final chatReference =
      FirebaseDatabase.instance.reference().child("chatlist");

  Future<String> inputData() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    return uid;
  }

/*  Future userlistData(String status, String uid, String username, String noktp,
      String alamat) async {
    return await daftarReference.child(status).child(uid).set({
      'name': username,
      'noktp': noktp,
      'alamat': alamat,
      'uid': uid,
    });
  }*/

  Future userregisterData(String status, String uid, String username,
      String noktp, String alamat) async {
    return await profilReference.child(uid).set({
      'name': username,
      'noktp': noktp,
      'alamat': alamat,
      'status': status,
      'uid': uid,
    });
  }

  Future<void> userremoveData(String uid) async {
    await profilReference.child(uid).remove();
  }

  Future getuserStatus(String uid) async {
    profilReference.child(uid).child("status").once();
  }
  Future getuserProfile(String uid) async {
    profilReference.child(uid).child("profile").once();
  }


  Future changeStatus(String uid, String status) async {
    profilReference.child(uid).update({'status': status});
  }

  Future<void> sendEmergency(String username, String alamat, String waktukirim) async {
    await emergencyReference.push().set({
      'name': username,
      'alamat': alamat,
      'waktukirime': waktukirim,
    });
  }

  Future <void> sendChat(String chats,String nama, String waktukirimp) async {
    await chatReference.push().set({'nama' : nama,'chat': chats, 'waktukirimp' : waktukirimp});
  }

  Future<void> sendSpeaker(String arah, String datawaktu) async {
    await speakerReference.set({
      'arahspeaker': arah,
      'played': false,
      'uploadtime': datawaktu,
    });
  }

  Future<void> getProfile(String uid) async {
    await profilReference.child(uid).once();
  }
}
