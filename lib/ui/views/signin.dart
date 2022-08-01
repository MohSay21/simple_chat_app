import 'package:chat_app/providers/user.dart';
import 'package:chat_app/ui/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/services/theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:chat_app/services/auth.dart';

class SignInV extends ConsumerWidget {

  SignInV({Key? key}) : super(key: key);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authentication = Authentication(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.2),
                buildTitle(theme),
                SizedBox(height: size.height * 0.1),
                TextFormField(
                  controller: _emailCtrl,
                  validator: (value) => EmailValidator.validate(value!)
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
                  controller: _passwordCtrl,
                  validator: (value) => value!.length >= 6
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
                SizedBox(height: size.height * 0.01),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/reset'),
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ref.read(myUserP.notifier).changeUser(email: _emailCtrl.text.trim());
                      await authentication.signIn(
                        _emailCtrl.text.trim(),
                        _passwordCtrl.text.trim(),
                      );
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
                    'Sign in',
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
                      'Don\'t have an account?',
                      style: TextStyle(),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('/signup'),
                      child: Text(
                        'Sign up',
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