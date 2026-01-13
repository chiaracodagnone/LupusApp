import 'package:flutter/material.dart';

class LupusColors {
  
  // Blu Notte  (Barre, Bottoni principali, Testate)
  static const Color primary = Color(0xFF14213D); 
  
  // Giallo Ocra (Icone, Dettagli, Testo su sfondo scuro)
  static const Color accent = Color(0xFFFCA311);  
  
  // Sfondo (Grigio chiarissimo)
  static const Color background = Color(0xFFF5F5F5); 

  // Colori funzionali
  static const Color textLight = Colors.white;
  static const Color textDark = Color(0xFF14213D); // Il testo scuro è il blu stesso
  static const Color red = Color(0xFFD32F2F); // Rosso spento per errori/rimuovi
  static const Color green = Color(0xFF388E3C); // Verde foresta per conferme/aggiungi
}

class LupusTextStyles {
  // Stili di testo
  static TextStyle title = const TextStyle(
    fontSize: 22, 
    fontWeight: FontWeight.bold, 
    color: LupusColors.primary
  );

  static TextStyle code = const TextStyle(
    fontSize: 32, 
    fontWeight: FontWeight.w900, 
    color: LupusColors.accent, // Il codice stanza ora è Ocra
    letterSpacing: 3.0,
    fontFamily: 'Courier', // Un tocco più "segreto"
  );

  static TextStyle normalBold = const TextStyle(
    fontWeight: FontWeight.bold, 
    fontSize: 16,
    color: LupusColors.textDark
  );

  static TextStyle italicInfo = TextStyle(
    fontStyle: FontStyle.italic, 
    fontSize: 13, 
    color: Colors.grey[600]
  );
  
  // Stile per i bottoni scuri (testo ocra)
  static TextStyle buttonText = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: LupusColors.accent 
  );
}

// Configurazione globale del tema Flutter
ThemeData getLupusTheme() {
  return ThemeData(
    primaryColor: LupusColors.primary,
    useMaterial3: true,
    scaffoldBackgroundColor: LupusColors.background,
    
    // Configurazione AppBar (Blu Notte + Testo Ocra)
    appBarTheme: const AppBarTheme(
      backgroundColor: LupusColors.primary,
      foregroundColor: LupusColors.accent, 
      centerTitle: true,
      elevation: 0,
    ),
    
    // Configurazione Bottoni
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LupusColors.primary,
        foregroundColor: LupusColors.accent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    
    // Configurazione Icone
    iconTheme: const IconThemeData(color: LupusColors.primary),
  );
}