import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sammychatbot/riverpod/riverpod_provider.dart';

import 'package:sammychatbot/service/auth_service.dart';
import 'package:sammychatbot/widgets/form_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/remember_me.dart';
import '../widgets/custom_input.dart';
import '../functions/function.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SingupPageState();
  }
}

class _SingupPageState extends ConsumerState<SignupPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final fullNameControler = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool rememberMe = true;
  bool hidePassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).width * 0.17,
            left: 20,
            right: 20,
            bottom: 20),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create An Account",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    "Gain unlimited Access to sammychatbot today!",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff999EA1)),
                  ),
                  const SizedBox(height: 30),
                  _formUI(ref),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/login");
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 11, 100, 209),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  _formUI(ref) {
    return Form(
        key: _globalKey,
        child: Column(
          children: [
            CustomInput(
              validateFunc: validateFullname,
              field: "Full Name",
              placeHolder: "Full Name",
              fieldcontroller: fullNameControler,
            ),
            CustomInput(
              validateFunc: validateEmail,
              field: "Email",
              placeHolder: "Email Address",
              fieldcontroller: emailController,
            ),
            CustomPasswordInput(
              validateFunc: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return "Password must be atleast 6 character";
                }
                return null;
              },
              toggleShowPassword: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              field: "Password",
              placeHolder: "Password",
              hidePassword: hidePassword,
              fieldController: passwordController,
            ),
            const SizedBox(height: 20),
            RememberMe(
                onChange: () {
                  setState(() {
                    rememberMe = !rememberMe;
                  });
                },
                rememberMe: rememberMe),
            const SizedBox(height: 20),
            CustomFormButton(
                globalKey: _globalKey,
                label: "Sign Up",
                onSuccess: () {
                  _performRegistration(ref);
                }),
            const SizedBox(
              height: 15,
            )
          ],
        ));
  }

  _performRegistration(ref) async {
    SharedPreferences.getInstance().then(
      (value) => value.setBool("remember_me", rememberMe),
    );
    print(
        "${fullNameControler.text}, ${emailController.text}, ${passwordController.text}");
    ref.read(formLoadStateProvider.notifier).state = true;
    bool signUpSuccessful = await _authService.register(
        fullNameControler.text, emailController.text, passwordController.text);
    ref.read(formLoadStateProvider.notifier).state = false;

    if (signUpSuccessful) {
      Navigator.pushNamed(context, "/login");
    }
  }
}
