import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //creating global key
  final _form = GlobalKey<FormState>();
  var enteredemail = '';
  var enteredpass = '';
  bool _islogin = true;
  void _submit() {
    final isvalid = _form.currentState!.validate();
    if (isvalid) {
      _form.currentState!.save();
    }
    print(enteredemail);
    print(enteredpass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40, right: 20, left: 20),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _form,
                  child: Column(children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        hintText: 'Enter Email',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredemail = value!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        hintText: 'Enter Password',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Password most contain more then 6 letters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredpass = value!;
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        child: Text(
                          _islogin ? 'Login' : 'Sign-Up',
                          style: const TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _islogin = !_islogin;
                          });
                        },
                        child: Text(_islogin
                            ? 'Create new account'
                            : 'Already have an acoount login'))
                  ]),
                ),
              )),
            )
          ],
        ),
      )),
    );
  }
}
