import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: ScreenUtilInit(
        designSize: Size(375, 812), // размер макета, например, iPhone X
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MyApp();
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LAB 7',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const MainScreen(),
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
      appBar: AppBar(
        title: Text('app_title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final locale = context.locale.languageCode == 'en'
                  ? const Locale('ru')
                  : const Locale('en');
              context.setLocale(locale);
            },
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1 && _nameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('require_registration'.tr())),
            );
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr()),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'profile'.tr()),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'full_name'.tr()),
              validator: (value) =>
                  value!.isEmpty ? 'name_required'.tr() : null,
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'phone'.tr()),
              validator: (value) => value!.length < 10 ? 'phone_invalid' : null,
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'email'.tr()),
              validator: (value) =>
                  !value!.contains('@') ? 'email_invalid'.tr() : null,
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'password'.tr()),
              obscureText: true,
              validator: (value) =>
                  value!.length < 6 ? 'password_short'.tr() : null,
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _confirmationController,
              decoration: InputDecoration(labelText: 'confirm_password'.tr()),
              obscureText: true,
              validator: (value) => value != _passwordController.text
                  ? 'password_mismatch'.tr()
                  : null,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _register,
              child: Text('register'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoPage() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('name'.tr() + ': ' + '${_nameController.text}',
              style: TextStyle(fontSize: 18.sp)),
          SizedBox(height: 8),
          Text('phone_display'.tr() + ': ' + '${_phoneController.text}',
              style: TextStyle(fontSize: 18.sp)),
          SizedBox(height: 8),
          Text('email_display'.tr() + ': ' + '${_emailController.text}',
              style: TextStyle(fontSize: 18.sp)),
          SizedBox(height: 8),
          Text('password_display'.tr() + ': ' + '${_passwordController.text}',
              style: TextStyle(fontSize: 18.sp, color: Colors.red)),
        ],
      ),
    );
  }
}
