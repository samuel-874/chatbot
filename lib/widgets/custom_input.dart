import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String field;
  final String? placeHolder;
  final Function(String?)? validateFunc;
  final TextEditingController fieldcontroller;

  const CustomInput({
    super.key,
    required this.field,
    required this.placeHolder,
    required this.validateFunc,
    required this.fieldcontroller,
  });

  @override
  build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          placeHolder ?? 'input field',
          style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 0, 47, 255),
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 3,
        ),
        FormField(builder: (context) {
          return TextFormField(
            controller: fieldcontroller,
            decoration: InputDecoration(
                hintText: 'Enter You $field',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffC6C6C6)),
                    borderRadius: BorderRadius.circular(10))),
            validator: (value) {
              if (validateFunc != null) {
                return validateFunc!(value);
              }

              return null;
            },
          );
        })
      ],
    );
  }
}

class CustomPasswordInput extends StatelessWidget {
  final String field;
  final String? placeHolder;
  final bool? hidePassword;
  final Function() toggleShowPassword;
  final Function(String?)? validateFunc;
  final TextEditingController fieldController;

  const CustomPasswordInput(
      {super.key,
      required this.field,
      required this.hidePassword,
      required this.placeHolder,
      required this.validateFunc,
      required this.toggleShowPassword,
      required this.fieldController});

  @override
  build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          placeHolder ?? 'input field',
          style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 0, 47, 255),
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 3,
        ),
        FormField(builder: (context) {
          return TextFormField(
            controller: fieldController,
            obscureText: hidePassword!,
            decoration: InputDecoration(
              hintText: 'Enter You $field',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffC6C6C6)),
                  borderRadius: BorderRadius.circular(10)),
              suffixIcon: GestureDetector(
                  onTap: () {
                    toggleShowPassword();
                  },
                  child: Icon(
                      hidePassword! ? Icons.visibility : Icons.visibility_off)),
            ),
            validator: (value) {
              if (validateFunc != null) {
                return validateFunc!(value);
              }

              return null;
            },
          );
        })
      ],
    );
  }
}
