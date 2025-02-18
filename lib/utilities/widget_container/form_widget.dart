import 'package:flutter/material.dart';

class FormContainer extends StatefulWidget {
  final TextEditingController controller;
  final Key? fieldkey;
  final bool? passwordfield;
  final String? hinttext;
  final String? labeltext;
  final String? helpertext;
  final FormFieldSetter<String>? onsaved;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onfieldsubmitted;
  final TextInputType? inputtype;
  final IconData? prefixicon;



  const FormContainer(
      {super.key,
        required this.controller,
        this.fieldkey,
        this.hinttext,
        this.labeltext,
        this.helpertext,
        this.onsaved,
        this.validator,
        this.onfieldsubmitted,
        this.passwordfield,
        this.inputtype,
        this.prefixicon,
      });

  @override
  State<FormContainer> createState() => _FormContainerState();
}

bool _obsbcuretext = true;

class _FormContainerState extends State<FormContainer> {
  @override
  Widget build(BuildContext context) {
  
    // double screenHeight = MediaQuery.of(context).size.height;
    return
    TextFormField(style: const TextStyle(color: Colors.blue),

        controller: widget.controller,
        keyboardType: widget.inputtype,
        key: widget.fieldkey,
        obscureText: widget.passwordfield == true? _obsbcuretext : false
            ? _obsbcuretext
            : false,
        onSaved: widget.onsaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onfieldsubmitted,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          labelStyle: const TextStyle(color: Colors.blueAccent),
          filled: true,
          hintText: widget.hinttext,
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(widget.prefixicon,color: Colors.blue,),
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obsbcuretext = !_obsbcuretext;
                });
              },
              child: widget.passwordfield == true ? Icon(
                  _obsbcuretext ? Icons.visibility_off : Icons.visibility,
                  color: _obsbcuretext == false ? Colors.grey : Colors.blue) :const Text("")
          ),
        ),

      // ),

    );
  }
}
