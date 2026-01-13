import 'package:flutter/material.dart';
import '../style.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  // false = Visualizza Regole, true = Visualizza Ruoli
  bool _mostraRuoli = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guida"),
      ),
      body: Column(
        children: [
          // --- SELETTORE (Stile Automatico/Manuale) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildTabBtn("📖 REGOLE", false),
                const SizedBox(width: 10),
                _buildTabBtn("🎭 RUOLI", true),
              ],
            ),
          ),
          
          const Divider(height: 1),

          // --- CONTENUTO SCORREVOLE ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _mostraRuoli ? _buildListaRuoli() : _buildTutorial(),
            ),
          ),
        ],
      ),
    );
  }

  // Costruttore del bottone tab
  Widget _buildTabBtn(String label, bool isRuoliTab) {
    bool isActive = (_mostraRuoli == isRuoliTab);
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? LupusColors.primary : Colors.grey[200],
          foregroundColor: isActive ? LupusColors.accent : Colors.grey[700],
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => setState(() => _mostraRuoli = isRuoliTab),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- SEZIONE 1: TUTORIAL ---
  Widget _buildTutorial() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titolo("Come si gioca?"),
        _paragrafo(
          "Lupus in Fabula è un gioco di deduzione sociale. Ci sono due squadre: "
          "il Villaggio (i buoni) e i Lupi (i cattivi). L'obiettivo del Villaggio è linciare tutti i Lupi. "
          "L'obiettivo dei Lupi è sbranare tutti i contadini."
        ),
        
        const SizedBox(height: 20),
        _titolo("🌙 La Notte"),
        _paragrafo(
          "Quando il Narratore annuncia la notte, TUTTI i giocatori devono chiudere gli occhi "
          "(o girarsi di spalle). Nessuno può parlare.\n\n"
          "Il Narratore chiamerà i ruoli uno alla volta (es. 'Lupi aprite gli occhi'). "
          "Chi viene chiamato apre gli occhi, compie la sua azione silenziosamente (indicando) e li richiude."
        ),

        const SizedBox(height: 20),
        _titolo("☀️ Il Giorno"),
        _paragrafo(
          "Tutti aprono gli occhi. Il Narratore annuncia chi è morto durante la notte (sbranato dai lupi). "
          "Il morto non può più parlare né giocare.\n\n"
          "I sopravvissuti iniziano a discutere: chi è sospetto? Chi ha sentito rumori? "
          "Al termine della discussione, si vota per il linciaggio."
        ),

        const SizedBox(height: 20),
        _titolo("🔥 Il Voto"),
        _paragrafo(
          "Ogni giocatore indica col dito chi vuole eliminare. Chi riceve più voti viene linciato dal villaggio "
          "e muore. Se c'è un pareggio, solitamente nessuno muore o si va al ballottaggio."
        ),
      ],
    );
  }

  // --- SEZIONE 2: LISTA RUOLI ---
  Widget _buildListaRuoli() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ruoloCard("🐺", "Lupo Mannaro", "Ogni notte si sveglia con gli altri lupi e decide chi sbranare."),
        _ruoloCard("🔮", "Veggente", "Ogni notte si sveglia e indica un giocatore. Il Narratore gli rivela se è Lupo o Innocente."),
        _ruoloCard("🛡️", "Guardia del Corpo", "Ogni notte protegge una persona. Quella persona non può essere sbranata dai lupi."),
        _ruoloCard("👻", "Medium", "Può chiedere al Narratore se il giocatore morto linciato durante il giorno era un Lupo o no."),
        _ruoloCard("👹", "Indemoniato", "Sta con i Lupi, ma il Veggente lo vede come Innocente. Non sbrana, ma vince se vincono i lupi."),
        _ruoloCard("🦉", "Gufo", "Ogni notte sceglie una persona da 'gufare'. Quella persona il giorno dopo avrà già 2 voti contro al ballottaggio."),
        _ruoloCard("👷", "Massone", "I massoni si svegliano la prima notte solo per riconoscersi tra loro. Sono contadini semplici che si fidano l'uno dell'altro."),
        _ruoloCard("🐹", "Criceto Mannaro", "Gioca da solo. Se viene sbranato dai Lupi NON muore. Se viene indagato dal Veggente, MUORE istantaneamente. Vince se arriva vivo a fine partita."),
        _ruoloCard("🎭", "Mitomane", "La prima notte indica una persona e copia il suo ruolo. Da quel momento diventa quel ruolo."),
        _ruoloCard("🧑‍🌾", "Contadino", "Non ha poteri speciali. Il suo unico potere è il voto e la capacità di ragionare per trovare i lupi."),
      ],
    );
  }

  // --- STILI HELPER ---
  Widget _titolo(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: LupusColors.primary)),
    );
  }

  Widget _paragrafo(String text) {
    return Text(text, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87));
  }

  Widget _ruoloCard(String icon, String title, String desc) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: LupusColors.primary)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}