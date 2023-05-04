import 'package:catnizer/pages/account_page.dart';
import 'package:flutter/material.dart';
import '../auth_views/login_view.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.buttonName, required this.borderColor, required this.fillColor});

  final String buttonName;
  final Color borderColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (buttonName == "Login") {
                return const LoginView();
              }
              else {
                return const ProfilePage();
              }
            } 
          )
        );
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(
              color: borderColor,
                )
              )
            ),
          backgroundColor: MaterialStatePropertyAll(fillColor),
          ),
    child: Text(buttonName));
  }
}