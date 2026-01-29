"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Sidebar from "@/components/dashboard/Sidebar";
import { getUserMe } from "@/app/lib/api";


export default function DashboardLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    const router = useRouter();
    const [user, setUser] = useState<{ email: string; full_name?: string } | null>(null);
    const [loading, setLoading] = useState(true);

    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const token = localStorage.getItem("access_token");
        if (!token) {
            router.push("/login");
            return;
        }

        const fetchUser = async () => {
            try {
                const userData = await getUserMe(token);
                setUser(userData);
            } catch (error: any) {
                console.error("Failed to fetch user:", error);
                setError(error.message || "Authentication failed");
            } finally {
                setLoading(false);
            }
        };

        fetchUser();
    }, [router]);

    if (error) {
        return (
            <div className="min-h-screen flex flex-col items-center justify-center bg-slate-900 text-white p-4">
                <div className="bg-red-500/10 border border-red-500/20 p-6 rounded-2xl text-center max-w-md">
                    <span className="material-icons text-red-500 text-4xl mb-4">error_outline</span>
                    <h3 className="text-xl font-bold text-red-500 mb-2">Access Error</h3>
                    <p className="text-slate-300 mb-6 font-mono text-sm bg-black/30 p-2 rounded">{error}</p>
                    <button
                        onClick={() => {
                            localStorage.removeItem("access_token");
                            router.push("/login");
                        }}
                        className="w-full py-3 bg-white/10 hover:bg-white/20 text-white rounded-xl font-bold transition-all"
                    >
                        Back to Login
                    </button>
                </div>
            </div>
        );
    }

    if (loading) {
        return (
            <div className="min-h-screen flex items-center justify-center bg-background-light dark:bg-background-dark">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
            </div>
        );
    }

    if (!user) return null;

    return (
        <div className="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 min-h-screen flex overflow-hidden font-plus-jakarta">
            <Sidebar user={user} />
            <main className="flex-1 overflow-y-auto mesh-gradient relative">
                {children}
            </main>
        </div>
    );
}
