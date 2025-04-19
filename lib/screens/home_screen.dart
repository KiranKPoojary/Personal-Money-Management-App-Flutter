import 'package:flutter/material.dart';
import '../db/transaction_db.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<String> _usernames = [];

  @override
  void initState() {
    super.initState();
    //_loadUsernames();
  }

  Future<void> _loadUsernames() async {
    try {
      final usernames = await TransactionDB.instance.getAllUsernames();
      setState(() {
        _usernames = usernames;
      });
    } catch (e) {
      debugPrint("Error loading usernames: $e");
    }
  }

  /*void _login() async {

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    print('Username: $username, Password: $password');

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Please enter both username and password');
      return;
    }

    final existingUser = await TransactionDB.instance.getUser(username, password);

    if (existingUser != null) {
      _showMessage('Login successful');
      Navigator.pushNamed(context, '/dashboard', arguments: username);
    } else {
      // Register new user
      await TransactionDB.instance.insertUser(UserModel(username: username, password: password));
      _showMessage('New user created');
      Navigator.pushNamed(context, '/dashboard', arguments: username);
    }
  }
*/
  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username == 'KK' && password == '1234') {
      _showMessage('Login successful');
      Navigator.pushNamed(context, '/dashboard', arguments: username);
    }
    else
      {
        _showMessage('Wrong man');
      }
  }
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hi Kiran K Poojary'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login 👋', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _usernames.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _usernameController.text = selection;
                },
                fieldViewBuilder: (context, textEditingController, focusNode, onEditingComplete) {
                  return TextField(
                    controller: _usernameController, // <- use your main controller
                    focusNode: focusNode,
                    decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                  );
                },
              ),

              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xB095D3FF),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
