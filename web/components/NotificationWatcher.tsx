"use client";

import { useEffect, useState, useRef } from "react";
import { getNotifications } from "@/app/lib/api";
import NotificationToast from "./ui/NotificationToast";

export default function NotificationWatcher() {
    const [currentToast, setCurrentToast] = useState<any>(null);
    const knownIdsRef = useRef<Set<string>>(new Set());
    const isFirstLoad = useRef(true);

    useEffect(() => {
        const checkNotifications = async () => {
            const token = localStorage.getItem("access_token");
            if (!token) return;

            try {
                const notifications = await getNotifications(token);
                // Filter for unread invites
                const unreadInvites = notifications.filter((n: any) => n.type === "MEETING_INVITE" && !n.read);

                if (isFirstLoad.current) {
                    unreadInvites.forEach((n: any) => knownIdsRef.current.add(n.id));
                    isFirstLoad.current = false;
                    return;
                }

                // Check for new ones
                const newNotification = unreadInvites.find((n: any) => !knownIdsRef.current.has(n.id));

                if (newNotification) {
                    setCurrentToast(newNotification);
                    knownIdsRef.current.add(newNotification.id);
                }

            } catch (error: any) {
                // If unauthorized, we might want to stop polling or just log it quietly
                if (error.message?.includes("credentials") || error.message?.includes("403") || error.message?.includes("401")) {
                    // Silently fail for auth errors to avoid console spam
                    return;
                }
                console.error("Notification polling failed", error);
            }
        };

        // Initial check
        checkNotifications();

        // Poll every 5 seconds (slightly less aggressive)
        const interval = setInterval(checkNotifications, 5000);
        return () => clearInterval(interval);
    }, []);

    return (
        <NotificationToast
            notification={currentToast}
            onClose={() => setCurrentToast(null)}
        />
    );
}
