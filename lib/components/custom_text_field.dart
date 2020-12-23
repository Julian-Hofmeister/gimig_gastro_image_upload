import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.name,
    this.value,
    this.icon,
  });

  String name;
  String value;
  Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w400,
            color: Color(0xFFCFCFCF),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.01,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.1,
          child: IgnoreFocusWatcher(
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                value = value;
              },
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              style: TextStyle(color: Colors.white),
              cursorHeight: MediaQuery.of(context).size.width * 0.045,
              cursorWidth: 1.2,
              decoration: new InputDecoration(
                suffixIcon: icon != null
                    ? Icon(
                        Icons.euro_symbol,
                        color: Colors.tealAccent,
                        size: 20,
                      )
                    : null,
                disabledBorder: InputBorder.none,
                fillColor: Color(0xFF4B4B4B),
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 15,
                ),
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                  borderSide: new BorderSide(
                    color: Color(0xFF4B4B4B),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Color(0xFFFFA374),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Color(0xFF4B4B4B),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              cursorColor: Color(0xFF74FFD0),
            ),
          ),
        ),
      ],
    );
  }
}
