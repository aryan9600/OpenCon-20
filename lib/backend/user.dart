import 'package:cloud_firestore/cloud_firestore.dart';

class User{

  final databaseReference = Firestore.instance;

  Future<String> createUser(String token, String name, String team, String email) async{

    try{
      await databaseReference.collection("users")
      .document(token)
      .setData({
        'name': name,
        'teamName': team,
        'email': email,
      });
      return 'User registered successfully';
    } catch(error){
      throw error;
    }
  } 

  Future<String> editUserInfo(String token, String name, String team) async{
    
    try{
      databaseReference
        .collection("users")
        .document(token)
        .updateData({'name': name, 'teamName': team});
      return 'User updated successfully';
    }catch(error){
      throw error;
    }
  }

  Future<DocumentSnapshot> getUser(String token) async{
    try{
      final user = await databaseReference
        .collection("users")
        .document(token)
        .get();
      if(user.exists){
        return user;
      } else {
        return null;
      }
    }catch(error){
      throw error;
    }
  }
}