import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Зареєструватися'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: _buildTextField('Ім\'я користувача'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: _buildTextField('Email'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: _buildTextField('Пароль', isPassword: true),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: _buildButton('Зареєструватися', () {
                Navigator.pushNamed(context, '/home');
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15.0), // Більший падінг для кнопки
      ),
      child: Text(text),
    );
  }
}
