"use client";

import { useState } from "react";

export default function AIPage() {
    const [messages, setMessages] = useState([
        { role: "assistant", text: "Hello! I'm your V-Sync AI Assistant. I can help you summarize meetings, find specific talking points, or draft follow-up emails. What can I do for you today?" }
    ]);

    return (
        <div className="p-8 h-full flex flex-col">
            <header className="mb-8">
                <h1 className="text-3xl font-bold">AI Assistant</h1>
                <p className="text-slate-500 dark:text-slate-400 mt-1">Chat with your unified AI to glean insights from all sessions.</p>
            </header>

            <div className="flex-1 bg-white dark:bg-card border border-slate-200 dark:border-slate-800 rounded-2xl overflow-hidden shadow-sm flex flex-col mb-8">
                <div className="flex-1 p-6 overflow-y-auto space-y-4">
                    {messages.map((msg, i) => (
                        <div key={i} className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}>
                            <div className={`max-w-[80%] p-4 rounded-2xl ${msg.role === 'user'
                                    ? 'bg-primary text-white'
                                    : 'bg-slate-100 dark:bg-slate-800 text-slate-800 dark:text-slate-200'
                                }`}>
                                <p className="text-sm leading-relaxed">{msg.text}</p>
                            </div>
                        </div>
                    ))}
                </div>
                <div className="p-4 border-t border-slate-100 dark:border-slate-800 flex items-center space-x-4">
                    <input
                        type="text"
                        placeholder="Ask about your meetings..."
                        className="flex-1 bg-slate-50 dark:bg-slate-900 border-none rounded-xl px-4 py-3 focus:ring-2 focus:ring-primary/50 text-sm outline-none"
                    />
                    <button className="bg-primary text-white w-12 h-12 rounded-xl flex items-center justify-center shadow-lg shadow-primary/25">
                        <span className="material-icons-round">send</span>
                    </button>
                </div>
            </div>
        </div>
    );
}
