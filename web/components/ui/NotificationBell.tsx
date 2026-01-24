"use client";

import { useState, useEffect, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { getNotifications, markNotificationAsRead, clearAllNotifications } from "@/app/lib/api";
import Link from "next/link";

interface Notification {
    id: string;
    type: string;
    message: string;
    meeting_id?: string;
    created_at?: string;
    read: boolean;
}

export default function NotificationBell() {
    const [isOpen, setIsOpen] = useState(false);
    const [notifications, setNotifications] = useState<Notification[]>([]);
    const panelRef = useRef<HTMLDivElement>(null);

    const fetchNotifications = async () => {
        const token = localStorage.getItem("access_token");
        if (!token) return;
        try {
            const data = await getNotifications(token);
            setNotifications(data);
        } catch (error: any) {
            // Silently skip auth errors to avoid console spam
            if (error.message?.includes("credentials") || error.message?.includes("403") || error.message?.includes("401")) {
                return;
            }
            console.error("Failed to fetch notifications", error);
        }
    };

    useEffect(() => {
        fetchNotifications();
        const interval = setInterval(fetchNotifications, 5000);
        return () => clearInterval(interval);
    }, []);

    const handleMarkAsRead = async (notificationId: string) => {
        const token = localStorage.getItem("access_token");
        if (!token) return;
        try {
            await markNotificationAsRead(notificationId, token);
            setNotifications(prev => prev.map(n => n.id === notificationId ? { ...n, read: true } : n));
        } catch (error) {
            console.error("Failed to mark as read", error);
        }
    };

    const handleClearAll = async () => {
        const token = localStorage.getItem("access_token");
        if (!token) return;
        try {
            await clearAllNotifications(token);
            setNotifications(prev => prev.map(n => ({ ...n, read: true })));
        } catch (error) {
            console.error("Failed to clear notifications", error);
        }
    };

    // Close panel when clicking outside
    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (panelRef.current && !panelRef.current.contains(event.target as Node)) {
                setIsOpen(false);
            }
        };
        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, []);

    // Only show unread notifications in the list as requested ("doit disparaitre")
    const displayNotifications = notifications.filter(n => !n.read);
    const unreadCount = displayNotifications.length;

    const getNotificationIcon = (type: string) => {
        switch (type) {
            case "MEETING_INVITE":
                return "videocam";
            case "CONTACT_ADDED":
                return "person_add";
            default:
                return "notifications";
        }
    };

    const formatTime = (dateString?: string) => {
        if (!dateString) return "Just now";
        const date = new Date(dateString);
        const now = new Date();
        const diffMs = now.getTime() - date.getTime();
        const diffMins = Math.floor(diffMs / 60000);
        if (diffMins < 1) return "Just now";
        if (diffMins < 60) return `${diffMins}m ago`;
        const diffHours = Math.floor(diffMins / 60);
        if (diffHours < 24) return `${diffHours}h ago`;
        return `${Math.floor(diffHours / 24)}d ago`;
    };

    return (
        <div className="relative" ref={panelRef}>
            {/* Bell Icon Button */}
            <button
                onClick={() => setIsOpen(!isOpen)}
                className="relative p-2 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors group"
            >
                <span className="material-icons-round text-slate-500 dark:text-slate-400 group-hover:text-primary transition-colors">
                    notifications
                </span>
                {unreadCount > 0 && (
                    <span className="absolute -top-0.5 -right-0.5 w-5 h-5 bg-red-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center shadow-lg animate-pulse">
                        {unreadCount > 9 ? "9+" : unreadCount}
                    </span>
                )}
            </button>

            {/* Notification Panel */}
            <AnimatePresence>
                {isOpen && (
                    <motion.div
                        initial={{ opacity: 0, y: 10, scale: 0.95 }}
                        animate={{ opacity: 1, y: 0, scale: 1 }}
                        exit={{ opacity: 0, y: 10, scale: 0.95 }}
                        className="absolute right-0 mt-2 w-80 bg-white dark:bg-card border border-slate-200 dark:border-slate-800 rounded-2xl shadow-2xl overflow-hidden z-50"
                    >
                        {/* Header */}
                        <div className="p-4 border-b border-slate-200 dark:border-slate-800 flex items-center justify-between">
                            <h3 className="font-bold text-sm">Notifications</h3>
                            {unreadCount > 0 && (
                                <span className="text-[10px] font-bold px-2 py-0.5 bg-primary/10 text-primary rounded-full">
                                    {unreadCount} messages
                                </span>
                            )}
                        </div>

                        {/* Notification List */}
                        <div className="max-h-80 overflow-y-auto">
                            {displayNotifications.length === 0 ? (
                                <div className="p-8 text-center">
                                    <div className="w-12 h-12 bg-slate-100 dark:bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-3">
                                        <span className="material-icons-round text-slate-400">notifications_off</span>
                                    </div>
                                    <p className="text-slate-500 text-sm">Pas de nouvelles notifications</p>
                                </div>
                            ) : (
                                displayNotifications.map((notif) => (
                                    <div
                                        key={notif.id}
                                        className="p-4 border-b border-slate-100 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors cursor-pointer bg-primary/5"
                                    >
                                        <div className="flex items-start gap-3">
                                            <div className={`w-9 h-9 rounded-xl flex items-center justify-center shrink-0 ${notif.type === "MEETING_INVITE"
                                                ? "bg-primary/10 text-primary"
                                                : "bg-slate-100 dark:bg-slate-800 text-slate-500"
                                                }`}>
                                                <span className="material-icons-round text-lg">
                                                    {getNotificationIcon(notif.type)}
                                                </span>
                                            </div>
                                            <div className="flex-1 min-w-0">
                                                <p className="text-sm font-medium leading-tight line-clamp-2">
                                                    {notif.message}
                                                </p>
                                                <p className="text-[10px] text-slate-400 mt-1">
                                                    {formatTime(notif.created_at)}
                                                </p>
                                                <div className="flex gap-2 mt-2">
                                                    {notif.type === "MEETING_INVITE" && notif.meeting_id && (
                                                        <Link
                                                            href={`/meeting/invite?room=${notif.meeting_id}`}
                                                            onClick={async () => {
                                                                await handleMarkAsRead(notif.id);
                                                                setIsOpen(false);
                                                            }}
                                                            className="px-3 py-1 bg-primary text-white text-[10px] font-bold rounded-lg hover:bg-primary/90 transition-colors"
                                                        >
                                                            Accepter
                                                        </Link>
                                                    )}
                                                    <button
                                                        onClick={() => handleMarkAsRead(notif.id)}
                                                        className="px-3 py-1 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 text-[10px] font-bold rounded-lg hover:bg-slate-200 transition-colors"
                                                    >
                                                        Ignorer
                                                    </button>
                                                </div>
                                            </div>
                                            <span className="w-2 h-2 bg-primary rounded-full shrink-0 mt-1.5"></span>
                                        </div>
                                    </div>
                                ))
                            )}
                        </div>

                        {/* Footer */}
                        {unreadCount > 0 && (
                            <div className="p-3 border-t border-slate-200 dark:border-slate-800">
                                <button
                                    onClick={handleClearAll}
                                    className="w-full text-center text-xs font-bold text-primary hover:underline"
                                >
                                    Tout marquer comme lu
                                </button>
                            </div>
                        )}
                    </motion.div>
                )}
            </AnimatePresence>
        </div>
    );
}
