import 'dart:math';

class GameLogic {
  
  static String generaCodice() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  static List<String> getMazzoAutomatico(int numeroGiocatori) {
    List<String> mazzo = [];
    
    int lupi = 1;
    int veggenti = 0;
    int guardie = 0; 

    if (numeroGiocatori >= 4) veggenti = 1;
    if (numeroGiocatori >= 6) lupi = 2;
    if (numeroGiocatori >= 7) guardie = 1; 

    for (var i = 0; i < lupi; i++) {
      mazzo.add("🐺 Lupo");
    }
    for (var i = 0; i < veggenti; i++) {
      mazzo.add("🔮 Veggente");
    }
    for (var i = 0; i < guardie; i++) {
      mazzo.add("🛡️ Guardia del Corpo");
    }

    while (mazzo.length < numeroGiocatori) {
      mazzo.add("🧑‍🌾 Contadino");
    }
    
    if (mazzo.length > numeroGiocatori) {
        mazzo = mazzo.sublist(0, numeroGiocatori);
    }

    return mazzo;
  }

  static String calcolaRiepilogoMazzo(int numGiocatori) {
    if (numGiocatori < 3) {
      return "I ruoli saranno scelti automaticamente in base al numero di giocatori.";
    }
    
    List<String> mazzo = getMazzoAutomatico(numGiocatori);
    Map<String, int> conteggio = {};
    
    for (var ruolo in mazzo) {
      conteggio[ruolo] = (conteggio[ruolo] ?? 0) + 1;
    }

    List<String> parti = [];
    conteggio.forEach((ruolo, quantita) {
      parti.add("$quantita $ruolo");
    });

    return "Con $numGiocatori giocatori: ${parti.join(', ')}";
  }

  static final List<DateTime> _azioneTimestamps = [];
  static const int _maxAzioni = 10;
  static const Duration _finestraTemporale = Duration(minutes: 5);

  static bool checkRateLimit() {
    final now = DateTime.now();
    _azioneTimestamps.removeWhere((t) => now.difference(t) > _finestraTemporale);

    if (_azioneTimestamps.length >= _maxAzioni) {
      return false;
    }

    _azioneTimestamps.add(now);
    return true;
  }
}