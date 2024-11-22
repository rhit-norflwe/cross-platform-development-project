import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:notesbysubject/component/square_button.dart';
import 'package:notesbysubject/pages/email_password_auth_page.dart';

class LoginFrontPage extends StatefulWidget {
  const LoginFrontPage({super.key});

  @override
  State<LoginFrontPage> createState() => _LoginFrontPageState();
}

class _LoginFrontPageState extends State<LoginFrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                "Notes",
                style: TextStyle(
                  fontFamily: "Rowdies",
                  fontSize: 56.0,
                ),
              ),
            ),
          ),
          SquareButton(
            displayText: "Log in",
            onPressCallback: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const EmailPasswordAuthPage(isNewUser: false),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account yet?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const EmailPasswordAuthPage(isNewUser: true),
                    ),
                  );
                },
                child: const Text("Sign Up Here"),
              ),
            ],
          ),
          const SizedBox(
            height: 60.0,
          ),
          ElevatedButton(
            onPressed: () {
              const googleWebClientId =
                  "330903872710-lc3ek3oecshmlk6pfb2b5tv07pm02mq0.apps.googleusercontent.com";

              print("TODO: Show the Firebase Auth UI");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SignInScreen(
                    providers: [
                      // EmailAuthProvider(),
                      GoogleProvider(clientId: googleWebClientId),
                    ],
                    actions: [
                      AuthStateChangeAction((context, AuthState state) {
                        print("Auth State $state");
                        // if (state is SignedIn) {
                        //   print("There was a sign in.  Change pages!");
                        // } else if (state is UserCreated) {
                        //   print(
                        //       "Hey a new user just joined.  Might change pages!");
                        // }
                        if (state is SignedIn || state is UserCreated) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      })
                    ],
                  ),
                ),
              );
            },
            child: const Text("Or sign in with Google"),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}