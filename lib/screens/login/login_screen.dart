import 'package:canvas_image/services/api_services.dart';
import 'package:canvas_image/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final response = await ApiService.login(email, password);

      if (response['success']) {
        // Giriş başarılı, yönlendirme yapabilirsiniz
        Navigator.pushReplacementNamed(context, '/home'); // Örneğin ana sayfaya yönlendirme
      } else {
        setState(() {
          _errorMessage = response['error'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adv Dijital Çözüm Uygulaması'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.key,
                  size: 100,
                  color: Colors.red,
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen mail alanını boş bırakmayınız!';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  isPasswordField: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen şifre alanını boş bırakmayınız!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _login,
                  label: const Text('Giriş Yap'),
                  icon: const Icon(Icons.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
