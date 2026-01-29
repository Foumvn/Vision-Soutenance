"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { motion, AnimatePresence } from "framer-motion";
import { useRouter } from "next/navigation";
import { getUserMe, getNotifications, clearAllNotifications } from "@/app/lib/api";
import NotificationBell from "@/components/ui/NotificationBell";

export default function Dashboard() {
    const [user, setUser] = useState<{ email: string; full_name?: string } | null>(null);
    const [notifications, setNotifications] = useState<any[]>([]);
    const [isClearing, setIsClearing] = useState(false);
    const router = useRouter();

    const fetchNotifications = async () => {
        const token = localStorage.getItem("access_token");
        if (token) {
            try {
                const notifs = await getNotifications(token);
                setNotifications(notifs);
            } catch (error) {
                console.error("Failed to fetch notifications:", error);
            }
        }
    };

    useEffect(() => {
        const token = localStorage.getItem("access_token");
        if (token) {
            getUserMe(token).then(setUser).catch(console.error);
            fetchNotifications();
        }
    }, []);

    const handleClearNotifications = async () => {
        const token = localStorage.getItem("access_token");
        if (!token) return;

        try {
            setIsClearing(true);
            await clearAllNotifications(token);
            // Refresh notifications to hide cleared ones
            await fetchNotifications();
        } catch (error) {
            console.error("Failed to clear notifications:", error);
        } finally {
            setIsClearing(false);
        }
    };

    const invitationCount = notifications.filter(n => n.type === "MEETING_INVITE" && !n.read).length;
    const unreadMeetingInvites = notifications.filter(n => n.type === "MEETING_INVITE" && !n.read);

    return (
        <>
            <header className="p-8 flex flex-col md:flex-row md:items-center justify-between gap-6">
                <div>
                    <h1 className="text-3xl font-bold">Welcome back, {user?.full_name?.split(' ')[0] || "User"}! 👋</h1>
                    <p className="text-slate-500 dark:text-slate-400 mt-1">You have 3 meetings scheduled for today.</p>
                </div>
                <div className="flex items-center gap-3">
                    <NotificationBell />
                    <div className="flex items-center gap-3 glass p-2 rounded-2xl border border-slate-200 dark:border-slate-800">
                        <div className="flex items-center px-4 py-2 bg-slate-100 dark:bg-slate-800/50 rounded-xl border border-slate-200 dark:border-slate-700 focus-within:ring-2 focus-within:ring-primary/50 transition-all flex-1 md:w-64">
                            <span className="material-icons-round text-slate-400 mr-2 text-xl">vpn_key</span>
                            <input
                                className="bg-transparent border-none focus:ring-0 text-sm w-full p-0 outline-none"
                                placeholder="Enter meeting code..."
                                type="text"
                                id="meeting-code-input"
                                onKeyDown={(e) => {
                                    if (e.key === 'Enter') {
                                        const code = (e.target as HTMLInputElement).value;
                                        if (code) router.push(`/meeting/invite?room=${encodeURIComponent(code)}`);
                                    }
                                }}
                            />
                        </div>
                        <button
                            onClick={() => {
                                const input = document.getElementById('meeting-code-input') as HTMLInputElement;
                                if (input.value) router.push(`/meeting/invite?room=${encodeURIComponent(input.value)}`);
                            }}
                            className="bg-primary hover:bg-primary/90 text-white px-6 py-2 rounded-xl font-semibold transition-all shadow-lg shadow-primary/25"
                        >
                            Join
                        </button>
                    </div>
                </div>
            </header>

            <div className="px-8 pb-12 space-y-8">
                {/* Notifications Alert */}
                <AnimatePresence>
                    {invitationCount > 0 && (
                        <motion.div
                            initial={{ height: 0, opacity: 0 }}
                            animate={{ height: "auto", opacity: 1 }}
                            exit={{ height: 0, opacity: 0 }}
                            className="bg-primary/10 border border-primary/20 rounded-2xl p-4 flex items-center justify-between"
                        >
                            <div className="flex items-center gap-3">
                                <span className="material-icons-round text-primary animate-bounce">notification_important</span>
                                <div>
                                    <p className="font-bold text-sm tracking-tight text-primary">You have {invitationCount} meeting invitations</p>
                                    <p className="text-xs text-primary/60">Check your notifications to join the sessions.</p>
                                </div>
                            </div>
                            <div className="flex items-center gap-2">
                                <button
                                    onClick={handleClearNotifications}
                                    disabled={isClearing}
                                    className="px-3 py-1.5 bg-primary/10 text-primary rounded-lg text-xs font-bold hover:bg-primary/20 transition-colors disabled:opacity-50"
                                >
                                    {isClearing ? "..." : "Dismiss"}
                                </button>
                                <Link
                                    href="/meeting/pre-join"
                                    className="bg-primary text-white px-4 py-2 rounded-xl text-xs font-bold shadow-lg shadow-primary/20"
                                >
                                    View All
                                </Link>
                            </div>
                        </motion.div>
                    )}
                </AnimatePresence>

                <section className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <Link
                        href="/meeting/pre-join"
                        className="relative group overflow-hidden bg-primary p-8 rounded-2xl flex items-center justify-between text-white cursor-pointer hover:shadow-2xl hover:shadow-primary/40 transition-all duration-300">
                        <div className="relative z-10">
                            <h3 className="text-2xl font-bold">New Meeting</h3>
                            <p className="text-white/80 mt-2">Start an instant session with your team.</p>
                            <button className="mt-6 px-6 py-2.5 bg-white text-primary rounded-xl font-bold text-sm shadow-sm">Start Now</button>
                        </div>
                        <div className="relative z-10 opacity-40 group-hover:scale-110 transition-transform duration-500">
                            <span className="material-icons-round text-8xl">video_call</span>
                        </div>
                        <div className="absolute -right-10 -bottom-10 w-48 h-48 bg-white/10 rounded-full blur-3xl"></div>
                    </Link>

                    <Link
                        href="/dashboard/calendar"
                        className="relative group overflow-hidden bg-slate-900 dark:bg-card p-8 rounded-2xl flex items-center justify-between text-white border border-slate-800 cursor-pointer hover:border-slate-700 transition-all duration-300 shadow-xl">
                        <div className="relative z-10">
                            <h3 className="text-2xl font-bold">Schedule</h3>
                            <p className="text-slate-400 mt-2">Plan your next collaborative session.</p>
                            <button className="mt-6 px-6 py-2.5 bg-slate-800 text-white border border-slate-700 rounded-xl font-bold text-sm shadow-sm hover:bg-slate-700 transition-colors">Open Calendar</button>
                        </div>
                        <div className="relative z-10 opacity-30 group-hover:scale-110 transition-transform duration-500">
                            <span className="material-icons-round text-8xl">event</span>
                        </div>
                    </Link>
                </section>

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <div className="lg:col-span-2 space-y-8">
                        <section className="bg-white dark:bg-card rounded-2xl border border-slate-200 dark:border-slate-800 overflow-hidden shadow-sm">
                            <div className="p-6 border-b border-slate-200 dark:border-slate-800 flex items-center justify-between">
                                <h2 className="text-xl font-bold">Upcoming Meetings</h2>
                                <div className="flex items-center gap-3">
                                    {invitationCount > 0 && (
                                        <span className="text-xs font-semibold px-3 py-1 bg-primary/10 text-primary rounded-full uppercase tracking-wider">
                                            {invitationCount} New
                                        </span>
                                    )}
                                    {unreadMeetingInvites.length > 0 && (
                                        <button
                                            onClick={handleClearNotifications}
                                            disabled={isClearing}
                                            className="text-xs font-semibold px-3 py-1 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors disabled:opacity-50"
                                        >
                                            {isClearing ? "Clearing..." : "Clear All"}
                                        </button>
                                    )}
                                </div>
                            </div>
                            <div className="divide-y divide-slate-100 dark:divide-slate-800">
                                {unreadMeetingInvites.length > 0 ? (
                                    unreadMeetingInvites.map((notif, i) => (
                                        <div key={i} className="p-6 hover:bg-slate-50 dark:hover:bg-slate-800/30 transition-colors flex items-center gap-6">
                                            <div className="w-12 h-12 rounded-2xl bg-primary/10 flex items-center justify-center border border-primary/20">
                                                <span className="material-icons-round text-primary">videocam</span>
                                            </div>
                                            <div className="flex-1 min-w-0">
                                                <h4 className="font-bold text-sm truncate">{notif.message}</h4>
                                                <p className="text-xs text-slate-500 mt-1">Just now</p>
                                            </div>
                                            <Link href={`/meeting/invite?room=${notif.meeting_id}`} className="px-4 py-2 bg-primary text-white rounded-xl font-bold text-xs shadow-sm">Accept</Link>
                                        </div>
                                    ))
                                ) : (
                                    <div className="p-12 text-center">
                                        <div className="w-16 h-16 bg-slate-100 dark:bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-4">
                                            <span className="material-icons-round text-slate-400">event_busy</span>
                                        </div>
                                        <p className="text-slate-500 font-medium">No upcoming meetings</p>
                                        <Link href="/meeting/pre-join" className="text-primary text-sm font-bold mt-2 inline-block">Start one now</Link>
                                    </div>
                                )}
                            </div>
                        </section>

                    </div>

                    <div className="space-y-6">
                        <div className="bg-gradient-to-br from-indigo-900/40 to-purple-900/40 dark:from-indigo-900/20 dark:to-purple-900/20 border border-primary/20 p-6 rounded-2xl shadow-xl glass">
                            <div className="flex items-center gap-3 mb-6">
                                <div className="w-10 h-10 bg-primary/20 text-primary rounded-xl flex items-center justify-center">
                                    <span className="material-icons-round">psychology</span>
                                </div>
                                <h2 className="text-lg font-bold">AI Meeting Assistant</h2>
                            </div>
                            <div className="space-y-4">
                                <div className="bg-white/5 p-4 rounded-xl border border-white/5">
                                    <p className="text-[10px] font-bold text-primary uppercase tracking-widest mb-2">Last Summary</p>
                                    <p className="text-sm leading-relaxed text-slate-300 italic">"Alison proposed a switch to Tailwind v4, Peter noted the performance benefits. Deployment set for next sprint."</p>
                                </div>
                                <div className="grid grid-cols-2 gap-3">
                                    <div className="p-3 bg-white/5 rounded-xl border border-white/5 text-center">
                                        <p className="text-xs text-slate-400">Translation Accuracy</p>
                                        <p className="text-xl font-bold text-accent">98.4%</p>
                                    </div>
                                    <div className="p-3 bg-white/5 rounded-xl border border-white/5 text-center">
                                        <p className="text-xs text-slate-400">Hours Saved</p>
                                        <p className="text-xl font-bold text-primary">12h</p>
                                    </div>
                                </div>
                                <button className="w-full py-3 bg-primary text-white font-bold rounded-xl shadow-lg shadow-primary/30 flex items-center justify-center gap-2">
                                    <span className="material-icons-round text-sm">analytics</span> Generate Reports
                                </button>
                            </div>
                        </div>

                        <section className="bg-white dark:bg-card p-6 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
                            <div className="flex items-center justify-between mb-6">
                                <h2 className="font-bold">Live Translation</h2>
                                <span className="flex items-center text-accent text-xs font-black"><span className="w-2 h-2 bg-accent rounded-full mr-1.5 animate-pulse"></span> ACTIVE</span>
                            </div>
                            <div className="space-y-4">
                                <div className="flex items-center justify-between p-3 rounded-xl bg-slate-50 dark:bg-slate-800/50">
                                    <div className="flex items-center">
                                        <span className="text-lg mr-3">🇺🇸</span>
                                        <span className="text-sm font-semibold">English</span>
                                    </div>
                                    <span className="text-xs text-slate-500 font-medium">Source</span>
                                </div>
                                <div className="flex items-center justify-between p-3 rounded-xl border border-slate-100 dark:border-slate-800">
                                    <div className="flex items-center">
                                        <span className="text-lg mr-3">🇯🇵</span>
                                        <span className="text-sm font-semibold text-slate-600 dark:text-slate-400">Japanese</span>
                                    </div>
                                    <span className="material-icons-round text-slate-400 text-sm">visibility</span>
                                </div>
                                <button className="w-full text-slate-500 dark:text-slate-400 text-xs font-bold hover:text-primary transition-colors">+ Add More Languages</button>
                            </div>
                        </section>
                    </div>
                </div>
            </div>

            <motion.button
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                className="fixed bottom-8 right-8 w-14 h-14 bg-primary text-white rounded-full flex items-center justify-center shadow-2xl shadow-primary/40 z-50 group">
                <span className="material-icons-round">chat_bubble</span>
                <span className="absolute right-16 bg-slate-900 dark:bg-card text-white px-3 py-1.5 rounded-lg text-xs font-bold border border-slate-700 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap">AI Assistant</span>
            </motion.button>
        </>
    );
}
