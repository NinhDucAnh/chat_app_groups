import 'package:chat_app_firebase/utils/constants.dart';
import 'package:flutter/material.dart';

const borderSideInputText = BorderSide(color: Color(0xFFee7b64), width: 2);

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),
  focusedBorder: OutlineInputBorder(borderSide: borderSideInputText),
  enabledBorder: OutlineInputBorder(borderSide: borderSideInputText),
  errorBorder: OutlineInputBorder(borderSide: borderSideInputText),
);
