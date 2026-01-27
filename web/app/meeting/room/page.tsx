"use client";

import { useEffect, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import {
    LiveKitRoom,
    VideoConference,
    RoomAudioRenderer,
    ControlBar,
    GridLayout,
    ParticipantTile,
    useTracks,
} from "@livekit/components-react";
import "@livekit/components-styles";
import { Track } from "livekit-client";
import { getLiveKitToken, leaveRoom, getUserMe } from "@/app/lib/api";

import { Suspense } from "react";

function LiveKitRoomContent() {
    const router = useRouter();
    const searchParams = useSearchParams();

    const roomName = searchParams.get("room");
    const [token, setToken] = useState("");
    const [livekitUrl, setLivekitUrl] = useState("");
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState("");
    const [user, setUser] = useState<any>(null);

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

                // Récupérer les infos de l'utilisateur
                const userData = await getUserMe(accessToken);
                setUser(userData);

                // Obtenir l'ID utilisateur (MongoDB peut retourner _id ou id)
                const userId = userData.id || userData._id;
                if (!userId) {
                    throw new Error("Impossible de récupérer l'ID utilisateur");
                }

                // Obtenir le token LiveKit
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
        <div className="h-screen bg-[#0a0a0c]">
            <LiveKitRoom
                video={true}
                audio={true}
                token={token}
                serverUrl={livekitUrl}
                connect={true}
                onDisconnected={handleDisconnect}
                data-lk-theme="default"
                className="h-full"
                style={{ height: "100vh" }}
            >
                <div className="flex flex-col h-full">
                    {/* Header */}
                    <div className="bg-black/40 backdrop-blur-md border-b border-white/10 px-6 py-3 flex items-center justify-between">
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
                        <button
                            onClick={handleDisconnect}
                            className="px-4 py-2 bg-red-500/10 border border-red-500/30 text-red-500 hover:bg-red-500 hover:text-white transition-colors rounded-lg font-bold text-sm"
                        >
                            Quitter
                        </button>
                    </div>

                    {/* Video Conference Area */}
                    <div className="flex-1 relative">
                        <VideoConference />
                    </div>

                    {/* Audio Renderer */}
                    <RoomAudioRenderer />
                </div>
            </LiveKitRoom>
        </div>
    );
}

export default function LiveKitRoomPage() {
    return (
        <Suspense fallback={
            <div className="min-h-screen bg-[#0a0a0c] flex items-center justify-center">
                <div className="flex flex-col items-center gap-4">
                    <div className="w-16 h-16 border-4 border-[#8b5cf6] border-t-transparent rounded-full animate-spin"></div>
                    <p className="text-white/60 text-sm">Connexion à la room...</p>
                </div>
            </div>
        }>
            <LiveKitRoomContent />
        </Suspense>
    );
}
