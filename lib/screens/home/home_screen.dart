// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:canvas_image/models/user.dart';
import 'package:canvas_image/services/api_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<User?> _getUserInfo() async {
    return await ApiService.getUserProfile();
  }

  Future<void> _logout(BuildContext context) async {
    await ApiService.logout();

    // Giriş ekranına yönlendirme
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: FutureBuilder<User?>(
                future: _getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Bir hata oluştu');
                  } else {
                    final user = snapshot.data;
                    if (user == null) {
                      return const Text('Kullanıcı bilgileri bulunamadı');
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user.profilePicture.isNotEmpty)
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePicture),
                            radius: 30,
                          ),
                        const SizedBox(height: 10),
                        Text(
                          user.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                Navigator.pop(context);
                // Anasayfa'ya gitmek için kod
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                Navigator.pop(context);
                // Ayarlar sayfasına gitmek için kod
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Çıkış Yap'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Anasayfa ya hoşgeldiniz!'),
      ),
    );
  }
}
