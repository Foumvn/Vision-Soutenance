"use client";

export default function MeetingResumePage() {
    return (
        <div className="p-8 max-w-[1600px] mx-auto w-full">
            {/* Heading */}
            <div className="flex flex-wrap items-end justify-between gap-6 mb-8">
                <div className="flex flex-col gap-2">
                    <div className="flex items-center gap-2 text-primary text-sm font-semibold uppercase tracking-widest">
                        <span className="material-symbols-outlined text-sm">video_camera_back</span>
                        Recorded Session
                    </div>
                    <h1 className="text-white text-4xl font-bold tracking-tight">Quarterly Technical Review</h1>
                    <div className="flex items-center gap-4 text-white/50 text-sm mt-1">
                        <span className="flex items-center gap-1.5"><span className="material-symbols-outlined text-sm">calendar_today</span> Oct 12, 2023</span>
                        <span className="flex items-center gap-1.5"><span className="material-symbols-outlined text-sm">schedule</span> 1h 15m</span>
                        <span className="flex items-center gap-1.5"><span className="material-symbols-outlined text-sm">language</span> Translated (EN)</span>
                    </div>
                </div>
                <div className="flex flex-col items-end gap-4">
                    <div className="flex items-center">
                        {[1, 2, 3].map((i) => (
                            <div key={i} className="-ml-3 first:ml-0 overflow-visible w-[34px]">
                                <div className="bg-center bg-no-repeat aspect-square bg-cover border-[#121212] bg-[#302839] rounded-full flex items-center justify-center size-10 border-2" style={{ backgroundImage: `url('https://i.pravatar.cc/150?u=${i}')` }}></div>
                            </div>
                        ))}
                        <div className="-ml-3 overflow-visible w-[34px]">
                            <div className="bg-center bg-no-repeat aspect-square bg-cover border-[#121212] bg-primary text-white text-xs font-bold rounded-full flex items-center justify-center size-10 border-2">+5</div>
                        </div>
                    </div>
                    <div className="flex gap-2">
                        <button className="flex items-center gap-2 px-4 py-2 bg-white/5 border border-white/10 hover:bg-white/10 rounded-lg text-sm font-semibold transition-all">
                            <span className="material-symbols-outlined text-lg">picture_as_pdf</span> Export PDF
                        </button>
                        <button className="flex items-center gap-2 px-4 py-2 bg-primary hover:bg-primary/90 rounded-lg text-sm font-semibold transition-all shadow-lg shadow-primary/20">
                            <span className="material-symbols-outlined text-lg">share</span> Share
                        </button>
                    </div>
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                {/* Main Content */}
                <div className="lg:col-span-2 space-y-8">
                    <section className="bg-white/5 backdrop-blur-md rounded-xl p-6 border border-white/10">
                        <div className="flex items-center gap-2 mb-4">
                            <span className="material-symbols-outlined text-primary">auto_fix_high</span>
                            <h2 className="text-xl font-bold">Executive Summary</h2>
                        </div>
                        <p className="text-white/80 leading-relaxed text-lg italic">
                            The meeting focused on the Q3 infrastructure scaling performance and the proposed budget for Q4. The engineering team successfully migrated 80% of services to the new architecture, resulting in a 25% reduction in latency...
                        </p>
                    </section>

                    <section className="bg-white/5 backdrop-blur-md rounded-xl p-6 border border-white/10">
                        <div className="flex items-center gap-2 mb-6">
                            <span className="material-symbols-outlined text-emerald-500">check_circle</span>
                            <h2 className="text-xl font-bold">Key Decisions</h2>
                        </div>
                        <ul className="space-y-4">
                            {[
                                { title: "Migration Strategy Approved", desc: "Agreed to full AWS us-east-1 cutover by end of October." },
                                { title: "Q4 Infrastructure Budget", desc: "Total spend of $1.2M approved with focus on observability tools." }
                            ].map((item, i) => (
                                <li key={i} className="flex items-start gap-4 bg-white/5 rounded-lg p-4 border-l-4 border-emerald-500">
                                    <span className="material-symbols-outlined text-emerald-500 mt-0.5">verified</span>
                                    <div>
                                        <p className="font-bold">{item.title}</p>
                                        <p className="text-sm text-white/60">{item.desc}</p>
                                    </div>
                                </li>
                            ))}
                        </ul>
                    </section>

                    <section className="bg-white/5 backdrop-blur-md rounded-xl p-6 border border-white/10">
                        <div className="flex items-center justify-between mb-6">
                            <div className="flex items-center gap-2">
                                <span className="material-symbols-outlined text-primary">list_alt</span>
                                <h2 className="text-xl font-bold">Action Items</h2>
                            </div>
                            <span className="text-xs text-white/40 uppercase font-bold tracking-widest">4 Tasks Pending</span>
                        </div>
                        <div className="space-y-3">
                            {[
                                { task: "Update legacy DB deprecation docs", date: "Oct 18" },
                                { task: "Finalize security protocol draft", date: "Oct 20" }
                            ].map((item, i) => (
                                <div key={i} className="flex items-center justify-between bg-white/5 p-4 rounded-lg border border-white/5">
                                    <div className="flex items-center gap-4">
                                        <input type="checkbox" className="rounded border-white/20 bg-transparent text-primary focus:ring-primary" />
                                        <span className="text-sm font-medium">{item.task}</span>
                                    </div>
                                    <span className="text-[10px] px-2 py-1 bg-primary/20 text-primary rounded font-bold uppercase">{item.date}</span>
                                </div>
                            ))}
                        </div>
                    </section>
                </div>

                {/* Sidebar */}
                <div className="space-y-8">
                    <section className="bg-white/5 backdrop-blur-md rounded-xl overflow-hidden border border-white/10">
                        <div className="relative group aspect-video bg-black/40 flex items-center justify-center">
                            <span className="material-symbols-outlined text-6xl text-white/80 group-hover:text-primary transition-colors cursor-pointer relative z-10">play_circle</span>
                            <div className="absolute bottom-0 left-0 right-0 p-4 z-20">
                                <div className="h-1.5 w-full bg-white/20 rounded-full overflow-hidden">
                                    <div className="h-full bg-primary w-[32%]"></div>
                                </div>
                            </div>
                        </div>
                        <div className="p-4 flex items-center justify-between">
                            <h3 className="text-sm font-bold">Watch Replay</h3>
                            <button className="material-symbols-outlined text-white/40 hover:text-white text-lg">settings</button>
                        </div>
                    </section>

                    <section className="bg-white/5 backdrop-blur-md rounded-xl p-6 border border-white/10">
                        <h2 className="text-lg font-bold mb-4">Sentiment Analysis</h2>
                        <div className="flex items-center gap-4">
                            <div className="text-3xl font-bold text-emerald-500">85%</div>
                            <div className="flex-1 h-3 bg-white/10 rounded-full overflow-hidden">
                                <div className="bg-emerald-500 h-full w-[85%]"></div>
                            </div>
                            <div className="text-xs text-white/40 uppercase font-bold">Productive</div>
                        </div>
                    </section>

                    <section className="bg-white/5 backdrop-blur-md rounded-xl p-6 border border-white/10">
                        <h2 className="text-lg font-bold mb-4">Topic Cloud</h2>
                        <div className="flex flex-wrap gap-2">
                            {['Migration', 'AWS', 'Security', 'Budget', 'Zero-Trust', 'Latency'].map((topic) => (
                                <span key={topic} className="px-3 py-1 bg-white/5 rounded-lg text-xs font-bold text-white/70 hover:bg-primary/20 hover:text-primary cursor-default transition-colors">
                                    {topic}
                                </span>
                            ))}
                        </div>
                    </section>
                </div>
            </div>
        </div>
    );
}
