import 'package:flutter/material.dart';
import 'package:gadgethive/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;
  final _formkey = GlobalKey<FormState>();

  moveToHome(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      await Future.delayed(Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.homeRoute);
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          Material(
              color: context.canvasColor,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Image.asset(
                          "images/hey.png",
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Welcome $name",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 32.0),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Enter username",
                                  labelText: "Username",
                                ),
                                onChanged: (value) {
                                  name = value;
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Username cannot be empty";
                                  }
                                  if (value!.length < 4) {
                                    return "Username must be at least 4 characters long";
                                  }
                                  if (value!.length > 20) {
                                    return "Username must be less than 20 characters long";
                                  }
                                  if (!RegExp(r'^[a-zA-Z0-9]+$')!
                                      .hasMatch(value)) {
                                    return "Username can only contains letters and numbers";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Enter password",
                                  labelText: "Password",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "password cannot be empty";
                                  } else if (value!.length < 6) {
                                    return "Password length should be atleast 6";
                                  }
                                  if (value.length > 20) {
                                    return 'Password must be less than 20 characters long';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Material(
                                color: context.theme.buttonColor,
                                borderRadius: BorderRadius.circular(
                                    changeButton ? 50 : 8),
                                child: InkWell(
                                  onTap: () => moveToHome(context),
                                  child: AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    width: changeButton ? 50 : 150,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: changeButton
                                        ? Icon(
                                            Icons.done,
                                            color: Colors.white,
                                          )
                                        : Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
