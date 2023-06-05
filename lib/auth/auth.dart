import 'dart:io';

import 'package:chatapp/components/imagepicker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _firebase = FirebaseAuth.instance;
  //creating global key
  final _form = GlobalKey<FormState>();
  bool _isauthencating = false;
  var enteredemail = '';
  var enteredpass = '';
  var enterusername = '';
  bool _islogin = true;
  File? _selectedImage;
  //function for submiting
  void _submit() async {
    final isvalid = _form.currentState!.validate();
    if (isvalid || !_islogin && _selectedImage == null) {
      _form.currentState!.save();
    }
    try {
      setState(() {
        _isauthencating = true;
      });
      if (_islogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
          email: enteredemail,
          password: enteredpass,
        );
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
          email: enteredemail,
          password: enteredpass,
        );
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCredential.user!.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        //print(imageUrl);
        //storing data in firestore collections
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': enterusername,
          'user_email': enteredemail,
          'imageurl': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //..all kind of error handling
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ?? 'Authentication failed',
          ),
        ),
      );
      setState(() {
        _isauthencating = false;
      });
    }
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
                    if (!_islogin)
                      MyImagePicker(onpicked: (pickedImage) {
                        _selectedImage = pickedImage;
                      }),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        labelText: 'Enter Email',
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
                    if (!_islogin)
                      TextFormField(
                        enableSuggestions: false,
                        validator: (value) {
                          if (value == null ||
                              value.trim().length < 4 ||
                              value.isEmpty) {
                            return 'Please enter at least 4 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          enterusername = value!;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Enter Username',
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        labelText: 'Enter Password',
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
                    if (_isauthencating) const CircularProgressIndicator(),
                    if (!_isauthencating)
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
                    if (!_isauthencating)
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
