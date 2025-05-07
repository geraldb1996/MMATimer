import 'package:flutter/material.dart';

class AppStyles {
  // Colores principales de la aplicación
  static const Color colorPrimario = Color(0xFF1A1A1A); // Negro principal
  static const Color colorSecundario = Color.fromARGB(
    255,
    97,
    97,
    97,
  ); // Amarillo
  static const Color colorGrisClaro = Color(0xFFF5F5F5); // Gris claro
  static const Color colorGrisOscuro = Color(0xFF333333); // Gris oscuro
  static const Color colorSelection = Color.fromARGB(255, 29, 1, 185);

  // Estilo del título principal
  static const TextStyle titulo = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: colorGrisClaro,
    letterSpacing: 1.5,
    shadows: [
      Shadow(color: Colors.black54, offset: Offset(2, 2), blurRadius: 3),
    ],
  );

  // Estilo del subtítulo
  static const TextStyle subtitulo = TextStyle(
    fontSize: 18,
    color: colorGrisOscuro,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  // Estilo de tarjeta/contenedor
  static BoxDecoration tarjeta = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    border: Border.all(color: colorGrisOscuro.withOpacity(0.1), width: 1),
  );

  // Gradiente de fondo profesional
  static const LinearGradient fondo = LinearGradient(
    colors: [
      Color(0xFF1A1A1A), // Negro
      Color(0xFF2C2C2C), // Gris muy oscuro
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Estilo de botón moderno
  static ButtonStyle gymButton = ElevatedButton.styleFrom(
    backgroundColor: colorSecundario,
    foregroundColor: colorPrimario,
    textStyle: const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 18,
      letterSpacing: 1.2,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 4,
    shadowColor: Colors.black26,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
  ).copyWith(
    overlayColor: MaterialStateProperty.resolveWith<Color?>((
      Set<MaterialState> states,
    ) {
      if (states.contains(MaterialState.pressed)) {
        return colorSecundario.withOpacity(0.8);
      }
      return null;
    }),
  );
}
