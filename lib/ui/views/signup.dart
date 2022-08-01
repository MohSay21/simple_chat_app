import 'package:chat_app/providers/password.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/ui/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:email_validator/email_validator.dart';
import 'package:chat_app/services/theme.dart';
import 'package:chat_app/main.dart';

class SignUpV extends ConsumerWidget {

  SignUpV({Key? key}) : super(key: key);

  GlobalKey<FormState> _formK = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _password1Ctrl = TextEditingController();
  final _password2Ctrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
          child: Form(
            key: _formK,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.1),
                buildTitle(theme),
                SizedBox(height: size.height * 0.1),
                TextFormField(
                  controller: _userCtrl,
                  validator: (value) => value!.trim().length >= 3
                      ? null : 'User-name must be at least 3 characters long!',
                  decoration: InputDecoration(
                    hintText: 'Enter your user-name...',
                    suffixIcon: const Icon(Icons.account_circle),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                TextFormField(
                  controller: _emailCtrl,
                  validator: (value) => EmailValidator.validate(value!.trim())
                      ? null : 'Please enter a valid e-mail!',
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your e-mail...',
                    suffixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                TextFormField(
                  controller: _password1Ctrl,
                  validator: (value) =>
                  value!.length >= 6
                      ? null : 'Password must be at least 6 characters long!',
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password...',
                    suffixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                TextFormField(
                  controller: _password2Ctrl,
                  validator: (value) {
                    if (value!.trim().length < 6) {
                      if (_password1Ctrl.text != _password2Ctrl.text) {
                        return 'Passwords don\'t match!';
                      } else {
                        return null;
                      }
                    } else {
                      return 'Password must be at least 6 characters long!';
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm your password...',
                    suffixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                ElevatedButton(
                  onPressed: () {
                    if (_formK.currentState!.validate()) {
                      ref.read(myUserP.notifier).changeUser(
                        name: _userCtrl.text.trim(),
                        email: _emailCtrl.text.trim(),
                      );
                      ref.read(passwordP.notifier).changeState(_password1Ctrl.text.trim());
                      navigatorKey.currentState!.pushNamed('/gallery');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fixedSize: Size(size.width * 0.5, size.height * 0.075),
                    elevation: 0,
                  ),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 17.5,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('/signin'),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}