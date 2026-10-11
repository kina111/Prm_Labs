import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SignUpScreen(title: 'Signup'),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.title});
  final String title;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  bool isCheckingEmail = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    TextFormField(
                        focusNode: _nameFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your Full Name',
                          labelText: 'Full Name',
                        ),
                        validator: _validateName
                    ),
                    TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter a valid email address',
                          labelText: 'Email',
                        ),
                        validator: _validateEmail
                    ),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter a password',
                        labelText: 'Password',
                      ),
                      validator: _validatePassword,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        hintText: 'Confirm your password',
                        labelText: 'Confirm Password',
                      ),
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Sign Up'),
                    )
                  ],
                )
            ),
          )
      )
    );
  }
  String? _validateName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Name is required';
    }

    return null;
  }
  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return "Email is required";
    }
    if (!text.contains('@') || !text.contains('.')){
      return "Enter a valid email";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return "Password is required";
    }else if (text.length < 8){
      return "Password must be at least 8 characters";
    }else if (!text.contains(RegExp(r'[0-9]'))){
      return "Password must contain at least one number";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return "Confirm password is required";
    }
    if (text != _passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }
  Future<void> _submit() async{
    final isValid = _formKey.currentState!.validate();
    if (!isValid){
      return;
    }
    setState(() => isCheckingEmail = true);
    await Future.delayed(const Duration(seconds: 2));
    final emailTaken = _emailController.text.toLowerCase().startsWith('taken');
    setState(() => isCheckingEmail = false);
    if (emailTaken){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is already taken')),
      );
      return;
    }

    _formKey.currentState!.save();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );
  }
  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
