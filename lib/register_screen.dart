import 'package:chatbotkou/chat_bot_screen.dart';
import 'package:chatbotkou/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedGender; // Variable to hold selected gender

  Future<void> _register() async {
    try {
      // Firebase Auth ile kullanıcı oluşturma
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Firestore'a kullanıcı bilgilerini kaydetme
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'gender': _selectedGender,
        'role' : 'user',
      });

      // Başarılı kayıt sonrası yönlendirme
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatBotScreen()),
      );
    } catch (e) {
      print(e);
      // Hataları yönetmek için burada uygun bir işlem yapabilirsiniz
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Center vertically
              children: [
                Container(
                  width: double.infinity, // Make it full-width
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Çerçeve rengi siyah
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Kullanıcı Adı',
                      labelStyle: TextStyle(color: Colors.black), // Label text color
                    ),
                    cursorColor: Colors.black, // Cursor color
                    style: TextStyle(color: Colors.black), // Text color
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity, // Make it full-width
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Çerçeve rengi siyah
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGender,
                      hint: Text('Cinsiyet', style: TextStyle(color: Colors.black)), // Hint text color
                      items: [
                        DropdownMenuItem(
                          value: 'Kadın',
                          child: Text('Kadın', style: TextStyle(color: Colors.black)), // Dropdown item text color
                        ),
                        DropdownMenuItem(
                          value: 'Erkek',
                          child: Text('Erkek', style: TextStyle(color: Colors.black)), // Dropdown item text color
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      style: TextStyle(color: Colors.black), // Dropdown text color
                      iconEnabledColor: Colors.black, // Icon color
                      dropdownColor: const Color.fromARGB(255, 229, 222, 204), // Açılır menünün arka plan rengi
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity, // Make it full-width
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Çerçeve rengi siyah
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black), // Label text color
                    ),
                    cursorColor: Colors.black, // Cursor color
                    style: TextStyle(color: Colors.black), // Text color
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity, // Make it full-width
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Çerçeve rengi siyah
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Şifre',
                      labelStyle: TextStyle(color: Colors.black), // Label text color
                    ),
                    obscureText: true,
                    cursorColor: Colors.black, // Cursor color
                    style: TextStyle(color: Colors.black), // Text color
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register, // Register button triggers Firebase registration
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appBar,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // İçerik boşluğu
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
                    'Kayıt Ol',
                    style: TextStyle(color: AppColors.buttonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
