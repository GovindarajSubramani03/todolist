import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authform extends StatefulWidget {
  const Authform({super.key});
  @override
  State<Authform> createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _passwrd = '';
  var _username = '';
  bool islogin = false;

  startAuthentication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState!.save();
      submitForm(_email, _passwrd, _username);
    }
  }

  submitForm(String email, String passwrd, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (!islogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: passwrd);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: passwrd);
        String uid = authResult.user!.uid;
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
        });
        Fluttertoast.showToast(msg: 'Account Created Successfully');
      }
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.all(18),
              height: 250,
              child:
                  SvgPicture.asset('lib/assets/undraw_notebook_re_id0r.svg')),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (islogin)
                    TextFormField(
                      keyboardType: TextInputType.text,
                      key: const ValueKey('Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect Username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "Enter Username",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _passwrd = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Enter Password",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        setState(() {
                          startAuthentication();
                        });
                      },
                      child: !islogin
                          ? const Text('Login', style: TextStyle(fontSize: 18))
                          : const Text(
                              'Signup',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        islogin = !islogin;
                      });
                    },
                    child: islogin
                        ? Text(
                            "Already a User?, Login!",
                            style: GoogleFonts.roboto(
                                fontSize: 18, color: Colors.purpleAccent),
                          )
                        : Text(
                            'Not a User, SignUp!',
                            style: GoogleFonts.roboto(
                                fontSize: 18, color: Colors.purpleAccent),
                          ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
