import 'package:edcom/auth/sign_in.dart';
import 'package:edcom/auth/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 243, 241, 241),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.square_stack_3d_down_right_fill,
                  size: 150.0, color: Colors.lightBlue),
              const SizedBox(height: 10.0),
              const Text(
                'Welcome to Flash Recall',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                'Log in with your account to continue',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        fixedSize: const Size(110, 45)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        fixedSize: const Size(110, 45)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
