import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildTitle(ThemeData theme) => RichText(
  text: TextSpan(
    text: 'Chat ',
    style: GoogleFonts.alegreyaSans(
      color: theme.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    children: [
      TextSpan(
        text: 'App',
        style: GoogleFonts.alegreyaSans(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      ),
    ],
  ),
);