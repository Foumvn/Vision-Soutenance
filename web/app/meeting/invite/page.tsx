"use client";

import { useEffect, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { getUserMe, getRoomInfo, joinRoom } from "@/app/lib/api";

import { Suspense } from "react";

function JoinRoomContent() {
    const router = useRouter();
    const searchParams = useSearchParams();
    const roomName = searchParams.get("room");

    const [user, setUser] = useState<any>(null);
    const [roomInfo, setRoomInfo] = useState<any>(null);
    const [isLoading, setIsLoading] = useState(true);
    const [isJoining, setIsJoining] = useState(false);
    const [error, setError] = useState("");

    useEffect(() => {
        async function loadRoomInfo() {
            try {
                const token = localStorage.getItem("access_token");
                if (!token) {
                    router.push("/login");
                    return;
                }

                if (!roomName) {
                    setError("Nom de room manquant");
                    setIsLoading(false);
                    return;
                }

                const userData = await getUserMe(token);
                setUser(userData);

                const room = await getRoomInfo(roomName, token);
                setRoomInfo(room);
                setIsLoading(false);
            } catch (err: any) {
                console.error("Erreur:", err);
                setError(err.message || "Room non trouvée");
                setIsLoading(false);
            }
        }

        loadRoomInfo();
    }, [roomName, router]);

    const handleJoinRoom = async () => {
        try {
            setIsJoining(true);
            const token = localStorage.getItem("access_token");
            if (!token || !roomName) return;

            await joinRoom(roomName, token);
            router.push(`/meeting/room?room=${encodeURIComponent(roomName)}`);
        } catch (err: any) {
            console.error("Erreur:", err);
            alert(err.message || "Impossible de rejoindre la room");
            setIsJoining(false);
        }
    };

    if (isLoading) {
        return (
            <div className="min-h-screen bg-[#0a0a0c] flex items-center justify-center">
                <div className="flex flex-col items-center gap-4">
                    <div className="w-16 h-16 border-4 border-[#8b5cf6] border-t-transparent rounded-full animate-spin"></div>
                    <p className="text-white/60 text-sm">Chargement...</p>
                </div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="min-h-screen bg-[#0a0a0c] flex items-center justify-center p-8">
                <div className="bg-white/5 border border-white/10 rounded-2xl p-8 max-w-md text-center">
                    <div className="w-16 h-16 bg-red-500/10 rounded-full flex items-center justify-center mx-auto mb-4">
                        <span className="material-symbols-outlined text-red-500 text-3xl">
                            error
                        </span>
                    </div>
                    <h2 className="text-white text-xl font-bold mb-2">
                        Room non disponible
                    </h2>
                    <p className="text-white/60 mb-6">{error}</p>
                    <button
                        onClick={() => router.push("/dashboard")}
                        className="px-6 py-2 bg-[#8b5cf6] text-white rounded-lg hover:bg-[#7c3aed] transition-colors font-bold"
                    >
                        Retour au dashboard
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-[#0a0a0c] font-display text-white flex items-center justify-center p-8">
            <div className="bg-white/5 border border-white/10 rounded-2xl p-8 max-w-2xl w-full">
                {/* Header */}
                <div className="text-center mb-8">
                    <div className="size-20 bg-[#8b5cf6] rounded-2xl flex items-center justify-center mx-auto mb-4">
                        <span className="material-symbols-outlined text-white text-4xl">
                            videocam
                        </span>
                    </div>
                    <h1 className="text-3xl font-bold mb-2">Rejoindre la visioconférence</h1>
                    <p className="text-white/60">
                        Vous êtes invité à rejoindre une room de communication
                    </p>
                </div>

                {/* Room Info */}
                <div className="bg-black/40 border border-white/10 rounded-xl p-6 mb-6">
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <p className="text-white/60 text-sm mb-1">Nom de la room</p>
                            <p className="font-bold text-lg">{roomInfo?.room_name}</p>
                        </div>
                        <div>
                            <p className="text-white/60 text-sm mb-1">Type d'appel</p>
                            <div className="flex items-center gap-2">
                                <span className="material-symbols-outlined text-[#8b5cf6]">
                                    {roomInfo?.call_type === "video" ? "videocam" : "phone"}
                                </span>
                                <p className="font-bold capitalize">{roomInfo?.call_type}</p>
                            </div>
                        </div>
                        <div>
                            <p className="text-white/60 text-sm mb-1">Participants</p>
                            <div className="flex items-center gap-2">
                                <span className="material-symbols-outlined text-[#8b5cf6]">
                                    group
                                </span>
                                <p className="font-bold">{roomInfo?.participants?.length || 0}</p>
                            </div>
                        </div>
                        <div>
                            <p className="text-white/60 text-sm mb-1">Statut</p>
                            <div className="flex items-center gap-2">
                                <span
                                    className={`flex h-2 w-2 rounded-full ${roomInfo?.status === "active"
                                        ? "bg-green-500 animate-pulse"
                                        : "bg-yellow-500"
                                        }`}
                                ></span>
                                <p className="font-bold capitalize">{roomInfo?.status}</p>
                            </div>
                        </div>
                    </div>
                </div>

                {/* User Info */}
                {user && (
                    <div className="bg-[#8b5cf6]/10 border border-[#8b5cf6]/30 rounded-xl p-4 mb-6">
                        <p className="text-[#8b5cf6] text-sm font-bold mb-2">
                            Vous rejoindrez en tant que:
                        </p>
                        <div className="flex items-center gap-3">
                            <div className="size-12 bg-[#8b5cf6] rounded-full flex items-center justify-center font-bold text-lg">
                                {user.full_name?.charAt(0) || user.email?.charAt(0)}
                            </div>
                            <div>
                                <p className="font-bold">{user.full_name || user.email}</p>
                                <p className="text-sm text-white/60">{user.email}</p>
                            </div>
                        </div>
                    </div>
                )}

                {/* Action Buttons */}
                <div className="flex gap-4">
                    <button
                        onClick={() => router.push("/dashboard")}
                        className="flex-1 px-6 py-3 bg-white/5 border border-white/10 text-white rounded-lg hover:bg-white/10 transition-colors font-bold"
                    >
                        Annuler
                    </button>
                    <button
                        onClick={handleJoinRoom}
                        disabled={isJoining}
                        className="flex-1 px-6 py-3 bg-[#8b5cf6] text-white rounded-lg hover:bg-[#7c3aed] transition-colors font-bold flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed shadow-[0_0_20px_rgba(139,92,246,0.4)]"
                    >
                        {isJoining ? (
                            <>
                                <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                                Connexion...
                            </>
                        ) : (
                            <>
                                <span className="material-symbols-outlined">login</span>
                                Rejoindre maintenant
                            </>
                        )}
                    </button>
                </div>
            </div>
        </div>
    );
}

export default function JoinRoomPage() {
    return (
        <Suspense fallback={
            <div className="min-h-screen bg-[#0a0a0c] flex items-center justify-center">
                <div className="flex flex-col items-center gap-4">
                    <div className="w-16 h-16 border-4 border-[#8b5cf6] border-t-transparent rounded-full animate-spin"></div>
                    <p className="text-white/60 text-sm">Chargement...</p>
                </div>
            </div>
        }>
            <JoinRoomContent />
        </Suspense>
    );
}
