import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_market_hewan/auth/auth_service.dart';
import 'package:tubes_market_hewan/auth/login.dart';
import 'package:tubes_market_hewan/style/color.dart';
import 'package:tubes_market_hewan/style/custom_container.dart';
import 'package:tubes_market_hewan/style/text.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: whiteBone,
        body: SafeArea(
          child: Padding(
            padding:const EdgeInsets.only(top: 30, bottom: 40, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: navy,
                  radius: 20,
                  child: FaIcon(
                    FontAwesomeIcons.dove,
                    color: white,
                    size: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("Welcome!", style: text25_7navy),
                const SizedBox(
                  height: 5,
                ),
                Text("Get started by signing up for an account",
                    style: text12_4navy),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: boxWhiteBorderRounded,
                  child: TextField(
                    controller: usernameController,
                    style: text14_6navy,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      border: InputBorder.none,
                      prefixIcon: FaIcon(
                        FontAwesomeIcons.solidCircleUser,
                        size: 18,
                        color: navy.withOpacity(0.5),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 35,
                        minHeight: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: boxWhiteBorderRounded,
                  child: TextField(
                    controller: emailController,
                    style: text14_6navy,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none,
                      prefixIcon: FaIcon(
                        FontAwesomeIcons.solidEnvelope,
                        size: 18,
                        color: navy.withOpacity(0.5),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 35,
                        minHeight: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  height: 50,
                  decoration: boxWhiteBorderRounded,
                  child: TextField(
                    controller: passwordController,
                    style: text14_6navy,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: InputBorder.none,
                      prefixIcon: FaIcon(
                        FontAwesomeIcons.key,
                        size: 18,
                        color: navy.withOpacity(0.5),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 35,
                        minHeight: 15,
                      ),
                      suffixIcon: InkWell(
                        onTap: () => setState(() {
                          isVisible = !isVisible;
                        }),
                        child: FaIcon(
                          isVisible
                              ? FontAwesomeIcons.solidEye
                              : FontAwesomeIcons.solidEyeSlash,
                          size: 18,
                          color: navy.withOpacity(0.5),
                        ),
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 35,
                        minHeight: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    final message = await AuthService().register(
                      username: usernameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    if (message == 'Registration Success') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message ?? 'An error occurred'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: mediaQuery.size.width,
                    height: 50,
                    decoration: boxNavyRounded,
                    child: Center(
                        child: Text(
                      "Sign-Up",
                      style: text14_6white,
                    )),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have an account?",
                      style: text12_6navy,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          )),
                      child: Text(
                        "Sign-In",
                        style: text12_6yellow,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
