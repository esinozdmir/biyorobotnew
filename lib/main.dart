import 'package:bubble/bubble.dart';
import 'package:chatbotkou/admin_panel.dart';
import 'package:chatbotkou/admin_selection_screen.dart';
import 'package:chatbotkou/chat_bot_screen.dart';
import 'package:chatbotkou/colors.dart';
import 'package:chatbotkou/firebase_options.dart';
import 'package:chatbotkou/firebase_services.dart';
import 'package:chatbotkou/login_screen.dart';
import 'package:chatbotkou/register_screen.dart';
import 'package:chatbotkou/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigatePage(),
    );
  }
}

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key});

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  FirebaseServices services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          var user = snapshot.data!;
          return FutureBuilder<UserModel>(
            future: services.getUserById(user.uid),
            builder: (context, AsyncSnapshot<UserModel> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasData && userSnapshot.data != null) {
                var user = userSnapshot.data;
                String role = user!.role;
                print("object");
                print(role);
                if (role == 'admin') {
                  return AdminSelectionScreen(); // Admin paneline yönlendir
                } else {
                  return ChatBotScreen(); // Normal kullanıcı ekranına yönlendir
                }
              } else {
                return Center(child: Text("Kullanıcı verisi bulunamadı."));
              }
            },
          );
        } else {
          return HomeScreen(); // Giriş ekranına yönlendir
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/background.jpeg', // Buraya resminizin yolunu koyun
            fit: BoxFit.cover, // Resmin tüm ekrana sığmasını sağlar
          ),
          Center(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Biyorobot Uygulaması için",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Giriş Yap ekranına yönlendirme
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
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
                      'Giriş Yap',
                      style: TextStyle(
                        color: AppColors.buttonText,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Butonlar arasında boşluk
                  ElevatedButton(
                    onPressed: () {
                      // Kayıt Ol ekranına yönlendirme
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appBar,

                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15), // İçerik boşluğu
                      textStyle: TextStyle(
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
                      'Kayıt Ol',
                      style: TextStyle(
                        color: AppColors.buttonText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
