import 'package:flutter/material.dart';
import '../style.dart'; 

class HeaderBox extends StatelessWidget {
  final String codice;
  final VoidCallback onShare;

  const HeaderBox({super.key, required this.codice, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))
        ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("CODICE STANZA:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600])),
              const SizedBox(width: 10),
              Text(codice, style: LupusTextStyles.code),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 45,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: LupusColors.primary, 
                foregroundColor: LupusColors.accent,  
                padding: const EdgeInsets.symmetric(horizontal: 25),
              ),
              icon: const Icon(Icons.share, size: 24),
              label: const Text("INVITA AMICI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              onPressed: onShare,
            ),
          ),
        ],
      ),
    );
  }
}