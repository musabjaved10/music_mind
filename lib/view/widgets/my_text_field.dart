import 'package:flutter/material.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/view/widgets/my_text.dart';

class MyTextField extends StatefulWidget {
  var hintText, label;
  bool? obsecure;
  int? maxlines;
  VoidCallback? onSaved;
  TextEditingController? controller = TextEditingController();
  Icon? inputIcon;

  MyTextField(
      {Key? key,
      this.hintText,
      this.label,
      this.maxlines = 1,
      this.obsecure = false,
      this.controller,
      this.inputIcon = null})
      : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  var isObscure = false;

  @override
  void initState() {
    isObscure = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heading16('${widget.label}'),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: widget.controller?.text,
            onChanged: (value) {
              // print(value);
              widget.controller?.text = value;
            },
            textAlignVertical: TextAlignVertical.center,
            cursorColor: KSecondaryColor,
            maxLines: widget.maxlines,
            style: const TextStyle(
              color: KSecondaryColor,
              fontSize: 16,
            ),
            obscureText: isObscure,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    widget.inputIcon != null ?
                    setState(() {
                      isObscure = !isObscure;
                    }) : null;
                  },
                  icon: widget.inputIcon == null
                      ? Icon(null)
                      : isObscure == true
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off)),
              hintText: '${widget.hintText}',
              hintStyle: const TextStyle(
                color: KGrey2Color,
                fontSize: 16,
              ),
              fillColor: KTertiaryColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: KTertiaryColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: KTertiaryColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
