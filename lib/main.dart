import 'app_imports.dart'; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LupusApp());
}

class GameConfig {
  static const String botName = "lupus_infabula_bot"; 

  static const int minPlayers = 3;
}

class LupusApp extends StatelessWidget {
  const LupusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lupus In Fabula',
      theme: getLupusTheme(),
      home: const SchermataLobby(),
    );
  }
}

class SchermataLobby extends StatefulWidget {
  const SchermataLobby({super.key});

  @override
  State<SchermataLobby> createState() => _SchermataLobbyState();
}

class _SchermataLobbyState extends State<SchermataLobby> {
  late String codiceStanza;
  bool caricamento = true;
  bool modalitaManuale = false;
  
  // STATO RUOLI
  int numLupi = 1, numVeggenti = 1, numGuardie = 0; 
  int numMedium = 0, numIndemoniati = 0, numGufi = 0, numMassoni = 0, numCriceti = 0, numMitomani = 0;
  Map<String, int> customRoles = {};

  @override
  void initState() {
    super.initState();
    codiceStanza = GameLogic.generaCodice();
    registraStanzaNelCloud();
  }

Future<void> registraStanzaNelCloud() async {
  try {
    bool codiceValido = false;
    while (!codiceValido) {
      // 1. Controllo se questo codice esiste già su Firebase
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('partite')
          .doc(codiceStanza)
          .get();

      if (doc.exists) {
        // Il codice è già usato! Ne generiamo uno nuovo e riproviamo il ciclo
        debugPrint("Conflitto trovato! Rigenero codice...");
        codiceStanza = GameLogic.generaCodice();
      } else {
        // Il codice è libero, possiamo uscire dal ciclo
        codiceValido = true;
      }
    }
    DateTime dataScadenza = DateTime.now().add(const Duration(hours: 1));
    
    await FirebaseFirestore.instance.collection('partite').doc(codiceStanza).set({
      'creata_il': FieldValue.serverTimestamp(),
      'scadenza': Timestamp.fromDate(dataScadenza),
      'status': 'in_attesa',
    });

    if (mounted) setState(() => caricamento = false);
    
  } catch (e) {
    debugPrint("Errore creazione stanza: $e");
  }
}

  void rigeneraStanza() {
    if (!GameLogic.checkRateLimit()) return;
    setState(() {
      caricamento = true;
      codiceStanza = GameLogic.generaCodice();
    });
    registraStanzaNelCloud();
  }

  void condividiLink() async {
    String link = "https://t.me/${GameConfig.botName}?start=$codiceStanza";
    String messaggio = "Unisciti alla mia partita di Lupus! 🐺\nClicca qui per entrare subito:\n$link";

    final params = ShareParams(
      text: messaggio, 
      subject: "Partita Lupus",
    );

    await SharePlus.instance.share(params);
  }

  // --- MAPPA DELLE DESCRIZIONI RUOLI (2a Persona) ---
  String _getDescrizioneRuolo(String ruolo) {
    if (ruolo.contains("Lupo")) {
      return "Ogni notte ti svegli con gli altri lupi e decidi chi sbranare.";
    } else if (ruolo.contains("Veggente")) {
      return "Ogni notte ti svegli e indichi un giocatore. Il Narratore ti rivela se è Lupo o Innocente.";
    } else if (ruolo.contains("Guardia")) {
      return "Ogni notte proteggi una persona. Quella persona non può essere sbranata dai lupi.";
    } else if (ruolo.contains("Medium")) {
      return "Puoi chiedere al Narratore se il giocatore morto linciato durante il giorno era un Lupo o no.";
    } else if (ruolo.contains("Indemoniato")) {
      return "Stai con i Lupi, ma il Veggente ti vede come Innocente. Non sbrani, ma vinci se vincono i lupi.";
    } else if (ruolo.contains("Gufo")) {
      return "Ogni notte scegli una persona da 'gufare'. Quella persona il giorno dopo avrà già 2 voti contro al ballottaggio.";
    } else if (ruolo.contains("Massone")) {
      return "Ti svegli la prima notte solo per riconoscere gli altri Massoni. Siete contadini semplici che si fidano l'uno dell'altro.";
    } else if (ruolo.contains("Criceto")) {
      return "Giochi da solo. Se vieni sbranato dai Lupi NON muori. Se vieni indagato dal Veggente, MUORI istantaneamente. Vinci se arrivi vivo a fine partita.";
    } else if (ruolo.contains("Mitomane")) {
      return "La prima notte indichi una persona e copi il suo ruolo. Da quel momento diventi quel ruolo.";
    } else if (ruolo.contains("Contadino")) {
      return "Non hai poteri speciali. Il tuo unico potere è il voto e la capacità di ragionare per trovare i lupi.";
    } else {
      return "Segui le indicazioni del Narratore per questo ruolo speciale.";
    }
  }

  Future<void> inviaRuoli(List<QueryDocumentSnapshot> giocatoriDocs) async {
    if (!GameLogic.checkRateLimit()) return;
    int numGiocatori = giocatoriDocs.length;
    if (numGiocatori < GameConfig.minPlayers) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Servono almeno ${GameConfig.minPlayers} giocatori!")));
      return;
    }

    List<String> mazzo = [];
    if (!modalitaManuale) {
      mazzo = GameLogic.getMazzoAutomatico(numGiocatori);
    } else {
      for (var i = 0; i < numLupi; i++) {
        mazzo.add("🐺 Lupo");
      }
      for (var i = 0; i < numVeggenti; i++) {
        mazzo.add("🔮 Veggente");
      }
      for (var i = 0; i < numGuardie; i++) {
        mazzo.add("🛡️ Guardia del Corpo");
      }
      for (var i = 0; i < numMedium; i++) {
        mazzo.add("👻 Medium");
      }
      for (var i = 0; i < numIndemoniati; i++) {
        mazzo.add("👹 Indemoniato");
      }
      for (var i = 0; i < numGufi; i++) {
        mazzo.add("🦉 Gufo");
      }
      for (var i = 0; i < numMassoni; i++) {
        mazzo.add("👷 Massone");
      }
      for (var i = 0; i < numCriceti; i++) {
        mazzo.add("🐹 Criceto M.");
      }
      for (var i = 0; i < numMitomani; i++) {
        mazzo.add("🎭 Mitomane");
      }
      
      customRoles.forEach((n, q) { 
        for (var i = 0; i < q; i++) {
          mazzo.add("✨ $n");
        } 
      });
      
      while (mazzo.length < numGiocatori) {
        mazzo.add("🧑‍🌾 Contadino");
      }
    }

    mazzo.shuffle();

    for (int i = 0; i < numGiocatori; i++) {
      var dati = giocatoriDocs[i].data() as Map<String, dynamic>;
      
      String ruoloAssegnato = mazzo[i];
      String descrizione = _getDescrizioneRuolo(ruoloAssegnato);

      String testo = "🤫 Ciao ${dati['nome']}! Il gioco inizia.\n\n"
                     "Il tuo ruolo è: *$ruoloAssegnato*\n\n"
                     "_($descrizione)_\n\n"
                     "Non dirlo a nessuno!";
      

try {
        await FirebaseFunctions.instance
            .httpsCallable('inviaMessaggioRuolo') 
            .call({
          'chatId': dati['id'],
          'testo': testo,
        });
      } catch (e) {
        debugPrint("Errore Cloud Function: $e");
      }
    }

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Ruoli inviati!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 
     appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_book), 
          tooltip: "Guida e Ruoli",
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const TutorialPage())
            );
          },
        ),        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: LupusColors.accent), 
            tooltip: "Supportami",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoPage()), // Vai alla nuova pagina
              );
            },
          ),
          
          // TASTO REFRESH (ESISTENTE)
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: rigeneraStanza
          ), 
        ],
      ),
      body: caricamento 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              HeaderBox(codice: codiceStanza, onShare: condividiLink),
              const Divider(height: 1),

              GameControls(
                isManuale: modalitaManuale, 
                onModeChanged: (val) => setState(() => modalitaManuale = val), 
                lupi: numLupi, setLupi: (val) => setState(() => numLupi = val),
                veggenti: numVeggenti, setVeggenti: (val) => setState(() => numVeggenti = val),
                guardie: numGuardie, setGuardie: (val) => setState(() => numGuardie = val),
                medium: numMedium, setMedium: (val) => setState(() => numMedium = val),
                indemoniati: numIndemoniati, setIndemoniati: (val) => setState(() => numIndemoniati = val),
                gufi: numGufi, setGufi: (val) => setState(() => numGufi = val),
                massoni: numMassoni, setMassoni: (val) => setState(() => numMassoni = val),
                criceti: numCriceti, setCriceti: (val) => setState(() => numCriceti = val),
                mitomani: numMitomani, setMitomani: (val) => setState(() => numMitomani = val),
                customRoles: customRoles,
                onAddCustomRole: (n) => setState(() { if (!customRoles.containsKey(n)) customRoles[n] = 1; }),
                onUpdateCustomRole: (n, q) => setState(() { q <= 0 ? customRoles.remove(n) : customRoles[n] = q; }),
              ),

              Expanded(
                child: PlayerListView(
                  stream: FirebaseFirestore.instance.collection('partite').doc(codiceStanza).collection('giocatori').snapshots(), 
                  isManuale: modalitaManuale, 
                  onStartGame: inviaRuoli,
                ),
              ),
            ],
          ),
    );
  }
}