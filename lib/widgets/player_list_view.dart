import '../app_imports.dart';

class PlayerListView extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final bool isManuale;
  final Function(List<QueryDocumentSnapshot>) onStartGame;

  const PlayerListView({
    super.key,
    required this.stream,
    required this.isManuale,
    required this.onStartGame,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var documenti = snapshot.data!.docs;

        return Column(
          children: [
            if (!isManuale)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Text(
                  GameLogic.calcolaRiepilogoMazzo(documenti.length),
                  style: LupusTextStyles.italicInfo,
                  textAlign: TextAlign.center,
                ),
              ),

            if (documenti.isEmpty) 
               const Expanded(child: Center(child: Text("In attesa di giocatori...", style: TextStyle(color: Colors.grey)))),
            
            if (documenti.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                color: Colors.blueGrey[50],
                child: Text("GIOCATORI CONNESSI (${documenti.length})", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: LupusColors.primary)),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: documenti.length,
                  itemBuilder: (context, index) {
                    var data = documenti[index].data() as Map<String, dynamic>;
                    
                    String nome = data['nome']?.toString() ?? "Sconosciuto";
                    String iniziale = "?";
                    if (nome.isNotEmpty) {
                      try {
                        iniziale = nome.substring(0, 1).toUpperCase();
                      } catch (e) { iniziale = "#"; }
                    }

                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: CircleAvatar(
                          backgroundColor: LupusColors.primary, // Blu Notte
                          foregroundColor: LupusColors.accent,  // Giallo Ocra
                          child: Text(iniziale, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        title: Text(nome, style: const TextStyle(fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.check_circle, color: LupusColors.green, size: 20),
                      ),
                    );
                  },
                ),
              ),
            ],
            
            if (documenti.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55, 
                  child: ElevatedButton(
                    // STILE BOTTONE FINALE 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LupusColors.primary, 
                      foregroundColor: LupusColors.accent,
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.white,
                          titlePadding: const EdgeInsets.only(top: 20, bottom: 10),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          title: Column(
                            children: [
                              const Icon(Icons.rocket_launch, color: LupusColors.primary, size: 40),
                              const SizedBox(height: 10),
                              const Text("Pronti?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          ),
                          content: Text(
                            "Assegna ruoli a ${documenti.length} giocatori.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actionsPadding: const EdgeInsets.only(bottom: 15),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text("Indietro", style: TextStyle(color: Colors.grey)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LupusColors.primary,
                                foregroundColor: LupusColors.accent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop(); 
                                onStartGame(documenti);  
                              },
                              child: const Text("VAI!"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text("ASSEGNA RUOLI E INIZIA 🚀", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}