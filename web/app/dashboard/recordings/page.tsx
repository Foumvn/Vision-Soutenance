"use client";

import { motion } from "framer-motion";

export default function RecordingsPage() {
    const recordings = [
        { id: 1, title: "Quarterly Technical Review", date: "Oct 12, 2023", duration: "1h 15m", participants: 8, status: "Analyzed" },
        { id: 2, title: "Frontend Architecture", date: "Oct 11, 2023", duration: "45:20", participants: 4, status: "Ready" },
        { id: 3, title: "Client Feedback: Nike Pro", date: "Oct 10, 2023", duration: "12:15", participants: 3, status: "Translated" },
        { id: 4, title: "Product Sync", date: "Oct 09, 2023", duration: "30:00", participants: 12, status: "Ready" },
    ];

    return (
        <div className="p-8">
            <header className="mb-8">
                <h1 className="text-3xl font-bold">Recordings</h1>
                <p className="text-slate-500 dark:text-slate-400 mt-1">Access and manage your previous meeting recordings and AI insights.</p>
            </header>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {recordings.map((rec) => (
                    <motion.div
                        key={rec.id}
                        whileHover={{ y: -5 }}
                        className="bg-white dark:bg-card rounded-2xl border border-slate-200 dark:border-slate-800 overflow-hidden shadow-sm hover:shadow-md transition-all cursor-pointer"
                    >
                        <div className="aspect-video bg-slate-900 relative flex items-center justify-center group">
                            <div className="absolute inset-0 bg-cover bg-center opacity-60" style={{ backgroundImage: `url('https://picsum.photos/seed/${rec.id}/400/225')` }}></div>
                            <div className="relative z-10 w-12 h-12 bg-primary/20 backdrop-blur-md rounded-full flex items-center justify-center text-white scale-0 group-hover:scale-100 transition-transform">
                                <span className="material-icons-round">play_arrow</span>
                            </div>
                            <div className="absolute bottom-2 right-2 px-2 py-1 bg-black/60 backdrop-blur-md rounded text-[10px] font-bold text-white">
                                {rec.duration}
                            </div>
                        </div>
                        <div className="p-4">
                            <div className="flex items-start justify-between mb-2">
                                <h3 className="font-bold text-lg leading-tight">{rec.title}</h3>
                                <span className="text-[10px] font-bold px-2 py-0.5 bg-primary/10 text-primary rounded-md uppercase">
                                    {rec.status}
                                </span>
                            </div>
                            <div className="flex items-center text-sm text-slate-500 dark:text-slate-400 space-x-4">
                                <span className="flex items-center"><span className="material-icons-round text-sm mr-1">calendar_today</span> {rec.date}</span>
                                <span className="flex items-center"><span className="material-icons-round text-sm mr-1">group</span> {rec.participants}</span>
                            </div>
                        </div>
                    </motion.div>
                ))}
            </div>
        </div>
    );
}
