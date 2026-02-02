"use client";

import { useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { getUserMe, fetchContacts, createRoom, searchUser } from "@/app/lib/api";

export default function PreJoinPage() {
    const router = useRouter();
    const [user, setUser] = useState<any>(null);
    const [contacts, setContacts] = useState<any[]>([]);
    const [selectedContacts, setSelectedContacts] = useState<string[]>([]);
    const [roomName, setRoomName] = useState("");
    const [callType, setCallType] = useState<"audio" | "video">("video");
    const [isLoading, setIsLoading] = useState(true);
    const [isCreating, setIsCreating] = useState(false);
    const [searchResults, setSearchResults] = useState<any[]>([]);
    const [isSearching, setIsSearching] = useState(false);
    const searchTimeout = useRef<NodeJS.Timeout | null>(null);

    useEffect(() => {
        async function loadData() {
            try {
                const token = localStorage.getItem("access_token");
                if (!token) {
                    router.push("/login");
                    return;
                }

                const userData = await getUserMe(token);
                setUser(userData);

                const contactsData = await fetchContacts(token);
                setContacts(contactsData);

                // Générer un nom de room par défaut
                setRoomName(`room-${Date.now()}`);
                setIsLoading(false);
            } catch (err) {
                console.error("Erreur:", err);
                router.push("/login");
            }
        }

        loadData();
    }, [router]);

    const toggleContact = (contactId: string) => {
        setSelectedContacts((prev) =>
            prev.includes(contactId)
                ? prev.filter((id) => id !== contactId)
                : [...prev, contactId]
        );
    };

    const handleSearchChange = (query: string) => {
        if (searchTimeout.current) clearTimeout(searchTimeout.current);

        if (!query || query.length < 2) {
            setSearchResults([]);
            setIsSearching(false);
            return;
        }

        setIsSearching(true);
        searchTimeout.current = setTimeout(async () => {
            try {
                const token = localStorage.getItem("access_token");
                const results = await searchUser(query, token!);
                setSearchResults(results);
            } catch (err) {
                console.error("Erreur recherche:", err);
            } finally {
                setIsSearching(false);
            }
        }, 300); // 300ms debounce
    };

    const handleCreateRoom = async () => {
        try {
            setIsCreating(true);
            const token = localStorage.getItem("access_token");
            if (!token) {
                router.push("/login");
                return;
            }

            // Ajouter l'utilisateur actuel aux participants
            const currentUserId = user.id || user._id;
            if (!currentUserId) {
                console.error("User ID not found in:", user);
                throw new Error("ID utilisateur introuvable. Veuillez vous reconnecter.");
            }
            const participants = [currentUserId, ...selectedContacts].filter(id => !!id && typeof id === 'string');

            // Créer la room
            await createRoom(roomName, participants, callType, token);

            // Rediriger vers la room
            router.push(`/meeting/room?room=${encodeURIComponent(roomName)}`);
        } catch (err: any) {
            console.error("Erreur création room:", err);
            alert(err.message || "Erreur lors de la création de la room");
            setIsCreating(false);
        }
    };

    const getInitials = (name?: string) => {
        if (!name) return "U";
        return name
            .split(" ")
            .map((n) => n[0])
            .join("")
            .toUpperCase()
            .substring(0, 2);
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

    return (
        <div className="min-h-screen bg-[#0a0a0c] font-display text-white p-8">
            <div className="max-w-4xl mx-auto">
                {/* Header */}
                <div className="mb-8">
                    <div className="flex items-center gap-3 mb-2">
                        <div className="size-10 bg-[#8b5cf6] rounded-lg flex items-center justify-center">
                            <span className="material-symbols-outlined text-white text-2xl">
                                video_call
                            </span>
                        </div>
                        <h1 className="text-3xl font-bold">Nouvelle Visioconférence</h1>
                    </div>
                    <p className="text-white/60">
                        Configurez votre appel et invitez des participants
                    </p>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    {/* Configuration Panel */}
                    <div className="bg-white/5 border border-white/10 rounded-2xl p-6">
                        <h2 className="text-xl font-bold mb-6 flex items-center gap-2">
                            <span className="material-symbols-outlined text-[#8b5cf6]">
                                settings
                            </span>
                            Configuration
                        </h2>

                        {/* Room Name */}
                        <div className="mb-6">
                            <label className="block text-sm font-bold mb-2 text-white/80">
                                Nom de la Room
                            </label>
                            <input
                                type="text"
                                value={roomName}
                                onChange={(e) => setRoomName(e.target.value)}
                                className="w-full bg-black/40 border border-white/10 rounded-lg px-4 py-3 text-white focus:ring-2 focus:ring-[#8b5cf6] outline-none"
                                placeholder="Ex: reunion-equipe"
                            />
                        </div>

                        {/* Call Type */}
                        <div className="mb-6">
                            <label className="block text-sm font-bold mb-3 text-white/80">
                                Type d'appel
                            </label>
                            <div className="grid grid-cols-2 gap-3">
                                <button
                                    onClick={() => setCallType("video")}
                                    className={`flex flex-col items-center gap-2 p-4 rounded-xl border-2 transition-all ${callType === "video"
                                        ? "bg-[#8b5cf6]/20 border-[#8b5cf6]"
                                        : "bg-white/5 border-white/10 hover:border-white/20"
                                        }`}
                                >
                                    <span className="material-symbols-outlined text-2xl">
                                        videocam
                                    </span>
                                    <span className="text-sm font-bold">Vidéo</span>
                                </button>
                                <button
                                    onClick={() => setCallType("audio")}
                                    className={`flex flex-col items-center gap-2 p-4 rounded-xl border-2 transition-all ${callType === "audio"
                                        ? "bg-[#8b5cf6]/20 border-[#8b5cf6]"
                                        : "bg-white/5 border-white/10 hover:border-white/20"
                                        }`}
                                >
                                    <span className="material-symbols-outlined text-2xl">
                                        phone
                                    </span>
                                    <span className="text-sm font-bold">Audio</span>
                                </button>
                            </div>
                        </div>

                        {/* Summary */}
                        <div className="bg-[#8b5cf6]/10 border border-[#8b5cf6]/30 rounded-xl p-4">
                            <div className="flex items-center gap-2 mb-3">
                                <span className="material-symbols-outlined text-[#8b5cf6] text-lg">
                                    info
                                </span>
                                <h3 className="text-sm font-bold text-[#8b5cf6]">Résumé</h3>
                            </div>
                            <div className="space-y-2 text-sm">
                                <div className="flex justify-between">
                                    <span className="text-white/60">Participants:</span>
                                    <span className="font-bold">
                                        {selectedContacts.length + 1}
                                    </span>
                                </div>
                                <div className="flex justify-between">
                                    <span className="text-white/60">Type:</span>
                                    <span className="font-bold capitalize">{callType}</span>
                                </div>
                            </div>
                        </div>
                    </div>

// Participants Panel
                    <div className="bg-white/5 border border-white/10 rounded-2xl p-6 flex flex-col">
                        <h2 className="text-xl font-bold mb-6 flex items-center gap-2">
                            <span className="material-symbols-outlined text-[#8b5cf6]">
                                group
                            </span>
                            Participants ({selectedContacts.length} sélectionné
                            {selectedContacts.length > 1 ? "s" : ""})
                        </h2>

                        {/* Search Bar for System Users - Dynamic AJAX Style */}
                        <div className="mb-6 relative">
                            <label className="block text-sm font-bold mb-2 text-white/80">
                                Rechercher des participants
                            </label>
                            <div className="relative">
                                <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-white/40 text-sm">
                                    {isSearching ? "sync" : "search"}
                                </span>
                                <input
                                    type="text"
                                    placeholder="Nom ou email de l'utilisateur..."
                                    className={`w-full bg-black/40 border border-white/10 rounded-lg py-3 pl-10 pr-4 text-sm focus:ring-1 focus:ring-[#8b5cf6] outline-none transition-all ${isSearching ? "animate-pulse" : ""}`}
                                    onChange={(e) => handleSearchChange(e.target.value)}
                                />
                                {isSearching && (
                                    <div className="absolute right-3 top-1/2 -translate-y-1/2 animate-spin">
                                        <span className="material-symbols-outlined text-[#8b5cf6] text-sm">progress_activity</span>
                                    </div>
                                )}
                            </div>

                            {/* Dropdown Suggestions */}
                            {searchResults.length > 0 && (
                                <div className="absolute z-50 mt-2 w-full bg-[#121216] border border-white/10 rounded-xl shadow-2xl overflow-hidden backdrop-blur-xl">
                                    <div className="py-2">
                                        <p className="px-4 py-1 text-[10px] font-bold text-[#8b5cf6] uppercase tracking-wider">Résultats suggérés</p>
                                        {searchResults.map((foundUser: any) => {
                                            const fId = foundUser.id || foundUser._id;
                                            const isSelected = selectedContacts.includes(fId);
                                            return (
                                                <button
                                                    key={fId}
                                                    onClick={() => {
                                                        // Ajouter aux contacts affichés si absent
                                                        if (!contacts.find(c => (c.id || c._id) === fId)) {
                                                            setContacts(prev => [foundUser, ...prev]);
                                                        }
                                                        // Basculer la sélection
                                                        toggleContact(fId);
                                                        setSearchResults([]);
                                                    }}
                                                    className="w-full px-4 py-3 flex items-center justify-between hover:bg-white/5 transition-colors group"
                                                >
                                                    <div className="flex items-center gap-3">
                                                        <div className="size-8 bg-[#8b5cf6]/20 border border-[#8b5cf6]/30 text-[#8b5cf6] rounded-full flex items-center justify-center text-xs font-bold">
                                                            {getInitials(foundUser.full_name)}
                                                        </div>
                                                        <div className="text-left">
                                                            <p className="text-sm font-bold text-white group-hover:text-[#8b5cf6] transition-colors">{foundUser.full_name}</p>
                                                            <p className="text-[10px] text-white/40">{foundUser.email}</p>
                                                        </div>
                                                    </div>
                                                    {isSelected ? (
                                                        <span className="material-symbols-outlined text-[#8b5cf6] text-lg">check_circle</span>
                                                    ) : (
                                                        <span className="material-symbols-outlined text-white/20 group-hover:text-white/40 text-lg">add_circle</span>
                                                    )}
                                                </button>
                                            );
                                        })}
                                    </div>
                                </div>
                            )}
                        </div>

                        {/* Current User */}
                        <div className="mb-4 p-3 bg-[#8b5cf6]/10 border border-[#8b5cf6]/30 rounded-lg flex items-center gap-3">
                            <div className="size-10 bg-[#8b5cf6] rounded-full flex items-center justify-center font-bold">
                                {getInitials(user?.full_name)}
                            </div>
                            <div className="flex-1">
                                <p className="font-bold">{user?.full_name || user?.email}</p>
                                <p className="text-xs text-white/60">Vous (Hôte)</p>
                            </div>
                            <span className="material-symbols-outlined text-[#8b5cf6]">
                                verified
                            </span>
                        </div>

                        {/* Contacts & Search Results List */}
                        <div className="space-y-2 max-h-80 overflow-y-auto flex-1">
                            {contacts.length === 0 ? (
                                <div className="text-center py-8 text-white/40">
                                    <span className="material-symbols-outlined text-4xl mb-2 block">
                                        people_outline
                                    </span>
                                    <p className="text-sm">Aucun contact disponible</p>
                                </div>
                            ) : (
                                contacts.map((contact) => {
                                    const cId = contact.id || contact._id;
                                    return (
                                        <button
                                            key={cId}
                                            onClick={() => toggleContact(cId)}
                                            className={`w-full p-3 rounded-lg border transition-all flex items-center gap-3 ${selectedContacts.includes(cId)
                                                ? "bg-[#8b5cf6]/10 border-[#8b5cf6]"
                                                : "bg-white/5 border-white/10 hover:border-white/20"
                                                }`}
                                        >
                                            <div
                                                className={`size-10 rounded-full flex items-center justify-center font-bold ${selectedContacts.includes(cId)
                                                    ? "bg-[#8b5cf6]"
                                                    : "bg-white/10"
                                                    }`}
                                            >
                                                {getInitials(contact.full_name)}
                                            </div>
                                            <div className="flex-1 text-left">
                                                <p className="font-bold">{contact.full_name}</p>
                                                <p className="text-xs text-white/60">{contact.email}</p>
                                            </div>
                                            {selectedContacts.includes(cId) && (
                                                <span className="material-symbols-outlined text-[#8b5cf6]">
                                                    check_circle
                                                </span>
                                            )}
                                        </button>
                                    );
                                })
                            )}
                        </div>
                    </div>
                </div>

                {/* Action Buttons */}
                <div className="mt-8 flex gap-4 justify-end">
                    <button
                        onClick={() => router.push("/dashboard")}
                        className="px-6 py-3 bg-white/5 border border-white/10 text-white rounded-lg hover:bg-white/10 transition-colors font-bold"
                    >
                        Annuler
                    </button>
                    <button
                        onClick={handleCreateRoom}
                        disabled={isCreating || !roomName.trim()}
                        className="px-8 py-3 bg-[#8b5cf6] text-white rounded-lg hover:bg-[#7c3aed] transition-colors font-bold flex items-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed shadow-[0_0_20px_rgba(139,92,246,0.4)]"
                    >
                        {isCreating ? (
                            <>
                                <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                                Création...
                            </>
                        ) : (
                            <>
                                <span className="material-symbols-outlined">videocam</span>
                                Démarrer l'appel
                            </>
                        )}
                    </button>
                </div>
            </div>
        </div>
    );
}
