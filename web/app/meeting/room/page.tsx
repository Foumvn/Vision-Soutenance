"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import {
    LiveKitRoom,
    VideoConference,
    RoomAudioRenderer,
    ControlBar,
    GridLayout,
    ParticipantTile,
    useTracks,
    useRoomContext,
} from "@livekit/components-react";
import "@livekit/components-styles";
import { Track } from "livekit-client";
import { getLiveKitToken, leaveRoom, getUserMe } from "@/app/lib/api";
import { TranslationManager, Transcript } from "@/app/lib/TranslationManager";

import { Suspense } from "react";

function RoomControls({ onToggleTranslation, isTranslationEnabled }: { onToggleTranslation: () => void, isTranslationEnabled: boolean }) {
    return (
        <div className="flex items-center gap-2">
            <button
                onClick={onToggleTranslation}
                className={`px-4 py-2 rounded-lg font-bold text-sm transition-colors flex items-center gap-2 ${isTranslationEnabled
                    ? "bg-[#8b5cf6] text-white"
                    : "bg-white/5 border border-white/10 text-white/60 hover:text-white"
                    }`}
            >
                <span className="material-symbols-outlined text-sm">translate</span>
                {isTranslationEnabled ? "Traduction On" : "Traduire"}
            </button>
        </div>
    );
}

function TranscriptPanel({ transcripts, localParticipantSid }: { transcripts: Transcript[], localParticipantSid?: string }) {
    const sortedTranscripts = [...transcripts].sort((a, b) => b.timestamp - a.timestamp);

    return (
        <div className="flex flex-col gap-4 p-4 h-full overflow-y-auto">
            {sortedTranscripts.length === 0 ? (
                <div className="flex flex-col gap-1 items-center justify-center h-full text-white/30 text-center">
                    <span className="material-symbols-outlined text-4xl mb-2">graphic_eq</span>
                    <p className="text-xs">En attente de parole...</p>
                </div>
            ) : (
                sortedTranscripts.map((t) => {
                    const isMe = t.participantSid === localParticipantSid;
                    return (
                        <div key={t.id} className={`flex flex-col gap-1 ${isMe ? "items-end" : "items-start"} ${t.isFinal ? "opacity-100" : "opacity-70"}`}>
                            <div className="flex items-center gap-2 mb-1">
                                {!isMe && <span className="text-[10px] font-bold text-[#8b5cf6] uppercase">{t.participantName}</span>}
                                <span className="text-[8px] text-white/30">{new Date(t.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                                {isMe && <span className="text-[10px] font-bold text-[#8b5cf6] uppercase">Moi</span>}
                            </div>
                            <div className={`max-w-[85%] px-3 py-2 rounded-2xl text-sm ${isMe
                                ? "bg-[#8b5cf6] text-white rounded-tr-none"
                                : "bg-white/10 text-white/90 rounded-tl-none border border-white/5"
                                }`}>
                                <p>{t.text}</p>
                            </div>
                            {t.translation && (
                                <div className={`flex items-center gap-2 mt-1 ${isMe ? "flex-row-reverse" : "flex-row"}`}>
                                    <span className="material-symbols-outlined text-[10px] text-[#8b5cf6]">translate</span>
                                    <p className="text-sm text-[#8b5cf6] italic">{t.translation}</p>
                                </div>
                            )}
                        </div>
                    );
                })
            )}
        </div>
    );
}

function LiveKitRoomContent() {
    const router = useRouter();
    const searchParams = useSearchParams();

    const roomName = searchParams.get("room");
    const [token, setToken] = useState("");
    const [livekitUrl, setLivekitUrl] = useState("");
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState("");
    const [user, setUser] = useState<any>(null);
    const [transcripts, setTranscripts] = useState<Transcript[]>([]);
    const [isTranslationEnabled, setIsTranslationEnabled] = useState(false);
    const [activeTab, setActiveTab] = useState<"transcript" | "chat">("transcript");

    useEffect(() => {
        async function initializeRoom() {
            try {
                const accessToken = localStorage.getItem("access_token");

                if (!accessToken) {
                    router.push("/login");
                    return;
                }

                if (!roomName) {
                    setError("Nom de room manquant");
                    setIsLoading(false);
                    return;
                }

                const userData = await getUserMe(accessToken);
                setUser(userData);

                const userId = userData.id || userData._id;
                if (!userId) {
                    throw new Error("Impossible de récupérer l'ID utilisateur");
                }

                const livekitData = await getLiveKitToken(
                    roomName,
                    userId,
                    userData.full_name || userData.email,
                    accessToken
                );

                setToken(livekitData.token);
                setLivekitUrl(livekitData.url);
                setIsLoading(false);
            } catch (err: any) {
                console.error("Erreur lors de l'initialisation:", err);
                setError(err.message || "Erreur lors de la connexion à la room");
                setIsLoading(false);
            }
        }

        initializeRoom();
    }, [roomName, router]);

    const handleDisconnect = async () => {
        try {
            const accessToken = localStorage.getItem("access_token");
            if (accessToken && roomName) {
                await leaveRoom(roomName, accessToken);
            }
        } catch (err) {
            console.error("Erreur lors de la déconnexion:", err);
        }
        router.push("/dashboard");
    };

    if (isLoading) {
        return (
            <div className="min-h-screen bg-[#0a0a0c] flex items-center justify-center">
                <div className="flex flex-col items-center gap-4">
                    <div className="w-16 h-16 border-4 border-[#8b5cf6] border-t-transparent rounded-full animate-spin"></div>
                    <p className="text-white/60 text-sm">Connexion à la room...</p>
                </div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="min-h-screen bg-[#0a0a0c] flex items-center justify-center">
                <div className="bg-white/5 border border-white/10 rounded-2xl p-8 max-w-md text-center">
                    <div className="w-16 h-16 bg-red-500/10 rounded-full flex items-center justify-center mx-auto mb-4">
                        <span className="material-symbols-outlined text-red-500 text-3xl">error</span>
                    </div>
                    <h2 className="text-white text-xl font-bold mb-2">Erreur de connexion</h2>
                    <p className="text-white/60 mb-6">{error}</p>
                    <button
                        onClick={() => router.push("/dashboard")}
                        className="px-6 py-2 bg-[#8b5cf6] text-white rounded-lg hover:bg-[#7c3aed] transition-colors"
                    >
                        Retour au dashboard
                    </button>
                </div>
            </div>
        );
    }

    if (!token || !livekitUrl) {
        return null;
    }

    return (
        <div className="h-screen bg-[#0a0a0c] flex flex-col">
            <LiveKitRoom
                video={true}
                audio={true}
                token={token}
                serverUrl={livekitUrl}
                connect={true}
                onDisconnected={handleDisconnect}
                data-lk-theme="default"
                className="flex-1 flex flex-col overflow-hidden"
            >
                <RoomContent
                    roomName={roomName}
                    handleDisconnect={handleDisconnect}
                    transcripts={transcripts}
                    setTranscripts={setTranscripts}
                    isTranslationEnabled={isTranslationEnabled}
                    setIsTranslationEnabled={setIsTranslationEnabled}
                    activeTab={activeTab}
                    setActiveTab={setActiveTab}
                />
            </LiveKitRoom>
        </div>
    );
}

function RoomContent({
    roomName,
    handleDisconnect,
    transcripts,
    setTranscripts,
    isTranslationEnabled,
    setIsTranslationEnabled,
    activeTab,
    setActiveTab
}: any) {
    const room = useRoomContext();
    const translationManager = useMemo(() => {
        if (!room) return null;
        return new TranslationManager(room, (newTranscripts) => {
            setTranscripts(newTranscripts);
        });
    }, [room]);

    useEffect(() => {
        if (!translationManager) return;

        if (isTranslationEnabled) {
            translationManager.start();
        } else {
            translationManager.stop();
        }
    }, [isTranslationEnabled, translationManager]);

    return (
        <>
            {/* Header */}
            <div className="bg-black/40 backdrop-blur-md border-b border-white/10 px-6 py-3 flex items-center justify-between z-50">
                <div className="flex items-center gap-3">
                    <div className="size-8 bg-[#8b5cf6] rounded-lg flex items-center justify-center">
                        <span className="material-symbols-outlined text-white text-xl">videocam</span>
                    </div>
                    <div>
                        <h1 className="text-white font-bold">{roomName}</h1>
                        <div className="flex items-center gap-2">
                            <span className="flex h-2 w-2 rounded-full bg-[#8b5cf6] animate-pulse"></span>
                            <span className="text-xs text-white/60">Live</span>
                        </div>
                    </div>
                </div>

                <div className="flex items-center gap-4">
                    <RoomControls
                        isTranslationEnabled={isTranslationEnabled}
                        onToggleTranslation={() => setIsTranslationEnabled(!isTranslationEnabled)}
                    />
                    <div className="h-8 w-px bg-white/10 mx-2"></div>
                    <button
                        onClick={handleDisconnect}
                        className="px-4 py-2 bg-red-500/10 border border-red-500/30 text-red-500 hover:bg-red-500 hover:text-white transition-colors rounded-lg font-bold text-sm"
                    >
                        Quitter
                    </button>
                </div>
            </div>

            {/* Main Content Area */}
            <div className="flex-1 flex overflow-hidden p-4 gap-4">
                {/* Video Conference Area */}
                <div className="flex-[3] relative rounded-xl overflow-hidden border border-white/5 bg-black/20">
                    <VideoConference />
                    <RoomAudioRenderer />
                </div>

                {/* Sidebar (Transcript/Chat) */}
                <div className="flex-1 min-w-[340px] flex flex-col gap-4 max-h-full">
                    <div className="backdrop-blur-xl bg-white/5 rounded-xl border border-white/10 flex flex-col flex-1 overflow-hidden">
                        <div className="flex border-b border-white/10">
                            <button
                                onClick={() => setActiveTab("transcript")}
                                className={`flex-1 py-3 text-xs font-bold transition-all ${activeTab === "transcript"
                                    ? "border-b-2 border-[#8b5cf6] bg-[#8b5cf6]/10 text-[#8b5cf6]"
                                    : "text-white/40 hover:text-white/60"
                                    }`}
                            >
                                TRANSCRIPTION LIVE
                            </button>
                            <button
                                onClick={() => setActiveTab("chat")}
                                className={`flex-1 py-3 text-xs font-bold transition-all ${activeTab === "chat"
                                    ? "border-b-2 border-[#8b5cf6] bg-[#8b5cf6]/10 text-[#8b5cf6]"
                                    : "text-white/40 hover:text-white/60"
                                    }`}
                            >
                                CHAT
                            </button>
                        </div>

                        <div className="flex-1 overflow-hidden">
                            {activeTab === "transcript" ? (
                                <TranscriptPanel
                                    transcripts={transcripts}
                                    localParticipantSid={room?.localParticipant?.sid}
                                />
                            ) : (
                                <div className="p-4 text-center text-white/30 text-xs mt-10">
                                    <span className="material-symbols-outlined text-4xl mb-2">forum</span>
                                    <p>Le chat n'est pas encore disponible dans cette vue.</p>
                                </div>
                            )}
                        </div>

                        <div className="bg-[#8b5cf6]/10 border-t border-[#8b5cf6]/30 p-4">
                            <div className="flex items-center gap-2 mb-3">
                                <span className="material-symbols-outlined text-[#8b5cf6] text-lg">psychology</span>
                                <h3 className="text-xs font-bold uppercase tracking-wider text-[#8b5cf6]">IA Insights</h3>
                            </div>
                            <div className="relative">
                                <input
                                    className="w-full bg-black/40 border border-white/10 rounded-lg py-2 pl-3 pr-10 text-xs focus:ring-1 focus:ring-[#8b5cf6] outline-none text-white"
                                    placeholder="Demandez à l'IA..."
                                    type="text"
                                />
                                <button className="absolute right-2 top-1/2 -translate-y-1/2 text-[#8b5cf6]">
                                    <span className="material-symbols-outlined text-sm">send</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}

export default function LiveKitRoomPage() {
    return (
        <Suspense fallback={
            <div className="min-h-screen bg-[#0a0a0c] flex items-center justify-center">
                <div className="flex flex-col items-center gap-4">
                    <div className="w-16 h-16 border-4 border-[#8b5cf6] border-t-transparent rounded-full animate-spin"></div>
                    <p className="text-white/60 text-sm">Chargement de la réunion...</p>
                </div>
            </div>
        }>
            <LiveKitRoomContent />
        </Suspense>
    );
}

