import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), // заменили на контейнер
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Контроллеры для формы
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentIndex = 1; // Переход на профиль
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildRegistrationForm(),
      _buildUserInfoPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Demo App")),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Чтобы не перейти на профиль без заполнения формы
          if (index == 1 && _nameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Пожалуйста, зарегистрируйтесь")),
            );
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (value) => value!.isEmpty ? 'Введите имя' : null,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              validator: (value) =>
                  value!.length < 10 ? 'Введите корректный номер' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) =>
                  !value!.contains('@') ? 'Введите корректный email' : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
              validator: (value) =>
                  value!.length < 6 ? 'Минимум 6 символов' : null,
            ),
            TextFormField(
              controller: _confirmationController,
              decoration:
                  const InputDecoration(labelText: 'Подтверждение пароля'),
              obscureText: true,
              validator: (value) => value != _passwordController.text
                  ? 'Пароли не совпадают'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Имя: ${_nameController.text}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Телефон: ${_phoneController.text}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Email: ${_emailController.text}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Пароль: ${_passwordController.text}',
              style: const TextStyle(fontSize: 18, color: Colors.red)),
        ],
      ),
    );
  }
}
