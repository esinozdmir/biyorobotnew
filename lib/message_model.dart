import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MessageModel {
  final String id;
  final String message;
  final String sender;
  final Timestamp timestamp;

  MessageModel(
      {required this.id,
      required this.message,
      required this.sender,
      required this.timestamp});

  factory MessageModel.fromQuerySnapshot(QueryDocumentSnapshot querySnapshot) {
    dynamic data = querySnapshot.data();
    return (MessageModel(
        id: data['id'],
        message: data['message'],
        sender: data['sender'],
        timestamp: data['timestamp']));
  }
}
