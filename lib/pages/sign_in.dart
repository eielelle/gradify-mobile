import 'package:flutter/material.dart';
import 'package:gradify/values/sizes.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? notice;

  void signIn() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sign In",
                style: TextStyle(fontSize: Sizes.lg),
              ),
              const Text("Sign in to continue"),
              const SizedBox(
                height: Sizes.md,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: "Email", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: Sizes.md,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {}, child: const Text("Forgot Password"))
                ],
              ),
              ElevatedButton(onPressed: () {}, child: const Text("Sign In"))
            ]));
  }
}
