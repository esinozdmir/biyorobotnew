import 'package:chatbotkou/chat_bot_screen.dart';
import 'package:chatbotkou/colors.dart';
import 'package:chatbotkou/main.dart';
import 'package:chatbotkou/colors.dart';
import 'package:chatbotkou/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true; // Şifreyi gizleme / gösterme durumu

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigatePage()),
      );
    } catch (e) {
      print(e); // Hataları konsola yazdırıyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Align(
            alignment: Alignment.bottomCenter, // Yazıyı ortalar
            child: Text(
              'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor:
              const Color.fromARGB(255, 141, 151, 114), // Arka plan rengi
        ),
      );
    }
  }

  // Şifre sıfırlama fonksiyonu
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen e-posta adresinizi girin.")),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.")),
      );
    } catch (e) {
      print("Şifre sıfırlama hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Şifre sıfırlama hatası. Lütfen tekrar deneyin.")),
      );
    }
  }

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 229, 222, 204),
        title: Text('Giriş Yap'),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 229, 222, 204),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Merkezi dikey olarak yerleştirir
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.black), // Çerçeve rengi siyah
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(color: Colors.black), // Label text rengi
                  ),
                  cursorColor: Colors.black, // İmleç rengi
                  style: TextStyle(color: Colors.black), // Yazı rengi
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.black), // Çerçeve rengi siyah
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Şifre',
                    labelStyle:
                        TextStyle(color: Colors.black), // Label text rengi
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: _togglePasswordView,
                    ),
                  ),
                  cursorColor: Colors.black, // İmleç rengi
                  style: TextStyle(color: Colors.black), // Yazı rengi
                ),
              ),
              SizedBox(height: 20),

              TextButton(
                onPressed: _resetPassword,
                child: Text(
                  'Şifremi Unuttum',
                  style: TextStyle(
                    color: AppColors.appBar,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              //SizedBox(height: 5),
              // Şifremi Unuttum Butonu
              ElevatedButton(
                onPressed: _login,
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
                  style: TextStyle(color: AppColors.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
