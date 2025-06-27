import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';
import 'widgets/custom_text_form_field.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Color(0xFFF6F6F6),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Icon(Icons.person_outline),
              ],
            ),
            Text("Welcome back, Rahit thakur", style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8),
        children: [
          SizedBox(height: 16),
          _SignInForm(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Row(
              children: [
                Expanded(child: Container(height: 1, color: Color(0xFFA39797))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Or Login with', style: TextStyle(fontSize: 12)),
                ),
                Expanded(child: Container(height: 1, color: Color(0xFFA39797))),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: SizedBox(
              width: 80,
              height: 22,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset('assets/google.png'), Text('Google')],
              ),
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey[800]),
              children: [
                TextSpan(text: "You Don't have an account ? "),
                TextSpan(
                  text: "Sign up",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  _SignInForm();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  void _showCodeBottomSheet(BuildContext context, String email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'The code is sent to the $email',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _codeController,
                    label: 'Input code',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(
                          AuthVerifyCodeEvent(
                            emailAdress: _emailController.text,
                            code: int.parse(_codeController.text),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthCodeSended,
      listener: (context, state) {
        if (state is AuthCodeSended) {
          _showCodeBottomSheet(context, _emailController.text);
        }
        if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Something went wrong. Try again(")),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              children: [
                Center(
                  child: Image.asset('assets/image.png', fit: BoxFit.fitHeight),
                ),
                SizedBox(height: 16),
                Text(
                  'Enter Your Email',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  controller: _emailController,
                  label: 'Enter Email',
                  onSubmitted:
                      state is AuthLoadingState
                          ? null
                          : (value) {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                AuthSendedCodeEvent(
                                  emailAdress: _emailController.text,
                                ),
                              );
                            }
                          },
                  inputformatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9@._-]'),
                    ),
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!RegExp(
                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
                    ).hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(child: SizedBox(height: 5)),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[800],
                        textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      child: const Text('Change Email ?'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 43,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        state is AuthLoadingState
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<AuthBloc>(context).add(
                                  AuthSendedCodeEvent(
                                    emailAdress: _emailController.text,
                                  ),
                                );
                              }
                            },
                    child:
                        state is AuthLoadingState
                            ? CircularProgressIndicator()
                            : Text('Login'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
