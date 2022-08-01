import 'package:flutter/material.dart';
import 'package:chat_app/services/theme.dart';

Widget loading() => Center(
  child: CircularProgressIndicator(
    color: mainColor,
  ),
);