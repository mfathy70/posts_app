import 'package:flutter/material.dart';

class ManageAccountButton extends StatelessWidget {
  const ManageAccountButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(width: 1),
          ),
        ),
      ),
      child: Text(
        'Manage your Account',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
