import 'package:alpha/Screens/after_sign_in/MainScreen.dart';
import 'package:alpha/Screens/before_sign_in/signup_screen.dart';
import 'package:alpha/Ui/colors.dart';
import 'package:alpha/Widgets/txt_field.dart';
import 'package:alpha/Widgets/utils.dart';
import 'package:alpha/helper/authentication.dart';
import 'package:alpha/helper/conditional_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethod().logInUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    print(res);

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Conditional(),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                Image.asset(
                  'assets/alpha.png',
                  height: 200,
                ),
                TextFieldInput(
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter your Email Address',
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFieldInput(
                  textEditingController: _passwordController,
                  textInputType: TextInputType.text,
                  hintText: 'Enter Password',
                  isPass: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    child: _isLoading
                        ? Center(
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Sign in"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Center(
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('New User?'),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                  ),
                ),
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
