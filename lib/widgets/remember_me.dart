import 'package:flutter/material.dart';

class RememberMe extends StatefulWidget {
  Function() onChange;
  bool rememberMe;

  RememberMe({super.key, required this.onChange, required this.rememberMe});

  @override
  State<StatefulWidget> createState() => RememberMeState();
}

class RememberMeState extends State<RememberMe> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    widget.onChange();
                  },
                  child: Icon(
                    widget.rememberMe
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                  )),
              Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "Remember Me",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ))
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/forgotten_password");
          },
          child: const Text(
            "Forgotten Password",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
