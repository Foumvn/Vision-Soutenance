"use client";

import { Room, LocalParticipant, RemoteParticipant, DataPacket_Kind } from "livekit-client";

export interface Transcript {
    id: string;
    participantSid: string;
    participantName: string;
    text: string;
    translation?: string;
    timestamp: number;
    isFinal: boolean;
}

export class TranslationManager {
    private room: Room;
    private recognition: any = null;
    private isListening: boolean = false;
    private targetLanguage: string = "en";
    private sourceLanguage: string = "fr-FR";
    private onTranscriptUpdate: (transcripts: Transcript[]) => void;
    private transcripts: Transcript[] = [];

    constructor(room: Room, onTranscriptUpdate: (transcripts: Transcript[]) => void) {
        this.room = room;
        this.onTranscriptUpdate = onTranscriptUpdate;

        if (typeof window !== "undefined") {
            const SpeechRecognition = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
            if (SpeechRecognition) {
                this.recognition = new SpeechRecognition();
                this.recognition.continuous = true;
                this.recognition.interimResults = true;
                this.recognition.lang = this.sourceLanguage;

                this.recognition.onresult = (event: any) => {
                    this.handleSpeechResult(event);
                };

                this.recognition.onerror = (event: any) => {
                    console.error("Speech Recognition Error:", event.error);
                };
            }
        }

        // Écouter les données LiveKit pour les transcriptions des autres
        this.room.on("dataReceived", (payload, participant) => {
            this.handleIncomingData(payload, participant);
        });
    }

    setLanguages(source: string, target: string) {
        this.sourceLanguage = source;
        this.targetLanguage = target;
        if (this.recognition) {
            this.recognition.lang = source;
        }
    }

    async start() {
        if (this.recognition && !this.isListening) {
            try {
                this.recognition.start();
                this.isListening = true;
            } catch (e) {
                console.error("Failed to start recognition:", e);
            }
        }
    }

    stop() {
        if (this.recognition && this.isListening) {
            this.recognition.stop();
            this.isListening = false;
        }
    }

    private handleSpeechResult(event: any) {
        const results = event.results;
        const lastResult = results[results.length - 1];
        const text = lastResult[0].transcript;
        const isFinal = lastResult.isFinal;

        const transcript: Transcript = {
            id: `local-${Date.now()}`,
            participantSid: this.room.localParticipant.sid,
            participantName: this.room.localParticipant.name || this.room.localParticipant.identity,
            text: text,
            timestamp: Date.now(),
            isFinal: isFinal,
        };

        // Envoyer aux autres participants
        const encoder = new TextEncoder();
        const data = encoder.encode(JSON.stringify({
            type: "transcript",
            ...transcript
        }));

        this.room.localParticipant.publishData(data, { reliable: true });

        this.updateTranscripts(transcript);
    }

    private async handleIncomingData(payload: Uint8Array, participant?: RemoteParticipant) {
        const decoder = new TextDecoder();
        try {
            const data = JSON.parse(decoder.decode(payload));
            if (data.type === "transcript") {
                const transcript = data as Transcript;

                // Utiliser les informations réelles du participant LiveKit pour plus de précision
                if (participant) {
                    transcript.participantName = participant.name || participant.identity;
                    transcript.participantSid = participant.sid;
                }

                // Traduire si nécessaire
                if (this.targetLanguage && transcript.text) {
                    transcript.translation = await this.translateText(transcript.text, "auto", this.targetLanguage);
                }

                this.updateTranscripts(transcript);
            }
        } catch (e) {
            // Ignorer les données non transcript
        }
    }

    private updateTranscripts(newTranscript: Transcript) {
        // Si c'est un résultat intermédiaire, on met à jour le dernier
        // Si c'est final ou un nouveau participant, on ajoute
        const index = this.transcripts.findIndex(t => t.participantSid === newTranscript.participantSid && !t.isFinal);

        if (index !== -1) {
            this.transcripts[index] = newTranscript;
        } else {
            this.transcripts.push(newTranscript);
        }

        // Garder seulement les 50 derniers pour la performance
        if (this.transcripts.length > 50) {
            this.transcripts.shift();
        }

        this.onTranscriptUpdate([...this.transcripts]);
    }

    private async translateText(text: string, source: string, target: string): Promise<string> {
        try {
            // Utilisation d'une API publique gratuite (Google Translate GTX)
            const url = `https://translate.googleapis.com/translate_a/single?client=gtx&sl=${source}&tl=${target}&dt=t&q=${encodeURIComponent(text)}`;
            const response = await fetch(url);
            const data = await response.json();
            return data[0][0][0];
        } catch (e) {
            console.error("Translation error:", e);
            return text;
        }
    }
}
