import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_con/backend/user.dart';

class Deliverables{

  final databaseReference = Firestore.instance;
  final user = User();

  Future<String> addUserToDeliverable(String token, String deliverable, String email) async{
    try{
      await databaseReference
        .collection(deliverable)
        .document(token).
        setData({
          "email": email
        });
    }catch(error){
      throw error;
    }
  }
}