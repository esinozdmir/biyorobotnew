import 'package:chatbotkou/message_model.dart';
import 'package:chatbotkou/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseServices {
  //firestore bağlantı nesnesi
  FirebaseFirestore db = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserModel> getUserById(String id) async {
    DocumentSnapshot userSnapshot = await db.collection('users').doc(id).get();

    return UserModel.fromDocument(userSnapshot);
  }

    // Kullanıcının mesajlarını getir
  Future<List<MessageModel>> getListMessage(String userId) async {
    QuerySnapshot<Map<String, dynamic>> messageSnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp') // Mesajları zaman sırasına göre alıyoruz
        .get();

    // Query'den gelen veriyi MessageModel nesnesine dönüştür ve bir listeye ekle
    List<MessageModel> messages = messageSnapshot.docs.map((doc) {
      return MessageModel.fromQuerySnapshot(doc);
    }).toList();

    return messages;
  }

}
