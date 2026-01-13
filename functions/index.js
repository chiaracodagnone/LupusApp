const { onRequest, onCall } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params"); // <--- Importante per la sicurezza
const { HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

// --- DEFINIZIONE DEI SEGRETI ---
const botToken = defineSecret("BOT_TOKEN");
const telegramSecret = defineSecret("TELEGRAM_SECRET");

// --- FUNZIONE 1: WEBHOOK (Riceve i comandi da Telegram) ---
exports.telegramWebhook = onRequest({ secrets: [botToken, telegramSecret] }, async (req, res) => {
  
  // 1. RECUPERO SICURO DELLE CHIAVI
  const SECRET_VALUE = telegramSecret.value();
  const TOKEN_VALUE = botToken.value();

  // --- BLOCCO DI SICUREZZA ---
  const tokenRicevuto = req.headers['x-telegram-bot-api-secret-token'];
  
  if (tokenRicevuto !== SECRET_VALUE) {
    console.warn("⚠️ Tentativo di accesso non autorizzato bloccato.");
    res.sendStatus(403); 
    return;
  }
  // ---------------------------

  const update = req.body;
  
  if (!update || !update.message || !update.message.text) {
    res.sendStatus(200);
    return;
  }

  const messaggio = update.message;
  const testo = messaggio.text.trim();
  const chatId = messaggio.chat.id.toString();
  const nomeUtente = messaggio.from.first_name || "Giocatore";

  // LOGICA START
  if (testo.startsWith("/start")) {
    const parti = testo.split(" ");
    
    if (parti.length > 1) {
      const codiceStanza = parti[1].toUpperCase().trim();

      try {
        const stanzaRef = admin.firestore().collection('partite').doc(codiceStanza);
        const docStanza = await stanzaRef.get();

        if (docStanza.exists) {
          // A. SALVIAMO SU FIREBASE
          await stanzaRef.collection('giocatori').doc(chatId).set({
            id: chatId,
            nome: nomeUtente,
            data_ingresso: admin.firestore.FieldValue.serverTimestamp(),
            ruolo: null
          });
          
          console.log(`✅ ${nomeUtente} entrato in ${codiceStanza}`);

          // B. RISPONDIAMO SU TELEGRAM
          await fetch(`https://api.telegram.org/bot${TOKEN_VALUE}/sendMessage`, {
             method: 'POST',
             headers: { 'Content-Type': 'application/json' },
             body: JSON.stringify({
               chat_id: chatId,
               text: `👋 Ciao ${nomeUtente}!\n\n✅ Sei nella Stanza **${codiceStanza}**.\n\n⏳ Attendi: appena il Narratore inizia la partita, riceverai il tuo ruolo segreto!`,
               parse_mode: 'Markdown'
             })
          });

        } else {
           // Stanza non esiste
           await fetch(`https://api.telegram.org/bot${TOKEN_VALUE}/sendMessage`, {
             method: 'POST',
             headers: { 'Content-Type': 'application/json' },
             body: JSON.stringify({
               chat_id: chatId,
               text: `❌ **Errore:** La stanza ${codiceStanza} non esiste o è scaduta.\nChiedi al Master il codice corretto!`,
               parse_mode: 'Markdown'
             })
          });
        }
      } catch (errore) {
        console.error("Errore:", errore);
      }
    } else {
        // Utente scrive solo /start
        await fetch(`https://api.telegram.org/bot${TOKEN_VALUE}/sendMessage`, {
             method: 'POST',
             headers: { 'Content-Type': 'application/json' },
             body: JSON.stringify({
               chat_id: chatId,
               text: `Ciao! Per giocare devi usare il link d'invito o scrivere:\n/start CODICE`,
             })
          });
    }
  }

  res.sendStatus(200);
});


// --- FUNZIONE 2: INVIA MESSAGGI (Chiamata da Flutter) ---
exports.inviaMessaggioRuolo = onCall({ secrets: [botToken] }, async (request) => {
  const { chatId, testo } = request.data;
  const TOKEN_VALUE = botToken.value(); // Recupero sicuro

  if (!chatId || !testo) {
    throw new HttpsError("invalid-argument", "Mancano chatId o testo.");
  }

  try {
    const response = await fetch(`https://api.telegram.org/bot${TOKEN_VALUE}/sendMessage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        chat_id: chatId,
        text: testo,
        parse_mode: 'Markdown'
      })
    });

    const result = await response.json();
    
    if (!result.ok) {
      console.error("Errore Telegram API:", result);
      throw new HttpsError("internal", `Errore Telegram: ${result.description}`);
    }

    return { success: true };

  } catch (error) {
    console.error("Errore invio messaggio:", error);
    throw new HttpsError("internal", "Impossibile inviare il messaggio.");
  }
});