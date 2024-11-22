import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:notesbysubject/component/square_button.dart';
import 'package:notesbysubject/manager/auth_manager.dart';

class EmailPasswordAuthPage extends StatefulWidget {
  final bool isNewUser;
  const EmailPasswordAuthPage({
    required this.isNewUser,
    super.key,
  });

  @override
  State<EmailPasswordAuthPage> createState() => _EmailPasswordAuthPageState();
}

class _EmailPasswordAuthPageState extends State<EmailPasswordAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  UniqueKey? _loginObserverKey;

  @override
  void initState() {
    super.initState();

    // TODO: Remove this later
    emailTextEditingController.text = "a@b.co";
    passwordTextEditingController.text = "123456";

    _loginObserverKey = AuthManager.instance.addLoginObserver(() {
      print("Login observed from the EmailPasswordPage");
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    AuthManager.instance.removeObserver(_loginObserverKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
            widget.isNewUser ? "Create a New User" : "Log in an Existing User"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailTextEditingController,
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return "Invalid Email Address";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "Enter a valid email address",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordTextEditingController,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Passwords must be at least 6 characters";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Passwords must be 6 characters or more",
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                SquareButton(
                  displayText:
                      widget.isNewUser ? "Create an Account" : "Log in",
                  onPressCallback: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isNewUser) {
                        AuthManager.instance.signInNewUser(
                          context: context,
                          emailAddress: emailTextEditingController.text,
                          password: passwordTextEditingController.text,
                        );
                      } else {
                        AuthManager.instance.loginExistingUser(
                          context: context,
                          emailAddress: emailTextEditingController.text,
                          password: passwordTextEditingController.text,
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid Email or Password"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}