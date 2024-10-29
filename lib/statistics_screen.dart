import 'package:chatbotkou/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int totalResponses = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  List<Map<String, dynamic>> userStatistics = [];
  int totalUsers = 0;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    try {
      QuerySnapshot userSnapshots = await FirebaseFirestore.instance.collection('users').get();

      int totalCorrect = 0;
      int totalWrong = 0;
      int totalAnswered = 0;
      int usersCount = userSnapshots.docs.length;

      List<Map<String, dynamic>> stats = [];

      for (var userDoc in userSnapshots.docs) {
        String userId = userDoc.id;
        String username = userDoc['username'] ?? "Bilinmeyen Kullanıcı";

        QuerySnapshot messageSnapshots = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('messages')
            .get();

        int userCorrect = 0;
        int userWrong = 0;

        List<Map<String, dynamic>> userMessages = [];

        for (var messageDoc in messageSnapshots.docs) {
          var messageData = messageDoc.data() as Map<String, dynamic>;

          if (messageData.containsKey('message')) {
            totalAnswered++;
            if (messageData['message'] == 'Tebrikler, cevabınız doğru! 🎉') {
              totalCorrect++;
              userCorrect++;
            } else if (messageData['message'] == 'Cevabınız hatalı. Lütfen tekrar deneyin.') {
              totalWrong++;
              userWrong++;
            }

            userMessages.add({
              'question': messageData['user_response'] ?? 'Soru bulunamadı',
              'answer': messageData['bot_response'] ?? 'Cevap bulunamadı',
              'message': messageData['message'],
              'timestamp': (messageData['timestamp'] as Timestamp).toDate(),
            });
          }
        }

        stats.add({
          'username': username,
          'correct': userCorrect,
          'wrong': userWrong,
          'messages': userMessages,
        });
      }

      setState(() {
        totalResponses = totalAnswered;
        correctAnswers = totalCorrect;
        wrongAnswers = totalWrong;
        userStatistics = stats;
        totalUsers = usersCount;
      });
    } catch (e) {
      print("İstatistikler alınırken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İstatistikler',style: TextStyle(color: AppColors.buttonText),),
        backgroundColor: AppColors.chatBubble,
        centerTitle: true,
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userStatistics.length,
                itemBuilder: (context, index) {
                  var userStat = userStatistics[index];
                  return _buildUserStatsTile(userStat);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      color: AppColors.appBar,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Genel İstatistikler",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.buttonText),
            ),
            Divider(color: AppColors.buttonText),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildStatisticItem("Toplam Kullanıcı", totalUsers.toString(), Icons.people)),
                Expanded(child: _buildStatisticItem("Toplam Cevap", totalResponses.toString(), Icons.question_answer)),
                Expanded(child: _buildStatisticItem("Doğru Cevap", correctAnswers.toString(), Icons.check_circle)),
                Expanded(child: _buildStatisticItem("Yanlış Cevap", wrongAnswers.toString(), Icons.cancel)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppColors.buttonText),
        SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.buttonText)),
      ],
    );
  }

  Widget _buildUserStatsTile(Map<String, dynamic> userStat) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.appBar,
          child: Text(userStat['username'][0].toUpperCase(), style: TextStyle(color: Colors.white)),
        ),
        title: Text("Kullanıcı: ${userStat['username']}", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Doğru: ${userStat['correct']} / Yanlış: ${userStat['wrong']}"),
        children: (userStat['messages'] as List).map<Widget>((message) {
          return ListTile(
            title: Text("Soru: ${message['question']}", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text("Cevap: ${message['answer']}"),
                Text("Seçilen Şık: ${message['message']}"),
                Text("Tarih: ${message['timestamp']}"),
              ],
            ),
            trailing: Icon(
              _getIconForSelectedOption(message['message']),
              color: _getIconColorForSelectedOption(message['message']),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForSelectedOption(String selectedOption) {
    if (selectedOption == 'Tebrikler, cevabınız doğru! 🎉') {
      return Icons.check_circle;
    } else if (selectedOption == 'Cevabınız hatalı. Lütfen tekrar deneyin.') {
      return Icons.cancel;
    } else {
      return Icons.info_outline;
    }
  }

  Color _getIconColorForSelectedOption(String selectedOption) {
    if (selectedOption == 'Tebrikler, cevabınız doğru! 🎉') {
      return Colors.green;
    } else if (selectedOption == 'Cevabınız hatalı. Lütfen tekrar deneyin.') {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}
