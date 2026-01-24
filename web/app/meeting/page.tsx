"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { getUserMe, fetchContacts } from "@/app/lib/api";

export default function LiveMeetingPage() {
    const [timeLeft, setTimeLeft] = useState("00:00:00");
    const [user, setUser] = useState<any>(null);
    const [participants, setParticipants] = useState<any[]>([]);

    useEffect(() => {
        const token = localStorage.getItem("access_token");
        if (token) {
            getUserMe(token).then(setUser).catch(console.error);
            // Simulate that contacts are the participants for this demo
            fetchContacts(token).then((contacts) => {
                setParticipants(contacts.slice(0, 4));
            }).catch(console.error);
        }

        const timer = setInterval(() => {
            const now = new Date();
            setTimeLeft(now.toLocaleTimeString());
        }, 1000);
        return () => clearInterval(timer);
    }, []);

    const getInitials = (name?: string) => {
        if (!name) return "U";
        return name.split(" ").map(n => n[0]).join("").toUpperCase().substring(0, 2);
    };

    return (
        <div className="bg-[#0a0a0c] font-display text-white overflow-hidden h-screen flex flex-col">
            {/* Header */}
            <header className="flex items-center justify-between px-6 py-3 border-b border-white/10 backdrop-blur-md z-50">
                <div className="flex items-center gap-4">
                    <div className="size-8 bg-[#8b5cf6] rounded-lg flex items-center justify-center">
                        <span className="material-symbols-outlined text-white text-xl">rocket_launch</span>
                    </div>
                    <div>
                        <h1 className="text-white text-lg font-bold leading-tight tracking-tight">Quarterly Technical Review</h1>
                        <div className="flex items-center gap-2">
                            <span className="flex h-2 w-2 rounded-full bg-[#8b5cf6] animate-pulse"></span>
                            <span className="text-xs text-white/60 font-medium">Live Session</span>
                        </div>
                    </div>
                </div>
                <div className="flex items-center gap-4">
                    <div className="flex items-center gap-2 bg-white/5 px-3 py-1.5 rounded-lg border border-white/10">
                        <span className="material-symbols-outlined text-[#8b5cf6] text-sm">schedule</span>
                        <span className="text-sm font-bold tracking-wider">{timeLeft}</span>
                    </div>
                    <div className="flex items-center gap-2 bg-white/5 px-3 py-1.5 rounded-lg border border-white/10">
                        <span className="material-symbols-outlined text-white/70 text-sm">group</span>
                        <span className="text-sm font-bold">{participants.length + 1}</span>
                    </div>
                    <div className="h-8 w-px bg-white/10 mx-2"></div>
                    {user && (
                        <div className="flex items-center gap-3">
                            <div className="text-right">
                                <p className="text-xs font-bold text-white">{user.full_name}</p>
                                <p className="text-[10px] text-white/50">Host (FR)</p>
                            </div>
                            <div className="bg-primary rounded-full size-10 flex items-center justify-center ring-2 ring-[#8b5cf6]/50 font-bold text-lg">
                                {getInitials(user.full_name)}
                            </div>
                        </div>
                    )}
                </div>
            </header>

            {/* Main Content */}
            <main className="flex-1 flex overflow-hidden relative p-4 gap-4">
                <div className="flex-[3] flex flex-col gap-4">
                    <div className="relative flex-1 bg-black/40 rounded-xl overflow-hidden border border-white/5 group">
                        <div className="absolute top-4 left-4 z-10 bg-black/60 backdrop-blur-md px-3 py-1.5 rounded-lg border border-white/10 flex items-center gap-2">
                            <span className="material-symbols-outlined text-[#8b5cf6] text-sm">present_to_all</span>
                            <span className="text-xs font-bold text-white">System Architecture.pdf</span>
                        </div>
                        <div className="w-full h-full bg-cover bg-center flex items-center justify-center" style={{ backgroundImage: "linear-gradient(45deg, rgba(0,0,0,0.8), transparent), url('https://picsum.photos/seed/arch/1200/800')" }}>
                            <div className="w-4/5 h-3/5 border-2 border-[#8b5cf6]/20 rounded-lg flex items-center justify-center backdrop-blur-lg">
                                <span className="material-symbols-outlined text-6xl text-[#8b5cf6]/40">account_tree</span>
                            </div>
                        </div>
                    </div>

                    {/* Bottom strip of participants */}
                    <div className="grid grid-cols-5 gap-3 h-40">
                        {user && (
                            <div className="relative rounded-lg overflow-hidden border-2 border-[#8b5cf6] shadow-[0_0_20px_rgba(139,92,246,0.4)] bg-zinc-900">
                                <div className="absolute inset-0 bg-zinc-800 flex items-center justify-center">
                                    <span className="text-4xl font-bold text-white/20">{getInitials(user.full_name)}</span>
                                </div>
                                <div className="absolute bottom-2 left-2 px-2 py-0.5 bg-[#8b5cf6] rounded text-[10px] font-bold">You (Active)</div>
                                <div className="absolute top-2 right-2 flex gap-1">
                                    <span className="material-symbols-outlined text-[#8b5cf6] text-sm">mic</span>
                                </div>
                            </div>
                        )}
                        {participants.map((p, i) => (
                            <div key={i} className="relative rounded-lg overflow-hidden border border-white/10 bg-zinc-900">
                                <div className="absolute inset-0 bg-zinc-800 flex items-center justify-center">
                                    <span className="text-3xl font-bold text-white/20">{getInitials(p.full_name)}</span>
                                </div>
                                <div className="absolute bottom-2 left-2 px-2 py-0.5 bg-black/60 rounded text-[10px] font-bold">{p.full_name}</div>
                            </div>
                        ))}
                        <div className="relative rounded-lg overflow-hidden border border-white/10 bg-zinc-900 flex items-center justify-center">
                            <button className="flex flex-col items-center gap-2 text-white/60 hover:text-white transition-colors">
                                <span className="material-symbols-outlined">add_circle</span>
                                <span className="text-xs font-bold">Invite</span>
                            </button>
                        </div>
                    </div>
                </div>

                {/* Sidebar (Transcript/Chat) */}
                <div className="flex-1 min-w-[340px] flex flex-col gap-4 max-h-full">
                    <div className="backdrop-blur-xl bg-white/5 rounded-xl border border-white/10 flex flex-col flex-1 overflow-hidden">
                        <div className="flex border-b border-white/10">
                            <button className="flex-1 py-3 text-xs font-bold border-b-2 border-[#8b5cf6] bg-[#8b5cf6]/10 text-[#8b5cf6]">LIVE TRANSCRIPT</button>
                            <button className="flex-1 py-3 text-xs font-bold text-white/40 hover:text-white/60">CHAT</button>
                        </div>
                        <div className="flex-1 overflow-y-auto p-4 flex flex-col gap-4">
                            <div className="flex flex-col gap-1 items-center justify-center h-full text-white/30 text-center">
                                <span className="material-symbols-outlined text-4xl mb-2">graphic_eq</span>
                                <p className="text-xs">Waiting for speech...</p>
                            </div>
                        </div>
                        <div className="bg-[#8b5cf6]/10 border-t border-[#8b5cf6]/30 p-4">
                            <div className="flex items-center gap-2 mb-3">
                                <span className="material-symbols-outlined text-[#8b5cf6] text-lg">psychology</span>
                                <h3 className="text-xs font-bold uppercase tracking-wider text-[#8b5cf6]">AI Assistant Insights</h3>
                            </div>
                            <div className="relative">
                                <input className="w-full bg-black/40 border border-white/10 rounded-lg py-2 pl-3 pr-10 text-xs focus:ring-1 focus:ring-[#8b5cf6] outline-none" placeholder="Ask AI anything..." type="text" />
                                <button className="absolute right-2 top-1/2 -translate-y-1/2 text-[#8b5cf6]">
                                    <span className="material-symbols-outlined text-sm">send</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            {/* Controls Footer */}
            <footer className="p-6 flex justify-center items-center relative gap-6">
                <div className="flex items-center gap-3 backdrop-blur-xl bg-black/60 px-6 py-3 rounded-2xl border border-white/10">
                    <button className="flex items-center justify-center size-12 rounded-xl bg-white/5 border border-white/10 text-white hover:bg-white/10 hover:border-[#8b5cf6]/50 transition-all">
                        <span className="material-symbols-outlined">mic</span>
                    </button>
                    <button className="flex items-center justify-center size-12 rounded-xl bg-white/5 border border-white/10 text-white hover:bg-white/10 hover:border-[#8b5cf6]/50 transition-all">
                        <span className="material-symbols-outlined">videocam</span>
                    </button>
                    <div className="h-8 w-px bg-white/10 mx-2"></div>
                    <button className="flex items-center justify-center size-12 rounded-xl bg-[#8b5cf6] text-white shadow-[0_0_20px_rgba(139,92,246,0.4)]">
                        <span className="material-symbols-outlined">present_to_all</span>
                    </button>
                    <button className="flex items-center justify-center size-12 rounded-xl bg-white/5 border border-white/10 text-white hover:bg-white/10 transition-all">
                        <span className="material-symbols-outlined">front_hand</span>
                    </button>
                    <button className="flex items-center justify-center px-4 h-12 rounded-xl bg-[#8b5cf6]/10 border border-[#8b5cf6]/30 text-[#8b5cf6] gap-2">
                        <span className="material-symbols-outlined text-sm">translate</span>
                        <span className="text-[10px] font-bold uppercase tracking-widest">Live On</span>
                    </button>
                    <div className="h-8 w-px bg-white/10 mx-2"></div>
                    <Link href="/dashboard" className="flex items-center justify-center px-6 h-12 rounded-xl bg-red-500/10 border border-red-500/30 text-red-500 hover:bg-red-500 hover:text-white transition-colors font-bold text-sm tracking-wide">
                        LEAVE
                    </Link>
                </div>

                <div className="absolute right-8 bottom-8 flex items-center gap-3">
                    <div className="backdrop-blur-md bg-[#8b5cf6]/5 px-4 py-2 rounded-xl border border-[#8b5cf6]/30 flex items-center gap-3">
                        <div className="size-2 rounded-full bg-[#8b5cf6] animate-pulse"></div>
                        <span className="text-[10px] font-bold text-[#8b5cf6]/80">AI Active</span>
                    </div>
                </div>
            </footer>
        </div>
    );
}
