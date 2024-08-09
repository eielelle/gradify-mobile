import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gradify/config/values/sizes.dart';
import 'package:gradify/providers/auth_notifier_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInScreen extends HookConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final authProviderState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    useEffect(() {
      if (authProviderState.isAuthenticated &&
          authProviderState.teacherAccount != null) {
        // redirect to content
      }

      return;
    }, [authProviderState]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (authProviderState.isError)
          Container(
            width: double.infinity,
            color: Colors.red,
            padding: const EdgeInsets.all(
                AppSizes.smallPadding), // Padding inside the Container
            child: Text(
              authProviderState.errorMsg,
              textAlign: TextAlign.center,
            ),
          ),
        const Text("Sign In"),
        const Text("Sign in using your email"),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        TextField(
            controller: passwordController,
            obscureText: true,
            obscuringCharacter: "*",
            decoration: const InputDecoration(labelText: "Password")),
        ElevatedButton(
            onPressed: () {
              authNotifier.signIn(
                  emailController.text, passwordController.text);
            },
            child: const Text("Sign In"))
      ],
    );
  }
}
