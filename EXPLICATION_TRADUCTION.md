# 🎯 Guide Technique : Traduction et Transcription en Temps Réel

Ce document explique en profondeur l'architecture et l'implémentation de la fonctionnalité de traduction intégrée à votre plateforme de réunion.

## 🏗️ Architecture Globale

L'implémentation repose sur trois piliers technologiques majeurs, choisis pour leur efficacité et leur absence de coût :

1.  **Web Speech API** : Reconnaissance vocale côté client.
2.  **LiveKit Data Tracks** : Transport instantané du texte entre les participants.
3.  **API Google Translate (GTX)** : Traduction automatique gratuite.

---

## 1. La Reconnaissance Vocale (Web Speech API)

Au lieu d'utiliser des services payants comme Google Cloud Speech-to-Text ou OpenAI Whisper, nous utilisons la **Web Speech API** déjà présente dans votre navigateur.

### Comment ça marche ?
Dans le fichier `TranslationManager.ts`, nous initialisons l'objet `SpeechRecognition` :

```typescript
this.recognition = new SpeechRecognition();
this.recognition.continuous = true; // Continue d'écouter même après une phrase
this.recognition.interimResults = true; // Donne des résultats au fur et à mesure que vous parlez
```

- **interimResults** permet d'afficher le texte "pendant" que vous parlez (effet dynamique).
- **lang** est configuré sur `fr-FR` par défaut.

---

## 2. Le Transport des Données (LiveKit Data Tracks)

C'est l'étape la plus cruciale. Pour que les autres voient ce que vous dites, nous n'utilisons pas le flux audio (trop lourd à analyser côté serveur), mais les **Data Tracks** de LiveKit.

### Processus d'envoi :
Dès qu'un fragment de texte est reconnu, il est packagé en JSON et envoyé via le réseau LiveKit :

```typescript
const data = encoder.encode(JSON.stringify({
  type: "transcript",
  text: text,
  isFinal: isFinal,
  participantName: "Nom de l'utilisateur"
}));

// Envoi fiable et instantané à tous les autres participants
this.room.localParticipant.publishData(data, { reliable: true });
```

### Pourquoi c'est génial ?
- **Latence quasi-nulle** : Le texte arrive souvent avant même que le son ne soit traité par l'oreille des autres.
- **Économie de ressources** : Aucun traitement lourd n'est fait sur votre serveur backend.

---

## 3. La Logique de Traduction (API GTX)

Chaque participant reçoit le texte original. C'est le **destinataire** qui effectue la traduction dans sa propre langue préférée.

### L'astuce "Free" :
Nous utilisons l'endpoint public et non officiel de Google Translate :
`https://translate.googleapis.com/translate_a/single?client=gtx&dt=t&q=...`

Cet endpoint permet de traduire des chaînes de texte courtes sans clé API et sans frais, ce qui est parfait pour de la transcription de réunion.

```typescript
private async translateText(text: string, source: string, target: string): Promise<string> {
  const url = `...&sl=${source}&tl=${target}&q=${encodeURIComponent(text)}`;
  const response = await fetch(url);
  const data = await response.json();
  return data[0][0][0]; // Extraction du texte traduit
}
```

---

## 4. Intégration dans l'Interface React

Le `TranslationManager` est une classe TypeScript pure qui gère l'état interne. Son intégration dans React se fait via un `useMemo` pour assurer qu'une seule instance existe par réunion :

```tsx
const translationManager = useMemo(() => {
    return new TranslationManager(room, (newTranscripts) => {
        setTranscripts(newTranscripts); // Met à jour l'UI à chaque nouveau mot
    });
}, [room]);
```

### UX (Expérience Utilisateur) :
- **Opacity variable** : Le texte est légèrement transparent (`opacity-70`) tant qu'il est en cours de reconnaissance, et devient opaque (`opacity-100`) une fois la phrase terminée.
- **Scroll Automatique** : Les transcriptions les plus récentes apparaissent en haut du panneau pour une lecture naturelle.

---

## 🏁 Résumé des Avantages

| Fonctionnalité | Solution choisie | Coût | Confidentialité |
| :--- | :--- | :--- | :--- |
| **Transcription** | Web Speech API | 0 € | Traité localement par le navigateur |
| **Transport** | LiveKit Data Tracks | 0 € | Inclus dans votre serveur LiveKit |
| **Traduction** | API Google GTX | 0 € | Données anonymisées transmises à l'API |

Cette implémentation est **robuste**, **scalable** (puisque chaque client fait son propre travail) et **totalement gratuite**.
