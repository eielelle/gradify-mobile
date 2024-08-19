import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gradify/config/themes/theme.dart';
import 'package:gradify/config/values/sizes.dart';
import 'package:gradify/providers/auth_notifier_provider.dart';
import 'package:gradify/routes/app_router.dart';
import 'package:gradify/screens/home.dart';
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRouter().navigateAndRemoveUntil(context, const HomeScreen());
        });
      }

      return null;
    }, [authProviderState]);

    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        if (authProviderState.isError)
          Container(
            width: double.infinity,
            color: AppColorsLight.error,
            padding: const EdgeInsets.all(
                AppSizes.smallPadding), // Padding inside the Container
            child: Text(
              authProviderState.errorMsg,
              textAlign: TextAlign.center,
            ),
          ),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(AppSizes.mediumPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/GF.png'),
                    const SizedBox(
                      height: AppSizes.mediumMargin,
                    ),
                    const Text(
                      "Sign In",
                      style: TextStyle(fontSize: AppSizes.largeFontSize),
                    ),
                    const Text("Sign in using your email"),
                    const SizedBox(
                      height: AppSizes.mediumMargin,
                    ),
                    TextField(
                      cursorColor: AppColorsLight.neutral,
                      controller: emailController,
                      decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: AppColorsLight.neutral)),
                    ),
                    const SizedBox(
                      height: AppSizes.mediumMargin,
                    ),
                    TextField(
                        cursorColor: AppColorsLight.neutral,
                        controller: passwordController,
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: const InputDecoration(
                            labelText: "Password",
                            labelStyle:
                                TextStyle(color: AppColorsLight.neutral))),
                    const SizedBox(
                      height: AppSizes.mediumMargin,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: authProviderState.isLoading
                              ? null
                              : () {
                                  authNotifier.signIn(emailController.text,
                                      passwordController.text);
                                },
                          child: authProviderState.isLoading
                              ? const CircularProgressIndicator()
                              : const Text("Sign In")),
                    )
                  ],
                )))
      ],
    )));
  }
}
