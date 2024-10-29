import 'package:chatbotkou/admin_panel.dart';
import 'package:chatbotkou/chat_bot_screen.dart';
import 'package:chatbotkou/colors.dart';
import 'package:chatbotkou/statistics_screen.dart';
import 'package:flutter/material.dart';

class AdminSelectionScreen extends StatelessWidget {
  const AdminSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Yönetici",
          style: TextStyle(
            color: AppColors.buttonText,
            fontSize: 22, // Yazı tipi boyutu
            fontWeight: FontWeight.bold, // Yazı tipi kalınlığı
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBar,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminPanel()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appBar,
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15), // İçerik boşluğu
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18, // Yazı tipi boyutu
                    fontWeight: FontWeight.bold, // Yazı tipi kalınlığı
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Colors.black, // Çerçeve rengi
                      width: 2, // Çerçeve kalınlığı
                    ), // Kenarların yuvarlatılması
                  ),
                  elevation: 10, // Gölge yüksekliği
                ),
                child: Text(
                  "Mesajlar",
                  style: TextStyle(color: AppColors.buttonText),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatBotScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appBar,
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15), // İçerik boşluğu
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18, // Yazı tipi boyutu
                    fontWeight: FontWeight.bold, // Yazı tipi kalınlığı
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Colors.black, // Çerçeve rengi
                      width: 2, // Çerçeve kalınlığı
                    ), // Kenarların yuvarlatılması
                  ),
                  elevation: 10, // Gölge yüksekliği
                ),
                child: Text(
                  "Chatbot",
                  style: TextStyle(color: AppColors.buttonText),
                )),
                ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StatisticsScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appBar,
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15), // İçerik boşluğu
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18, // Yazı tipi boyutu
                    fontWeight: FontWeight.bold, // Yazı tipi kalınlığı
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Colors.black, // Çerçeve rengi
                      width: 2, // Çerçeve kalınlığı
                    ), // Kenarların yuvarlatılması
                  ),
                  elevation: 10, // Gölge yüksekliği
                ),
                child: Text(
                  "İstatistik",
                  style: TextStyle(color: AppColors.buttonText),
                ))
          ],
        ),
      ),
    );
  }
}
