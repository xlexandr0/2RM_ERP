import 'package:flutter/material.dart';

const kNavy = Color(0xFF142A3A);
const kPrimary = Color(0xFF1F4E79);
const kOrange = Color(0xFFFF8C32);
const kBackground = Color(0xFFF4F6F8);

Color progressColor(int progress) {
  final value = progress.clamp(0, 100) / 100.0;
  return Color.lerp(
        const Color(0xFFD32F2F),
        const Color(0xFF1565C0),
        value,
      ) ??
      kPrimary;
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
    scaffoldBackgroundColor: kBackground,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE3E8EE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimary, width: 2),
      ),
    ),
  );
}

BoxDecoration cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE5EAF0)),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          blurRadius: 18,
          offset: Offset(0, 5),
          color: Color(0x0A000000),
        ),
      ],
    );
