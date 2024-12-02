import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email') ?? '',
      'name': prefs.getString('name') ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data ?? {'email': '', 'name': ''};

        return Scaffold(
          appBar: AppBar(
            title: const Text('Профіль'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/default_profile_picture.jpg'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ім\'я: ${data['name']}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Електронна пошта: ${data['email']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Вихід'),
                          content: const Text('Ви дійсно хочете вийти?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Ні'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Так'),
                            ),
                          ],
                        ),
                      );

                      if (result == true) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    child: const Text('Вийти'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
