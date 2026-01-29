"use client";

import { motion, AnimatePresence } from "framer-motion";
import { useEffect, useState } from "react";
import Link from "next/link";

interface Notification {
    id: string;
    type: string;
    message: string;
    meeting_id?: string;
    created_at?: string;
}

interface NotificationToastProps {
    notification: Notification | null;
    onClose: () => void;
}

export default function NotificationToast({ notification, onClose }: NotificationToastProps) {


    return (
        <AnimatePresence>
            {notification && (
                <motion.div
                    initial={{ opacity: 0, y: 50, scale: 0.9 }}
                    animate={{ opacity: 1, y: 0, scale: 1 }}
                    exit={{ opacity: 0, y: 20, scale: 0.9 }}
                    className="fixed bottom-6 right-6 z-50 w-full max-w-sm"
                >
                    <div className="bg-white/10 backdrop-blur-xl border border-white/20 p-4 rounded-2xl shadow-2xl flex items-start gap-4">
                        <div className="bg-primary/20 p-3 rounded-xl">
                            <span className="material-icons-round text-primary">notifications_active</span>
                        </div>
                        <div className="flex-1">
                            <h4 className="font-bold text-white text-sm">New Invitation</h4>
                            <p className="text-white/70 text-xs mt-1 leading-relaxed">{notification.message}</p>

                            <div className="flex gap-2 mt-3">
                                <Link
                                    href={`/meeting/invite?room=${notification.meeting_id}`}
                                    className="px-4 py-1.5 bg-primary text-white text-xs font-bold rounded-lg shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all"
                                    onClick={onClose}
                                >
                                    Join
                                </Link>
                                <button
                                    onClick={onClose}
                                    className="px-4 py-1.5 bg-white/5 border border-white/10 text-white text-xs font-bold rounded-lg hover:bg-white/10 transition-all"
                                >
                                    Dismiss
                                </button>
                            </div>
                        </div>
                        <button onClick={onClose} className="text-white/40 hover:text-white transition-colors">
                            <span className="material-icons-round text-sm">close</span>
                        </button>
                    </div>
                </motion.div>
            )}
        </AnimatePresence>
    );
}
