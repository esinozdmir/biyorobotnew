import 'package:chatbotkou/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserMessagesScreen extends StatelessWidget {
  final String userId;
  final String username;

  UserMessagesScreen({required this.userId, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "$username - Mesajlar",
          style: TextStyle(color: AppColors.buttonText),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBar,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('messages')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var messages = snapshot.data!.docs;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var messageData = messages[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messageData['message'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Tarih: ${messageData['timestamp'].toDate()}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
