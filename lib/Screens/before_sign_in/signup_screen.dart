import 'dart:typed_data';

import 'package:alpha/Screens/after_sign_in/MainScreen.dart';
import 'package:alpha/Screens/before_sign_in/login_screen.dart';
import 'package:alpha/Ui/colors.dart';
import 'package:alpha/Ui/utils.dart';
import 'package:alpha/Widgets/txt_field.dart';
import 'package:alpha/Widgets/utils.dart';
import 'package:alpha/helper/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snackbar_extension/snackbar_extension.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _middleController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  Uint8List? image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _middleController.dispose();
    _lastController.dispose();
    _phoneNumberController.dispose();
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagepicker = ImagePicker();

    XFile? imageFile = await imagepicker.pickImage(source: source);
    if (imageFile != null) {
      return await imageFile.readAsBytes();
    }
    print('no image selected');
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethod().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      image: image,
    );
    print(res);

    if (res != "success") {
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
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Stack(children: [
                  Image.asset(
                    'assets/alpha.png',
                    height: 200,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 100,
                    child: IconButton(
                      onPressed: () {
                        pickImage;
                      },
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ]),
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
                TextFieldInput(
                  textEditingController: _fullNameController,
                  textInputType: TextInputType.text,
                  hintText: 'First Name',
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFieldInput(
                  textEditingController: _phoneNumberController,
                  textInputType: TextInputType.text,
                  hintText: 'Phone Number',
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    signUpUser();
                  },
                  child: Container(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Sign Up"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Already have an account ? "),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Container(
                        child: const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
