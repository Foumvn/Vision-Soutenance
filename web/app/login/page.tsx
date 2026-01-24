"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { login } from "../lib/api";

export default function Login() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);
    const router = useRouter();

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setError("");
        setLoading(true);

        try {
            const data = await login(email, password);
            localStorage.setItem("access_token", data.access_token);
            router.push("/dashboard"); // Redirect to dashboard
        } catch (err: any) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    return (
        <main className="min-h-screen bg-[#0B0A10] flex items-center justify-center p-6 mesh-gradient overflow-hidden relative">
            <div className="absolute top-1/4 -left-20 w-96 h-96 bg-primary/10 rounded-full blur-[120px] animate-pulse"></div>

            <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6 }}
                className="max-w-md w-full glass rounded-[2.5rem] p-10 shadow-2xl relative z-10"
            >
                <div className="flex items-center gap-3 mb-10">
                    <div className="w-12 h-12 bg-primary rounded-2xl flex items-center justify-center shadow-lg shadow-primary/20">
                        <span className="material-icons text-white text-2xl">blur_on</span>
                    </div>
                    <span className="text-2xl font-black text-white tracking-tight">V-SYNC AI</span>
                </div>

                <h2 className="text-3xl font-bold text-white mb-2">Welcome Back</h2>
                <p className="text-slate-400 mb-10 font-medium">Log in to your intelligent workspace.</p>

                {error && <div className="mb-4 text-red-500 text-sm font-bold bg-red-500/10 p-3 rounded-lg text-center">{error}</div>}

                <form className="space-y-6" onSubmit={handleSubmit}>
                    <div className="space-y-2">
                        <label className="text-xs font-black text-slate-500 uppercase tracking-widest ml-1">Email Address</label>
                        <div className="relative">
                            <span className="material-icons absolute left-4 top-1/2 -translate-y-1/2 text-slate-500">alternate_email</span>
                            <input
                                type="email"
                                placeholder="name@company.com"
                                className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder:text-slate-600 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all font-medium"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                required
                            />
                        </div>
                    </div>

                    <div className="space-y-2">
                        <label className="text-xs font-black text-slate-500 uppercase tracking-widest ml-1">Password</label>
                        <div className="relative">
                            <span className="material-icons absolute left-4 top-1/2 -translate-y-1/2 text-slate-500">lock</span>
                            <input
                                type="password"
                                placeholder="••••••••"
                                className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder:text-slate-600 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all font-medium"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                required
                            />
                        </div>
                    </div>

                    <button
                        type="submit"
                        disabled={loading}
                        className="w-full py-4 bg-primary hover:bg-primary/90 text-white rounded-2xl font-bold text-lg shadow-xl shadow-primary/25 transition-all hover:scale-[1.02] flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        {loading ? "Signing In..." : "Sign In"}
                        {!loading && <span className="material-icons">arrow_forward</span>}
                    </button>
                </form>

                <div className="mt-10 flex items-center gap-4">
                    <div className="flex-1 h-px bg-white/10"></div>
                    <span className="text-xs font-bold text-slate-500 uppercase tracking-widest">Or continue with</span>
                    <div className="flex-1 h-px bg-white/10"></div>
                </div>

                <div className="mt-8 grid grid-cols-2 gap-4">
                    <button className="flex items-center justify-center gap-2 py-3 bg-white/5 hover:bg-white/10 border border-white/10 rounded-2xl text-white font-bold transition-all">
                        <img src="https://www.google.com/favicon.ico" className="w-4 h-4" alt="Google" />
                        Google
                    </button>
                    <button className="flex items-center justify-center gap-2 py-3 bg-white/5 hover:bg-white/10 border border-white/10 rounded-2xl text-white font-bold transition-all">
                        <img src="https://github.com/favicon.ico" className="w-4 h-4 invert" alt="GitHub" />
                        GitHub
                    </button>
                </div>

                <p className="mt-10 text-center text-slate-400 font-medium">
                    Don't have an account? <Link href="/signin" className="text-primary font-bold hover:underline">Create Account</Link>
                </p>
            </motion.div>
        </main>
    );
}
