import '../app_imports.dart';

class GameControls extends StatefulWidget {
  final bool isManuale;
  final Function(bool) onModeChanged;
  
  // Ruoli Base
  final int lupi, veggenti, guardie;
  final Function(int) setLupi;
  final Function(int) setVeggenti;
  final Function(int) setGuardie;

  // Ruoli Speciali
  final int medium, indemoniati, gufi, massoni, criceti, mitomani;
  final Function(int) setMedium, setIndemoniati, setGufi, setMassoni, setCriceti, setMitomani;

  // Ruoli Custom
  final Map<String, int> customRoles;
  final Function(String, int) onUpdateCustomRole;
  final Function(String) onAddCustomRole; 

  const GameControls({
    super.key,
    required this.isManuale,
    required this.onModeChanged,
    required this.lupi, required this.setLupi,
    required this.veggenti, required this.setVeggenti,
    required this.guardie, required this.setGuardie,
    required this.medium, required this.setMedium,
    required this.indemoniati, required this.setIndemoniati,
    required this.gufi, required this.setGufi,
    required this.massoni, required this.setMassoni,
    required this.criceti, required this.setCriceti,
    required this.mitomani, required this.setMitomani,
    required this.customRoles,
    required this.onUpdateCustomRole,
    required this.onAddCustomRole,
  });

  @override
  State<GameControls> createState() => _GameControlsState();
}

class _GameControlsState extends State<GameControls> {
  bool _configurazioneAperta = false; 
  final ScrollController _scrollController = ScrollController();

  void _mostraDialogAggiungiRuolo(BuildContext context) {
    TextEditingController tempController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        content: TextField(
          controller: tempController,
          autofocus: true,
          cursorColor: LupusColors.accent,
          style: const TextStyle(fontSize: 18),
          decoration: const InputDecoration(
            hintText: "Es. Vampiro",
            border: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LupusColors.primary, width: 2)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("ANNULLA", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (tempController.text.isNotEmpty) {
                widget.onAddCustomRole(tempController.text);
                Navigator.of(ctx).pop();
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });
              }
            },
            child: const Text("AGGIUNGI"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TASTI SELEZIONE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            children: [
              _buildModeBtn("AUTOMATICO", false),
              const SizedBox(width: 10),
              _buildModeBtn("MANUALE", true),
            ],
          ),
        ),

        if (widget.isManuale) ...[
          // BOTTONE APRI/CHIUDI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            child: SizedBox(
              width: double.infinity,
              height: 50, 
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _configurazioneAperta ? Colors.grey[800] : LupusColors.primary,
                  foregroundColor: LupusColors.accent, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => setState(() => _configurazioneAperta = !_configurazioneAperta),
                icon: Icon(_configurazioneAperta ? Icons.close : Icons.settings, color: LupusColors.accent, size: 24),
                label: Text(_configurazioneAperta ? "CHIUDI CONFIGURAZIONE" : "CONFIGURA I RUOLI", 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ),

          // PANNELLO CONFIGURAZIONE
          if (_configurazioneAperta)
            Container(
              margin: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.35, // Altezza 35% anti-overflow
              decoration: BoxDecoration(
                border: Border.all(color: LupusColors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0,4))]
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: LupusColors.primary.withValues(alpha: 0.1), 
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: const Text(
                      "🛠️ MODIFICA I RUOLI", 
                      textAlign: TextAlign.center, 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: LupusColors.accent, letterSpacing: 1.2)
                    ), 
                  ),
                  
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text("Ruoli Base:", style: LupusTextStyles.title.copyWith(fontSize: 18)),
                            const SizedBox(height: 8),
                            _buildCounter("🐺 Lupo", widget.lupi, widget.setLupi, min: 1),
                            _buildCounter("🔮 Veggente", widget.veggenti, widget.setVeggenti),
                            _buildCounter("🛡️ Guardia del Corpo", widget.guardie, widget.setGuardie),
                            
                            const Divider(height: 30),
                            Text("Ruoli Speciali:", style: LupusTextStyles.title.copyWith(fontSize: 18)),
                            const SizedBox(height: 8),
                            _buildCounter("👻 Medium", widget.medium, widget.setMedium),
                            _buildCounter("👹 Indemoniato", widget.indemoniati, widget.setIndemoniati),
                            _buildCounter("🦉 Gufo", widget.gufi, widget.setGufi),
                            _buildCounter("👷 Massone", widget.massoni, widget.setMassoni),
                            _buildCounter("🐹 Criceto M.", widget.criceti, widget.setCriceti),
                            _buildCounter("🎭 Mitomane", widget.mitomani, widget.setMitomani),
                            
                            const Divider(height: 30),
                            Text("Ruoli Personalizzati:", style: LupusTextStyles.title.copyWith(fontSize: 18)),
                            ...widget.customRoles.entries.map((e) => _buildCounter("✨ ${e.key}", e.value, (v) => widget.onUpdateCustomRole(e.key, v))),
                            
                            const SizedBox(height: 20),
                            
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.add, size: 24),
                                label: const Text("AGGIUNGI NUOVO RUOLO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                onPressed: () => _mostraDialogAggiungiRuolo(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: LupusColors.primary,
                                  side: const BorderSide(color: LupusColors.primary, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildModeBtn(String label, bool modeValue) {
    bool isActive = (widget.isManuale == modeValue);
    return Expanded(
      child: SizedBox(
        height: 50, 
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? LupusColors.primary : Colors.grey[300],
            foregroundColor: isActive ? LupusColors.accent : Colors.grey[700],
            elevation: isActive ? 4 : 0,
          ),
          onPressed: () => widget.onModeChanged(modeValue),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), 
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int val, Function(int) onChange, {int min = 0}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6), 
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: LupusColors.primary)),
          Row(
            children: [
              InkWell(
                onTap: () { if (val > min) onChange(val - 1); },
                child: Icon(Icons.remove_circle, size: 30, color: val > min ? LupusColors.red : Colors.grey[300]), 
              ),
              SizedBox(width: 40, child: Text("$val", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))), 
              InkWell(
                onTap: () => onChange(val + 1),
                child: const Icon(Icons.add_circle, size: 30, color: LupusColors.green), 
              ),
            ],
          )
        ],
      ),
    );
  }
}