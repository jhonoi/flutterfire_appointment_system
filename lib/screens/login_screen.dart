import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_app_firebase/appointment.dart';

class LoginScreen extends StatefulWidget {
  Appointment appointment;

  LoginScreen({@required this.appointment});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController;
  TextEditingController passController;
  bool showError = false;
  String errorVal = '';

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Content(appointment: widget.appointment);
          } else if (constraints.maxWidth < 1000) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 450.0),
                child: Center(
                  child: Content(appointment: widget.appointment),
                ),
              ),
            );
          }
          return Row(
            children: [
              Expanded(
                child: Container(
                  color: Color(0xFF406EB3),
                  width: double.infinity,
                  height: double.infinity,
                  child: UnconstrainedBox(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth < 1300
                              ? (MediaQuery.of(context).size.width / 2) - 100.0
                              : 550.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  constraints.maxWidth < 1300
                                      ? (MediaQuery.of(context).size.width /
                                              2) /
                                          10.0
                                      : 65.0,
                                  0,
                                  0,
                                  10.0),
                              child: Text(
                                'AA Hair Studios',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  constraints.maxWidth < 1300
                                      ? (MediaQuery.of(context).size.width /
                                              2) /
                                          10.0
                                      : 65.0,
                                  0,
                                  0,
                                  20.0),
                              child: Text(
                                'Company Slogan Here. Slogan Here.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                            UnconstrainedBox(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth < 1300
                                        ? (MediaQuery.of(context).size.width /
                                                2) -
                                            100.0
                                        : 550.0),
                                child: Container(
                                  child: Image.asset(
                                    'images/app_showcase_on_desktop.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 40,
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: constraints.maxWidth < 1300
                                          ? (MediaQuery.of(context).size.width /
                                                  2) /
                                              10
                                          : 65.0),
                                  Image.asset(
                                    'images/google_play_badge.png',
                                  ),
                                  SizedBox(width: 10.0),
                                  Image.asset(
                                    'images/ios_badge.png',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: UnconstrainedBox(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500.0),
                      child: Center(
                        child: Content(
                          appointment: widget.appointment,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Content extends StatefulWidget {
  Appointment appointment;
  Content({@required this.appointment});

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  TextEditingController userController;
  TextEditingController emailController;
  TextEditingController passController;
  bool showError = false;
  String errorVal = '';
  bool showProgressIndicator =
      false; //Show loader animation when user logs in/registers and adds new appointment to database
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  @override
  void initState() {
    super.initState();
    userController = TextEditingController();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showProgressIndicator
        ? Center(child: CircularProgressIndicator.adaptive())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Login to AA Hair Studios',
                  style: TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize:
                        MediaQuery.of(context).size.width > 1000 ? 40 : 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Welcome back! Login to see your appointments.',
                    style: TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize:
                          MediaQuery.of(context).size.width > 1000 ? 20 : 14,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    fixedSize: MaterialStateProperty.all(Size(double.infinity,
                        MediaQuery.of(context).size.width > 1000 ? 50 : 40)),
                  ),
                  onPressed: () async {
                    if (kIsWeb) {
                      print('WEB BOIII');
                    } else if (Platform.isAndroid) {
                      final GoogleSignInAccount googleUser =
                          await GoogleSignIn().signIn();

                      // Obtain the auth details from the request
                      final GoogleSignInAuthentication googleAuth =
                          await googleUser.authentication;

                      // Create a new credential
                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );

                      // Once signed in, return the UserCredential
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);

                      users
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) async {
                        if (!documentSnapshot.exists) {
                          await users
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .set({
                            'username':
                                FirebaseAuth.instance.currentUser.displayName
                          });

                          if (widget.appointment != null) {
                            widget.appointment.clientName =
                                FirebaseAuth.instance.currentUser.displayName;
                            widget.appointment.clientID =
                                FirebaseAuth.instance.currentUser.uid;
                            appointments.add(widget.appointment.toMap());
                          }

                          Navigator.of(context).pushReplacementNamed(
                            '/appointments',
                          );
                        }
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20.0,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Image.asset('images/google_icon.png'),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Login with Google',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Color(0xFFDCDCDC),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'or',
                          style: TextStyle(
                            color: Color(0xFF6A6A6A),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Color(0xFFDCDCDC),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: userController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Color(0xFFE9EDF5),
                    filled: true,
                    labelText: 'Client Name',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Color(0xFFE9EDF5),
                      filled: true,
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: passController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_rounded,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Color(0xFFE9EDF5),
                      filled: true,
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF75ACFF)),
                      fixedSize: MaterialStateProperty.all(Size(double.infinity,
                          MediaQuery.of(context).size.width > 1000 ? 50 : 40)),
                      shadowColor: MaterialStateProperty.all(Color(0xFF75ACFF)),
                      elevation: MaterialStateProperty.all(15.0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (emailController.value.text.trim().length > 0 &&
                          passController.value.text.trim().length > 0) {
                        try {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            },
                          );
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.value.text.trim(),
                            password: passController.value.text.trim(),
                          );
                          if (widget.appointment != null) {
                            users
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                Map username = documentSnapshot.data()
                                    as Map<String, dynamic>;
                                widget.appointment.clientName =
                                    username['username'];
                                widget.appointment.clientID =
                                    FirebaseAuth.instance.currentUser.uid;
                                appointments.add(widget.appointment.toMap());
                              } else {
                                print(
                                    'Document does not exist on the database');
                              }
                            });
                          }
                          kIsWeb ? Navigator.pop(context) : null;
                          Navigator.of(context).pushReplacementNamed(
                            '/appointments',
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            setState(() {
                              errorVal = 'No User Found For That Email.';
                              showError = true;
                            });
                          } else if (e.code == 'wrong-password') {
                            setState(() {
                              errorVal = 'Incorrect Password. Try Again';
                              showError = true;
                            });
                          }
                        }
                      } else {
                        setState(() {
                          errorVal = 'Please Enter A Valid Email And Password';
                          showError = true;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF75FFAC)),
                      fixedSize: MaterialStateProperty.all(Size(double.infinity,
                          MediaQuery.of(context).size.width > 1000 ? 50 : 40)),
                      shadowColor: MaterialStateProperty.all(Color(0xFF75FFAC)),
                      elevation: MaterialStateProperty.all(15.0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (emailController.value.text.trim().length > 0 &&
                          passController.value.text.trim().length > 0) {
                        try {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            },
                          );
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.value.text.trim(),
                            password: passController.value.text.trim(),
                          );
                          if (widget.appointment != null) {
                            users
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .set({
                              'username': userController.value.text.trim()
                            });
                            widget.appointment.clientName =
                                userController.value.text.trim();
                            widget.appointment.clientID =
                                FirebaseAuth.instance.currentUser.uid;
                            appointments.add(widget.appointment.toMap());
                          }
                          kIsWeb ? Navigator.pop(context) : null;
                          Navigator.of(context).pushReplacementNamed(
                            '/appointments',
                          );
                        } on FirebaseAuthException catch (e) {
                          Navigator.of(context, rootNavigator: true).pop();
                          if (e.code == 'weak-password') {
                            setState(() {
                              errorVal = 'The Password Provided Is Too Weak.';
                              showError = true;
                            });
                          } else if (e.code == 'email-already-in-use') {
                            setState(() {
                              errorVal =
                                  'The account already exists for that email.';
                              showError = true;
                            });
                          }
                        } catch (e) {
                          Navigator.of(context, rootNavigator: true).pop();
                          print(e);
                        }
                      } else {
                        setState(() {
                          errorVal = 'Please Enter A Valid Email And Password';
                          showError = true;
                        });
                      }
                    },
                  ),
                ),
                showError
                    ? Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Text(
                          errorVal,
                          style: TextStyle(
                            color: Colors.red[400],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
  }
}
