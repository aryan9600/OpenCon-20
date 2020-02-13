import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_con/backend/user.dart';

class Deliverables{

  final databaseReference = Firestore.instance;
  final user = User();

  Future<String> addUserToDeliverable(String token, String deliverable) async{
    try{
      await databaseReference
        .collection("deliverables")
        .document(deliverable)
        .setData(
          {"user" : token}
        );
    }catch(error){
      throw error;
    }
  }

}