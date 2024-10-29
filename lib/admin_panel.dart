import 'package:chatbotkou/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_messages_screen.dart'; // Kullanıcı mesajlarını gösterecek ekran

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 222, 204, 1),
      appBar: AppBar(
        title: Text(
          "Kullanıcılar",
          style: TextStyle(
            color: AppColors.orta,
            fontSize: 22, // Yazı tipi boyutu
            fontWeight: FontWeight.bold, // Yazı tipi kalınlığı
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBar,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index];
              String userId = userData.id; // Kullanıcının ID'si
              String username = userData['username']; // Kullanıcının ismi

              return Card(
                elevation: 0, // Gölge seviyesi
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Yuvarlatılmış köşeler
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  tileColor: Colors.blueGrey[50], // Arka plan rengi
                  leading: CircleAvatar(
                    backgroundColor: AppColors.chatBubble,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Kullanıcı: $username",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.chatBubble,
                  ),
                  onTap: () {
                    // Kullanıcıya tıklayınca mesajları göstermek için yönlendir
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserMessagesScreen(
                          userId: userId,
                          username: username,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
