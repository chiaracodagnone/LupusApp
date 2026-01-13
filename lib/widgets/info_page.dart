import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Aggiungi al pubspec
import '../style.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  // Sostituisci con il tuo link reale (es. ko-fi, buymeacoffee, paypal)
  final String _donationUrl = "https://buymeacoffee.com/chiaracodagnone"; 
  final String _portfolioUrl = "https://github.com/chiara"; // Opzionale

  Future<void> _apriLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Impossibile aprire il link: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Info")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- 1. LOGO O AVATAR ---
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: LupusColors.accent, width: 3), // Un bel bordo dorato
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const CircleAvatar(
                radius: 55, // Un po' più grande
                backgroundColor: LupusColors.primary, // Colore di sfondo se l'immagine è trasparente
                // QUI SI CARICA LA TUA IMMAGINE:
                backgroundImage: AssetImage('assets/icon.png'), 
              ),
            ),
            const SizedBox(height: 20),

            // --- 2. TITOLO E DESCRIZIONE ---
            const Text(
              "Lupus App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: LupusColors.primary),
            ),
            const SizedBox(height: 10),
            const Text(
              "Sviluppata con passione per rendere le vostre serate più divertenti!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            
            const SizedBox(height: 40),

            // --- 3. SEZIONE "OFFRIMI UN CAFFÈ" ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.orange.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
                ],
                border: Border.all(color: LupusColors.accent.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Text("Ti piace l'app?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text(
                    "L'app è gratuita e senza pubblicità invasiva. Puoi supportare il mio lavoro e coprire i costi dei server",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDD00), // Colore tipico "Buy me a Coffee"
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => _apriLink(_donationUrl),
                    icon: const Icon(Icons.coffee_rounded),
                    label: const Text("Offrimi un Caffè"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            
            // --- 4. CREDITS TECNICI E SOCIAL ---
            const Divider(),
            const SizedBox(height: 10),
            const Text("Design & Sviluppo di Chiara Codagnone", style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => _apriLink(_portfolioUrl),
              child: const Text("GitHub"),
            ),
            
            const SizedBox(height: 20),
            Text("Versione 1.0.0", style: LupusTextStyles.italicInfo),
          ],
        ),
      ),
    );
  }
}