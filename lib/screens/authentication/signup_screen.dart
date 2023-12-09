import 'dart:io';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  File? _pickedImage;
  bool isSecurePass = true;
  var _enteredName = '';
  var _enteredEmailS = '';
  var _enteredPassS = '';
  bool _isLoading = false;

  void _onSubmitSignUp() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image to continue.'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _form.currentState!.save();
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _enteredEmailS, password: _enteredPassS);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredential.user!.uid}.jpg');

      await storageRef.putFile(_pickedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username' : _enteredName,
        'email' : _enteredEmailS,
        'imageUrl' : imageUrl,
      });

      setState(() {
        _isLoading = false;
      });
      if(context.mounted){
        Navigator.of(context).pop();
        return;
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication Failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset('assets/signup_image.png'),
            ),
            Stack(
              children: [
                ClipPath(
                  clipper: RoundedDiagonalPathClipper(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.673,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    )),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 6),
                        height: MediaQuery.of(context).size.height * 0.52333,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Form(
                          key: _form,
                          child: Column(
                            children: [
                              UserImagePicker(
                                onPickedImage: (pickedImage) {
                                  _pickedImage = pickedImage;
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  label: Text('Name'),
                                  prefixIcon: Icon(Icons.perm_identity),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty || value.trim().length < 2) {
                                    return 'Please enter your name correctly.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredName = value!;
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                decoration: const InputDecoration(
                                  label: Text('Email'),
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Please enter a valid email address.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredEmailS = value!;
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                obscureText: isSecurePass ? true : false,
                                decoration: InputDecoration(
                                  label: const Text('Password'),
                                  prefixIcon: const Icon(Icons.password_sharp),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSecurePass = !isSecurePass;
                                      });
                                    },
                                    child: isSecurePass == false
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.length < 6) {
                                    return 'Password must be six characters long.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPassS = value!;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'By Signing up you agree to our terms and conditions.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Log In',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 2.5,
                            alignment: Alignment.center,
                          ),
                          onPressed: _isLoading ? null : _onSubmitSignUp,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  'SIGNUP',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
