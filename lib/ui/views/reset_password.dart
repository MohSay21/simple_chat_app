import 'package:chat_app/services/auth.dart';
import 'package:chat_app/ui/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:email_validator/email_validator.dart';
import 'package:chat_app/main.dart';

class ResetPasswordV extends ConsumerWidget {

  ResetPasswordV({Key? key}) : super(key: key);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authentication = Authentication(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: size.height / 60,
                      left: size.height / 60,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back, color: theme.colorScheme.secondary,),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.2),
                buildTitle(theme),
                SizedBox(height: size.height * 0.1),
                TextFormField(
                  validator: (value) => EmailValidator.validate(value!)
                  ? null : 'Please enter a valid e-mail!',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailCtrl,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter your e-mail',
                    suffixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.1),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authentication.resetPassword(_emailCtrl.text.trim());
                      scaffoldKey.currentState!.showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Password reset link is sent. Check your e-mail.',
                              ),
                              backgroundColor: theme.primaryColor,
                              elevation: 0,
                            )
                        );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: theme.primaryColor,
                    fixedSize: Size(size.width * 0.5, size.height * 0.075),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Send email',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}