"use client";

import React from 'react';

interface Slide1Props {
    onNext: () => void;
}

const Slide1: React.FC<Slide1Props> = ({ onNext }) => {
    return (
        <div className="flex-1 flex flex-col">
            {/* Main Content */}
            <main className="relative py-10 px-6 overflow-hidden flex items-center flex-1">
                {/* Animated Background Elements */}
                <div className="absolute top-1/4 -left-20 w-96 h-96 bg-primary/20 rounded-full blur-[120px] opacity-30"></div>
                <div className="absolute bottom-1/4 -right-20 w-96 h-96 bg-primary/10 rounded-full blur-[120px] opacity-30"></div>

                <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-16 items-center relative z-10 w-full">
                    <div className="space-y-10 order-2 lg:order-1">
                        <div className="space-y-4">
                            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-primary/10 border border-primary/20 text-primary text-xs font-bold uppercase tracking-wider">
                                <span className="relative flex h-2 w-2">
                                    <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary opacity-75"></span>
                                    <span className="relative inline-flex rounded-full h-2 w-2 bg-primary"></span>
                                </span>
                                New Version 2.0 Live
                            </div>
                            <h1 className="text-6xl md:text-7xl font-extrabold tracking-tight leading-[1.1] text-foreground">
                                Experience <br />
                                <span className="text-transparent bg-clip-text bg-gradient-to-r from-primary to-purple-400">Intelligence</span>
                            </h1>
                            <p className="text-lg md:text-xl text-muted-foreground max-w-xl leading-relaxed">
                                Elevate your video meetings with real-time AI features that help you focus on the conversation, not the notes. Smart transcription, live translation, and automated insights.
                            </p>
                        </div>
                        <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-center">
                            <button
                                onClick={onNext}
                                className="bg-primary hover:bg-primary/90 text-white px-10 py-5 rounded-2xl font-bold text-lg shadow-2xl shadow-primary/30 transition-all hover:scale-[1.02] active:scale-95"
                            >
                                Get Started
                            </button>
                            <button className="px-10 py-5 rounded-2xl font-bold text-lg bg-foreground/5 border border-border hover:bg-foreground/10 transition-all flex items-center gap-2 text-foreground">
                                <span className="material-icons">play_circle</span>
                                Watch Demo
                            </button>
                        </div>
                        {/* Custom Pagination for Slide 1 */}
                        <div className="flex items-center gap-3 pt-6">
                            <div className="h-1.5 w-12 bg-primary rounded-full"></div>
                            <div className="h-1.5 w-3 bg-muted rounded-full transition-all hover:bg-muted-foreground/30 cursor-pointer"></div>
                            <div className="h-1.5 w-3 bg-muted rounded-full transition-all hover:bg-muted-foreground/30 cursor-pointer"></div>
                        </div>
                    </div>

                    <div className="order-1 lg:order-2 relative">
                        <div className="relative w-full aspect-square max-w-[550px] mx-auto">
                            {/* Glow */}
                            <div className="absolute inset-0 bg-primary/20 rounded-full blur-[100px] transform scale-75"></div>

                            {/* Main Visual Image Wrapper */}
                            <div className="relative z-20 w-full h-full rounded-[3rem] overflow-hidden border border-border shadow-2xl animate-float bg-card">
                                <img
                                    alt="Professional woman in a digital meeting"
                                    className="w-full h-full object-cover grayscale-[20%] brightness-90 contrast-110"
                                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuBy3rSZxd0PQLikzLYFmSyJdV-PyBsZNVUDhdik_MtFukZhGLonrSm3Kc0CFY33XtBnaUT-i9NVPy6OtHWPfNShiuoCoXn6QYEcXFwlWl_xKBG0gqFdjhx0ky9H61WVetpHOt2wqAjjDkv3nNqVpCK2VMD2M0Aj2vYJzxakNKpoTwE2-y_Gp424R9Alyy02etp3JvR0spGHed9DxI43CLZowtwt5trfhn4S2AmD-JtED-AFj3wIB_1staVsM7ivnnAw6pHm1aE6sTM"
                                />
                                {/* Meeting Controls Bar */}
                                <div className="absolute bottom-6 left-6 right-6 flex justify-between items-center bg-black/40 backdrop-blur-md rounded-2xl p-4 border border-white/10">
                                    <div className="flex gap-4">
                                        <div className="w-10 h-10 rounded-full bg-red-500/80 flex items-center justify-center">
                                            <span className="material-icons text-white text-sm">call_end</span>
                                        </div>
                                        <div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center">
                                            <span className="material-icons text-white text-sm">mic_off</span>
                                        </div>
                                        <div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center">
                                            <span className="material-icons text-white text-sm">videocam</span>
                                        </div>
                                    </div>
                                    <div className="text-xs font-semibold text-white/70">00:42:15</div>
                                </div>
                            </div>

                            {/* Floating Glassmorphism Cards */}
                            <div className="absolute -top-6 -left-12 z-30 glass px-5 py-3 rounded-2xl flex items-center gap-3 shadow-2xl animate-float" style={{ animationDelay: '-1s' }}>
                                <span className="material-icons text-primary">translate</span>
                                <div className="flex flex-col">
                                    <span className="text-[10px] uppercase tracking-widest text-primary font-bold leading-none mb-1">Translate</span>
                                    <span className="text-sm font-semibold text-foreground leading-none">Live Translation</span>
                                </div>
                            </div>

                            <div className="absolute bottom-16 -left-16 z-30 glass px-5 py-3 rounded-2xl flex items-center gap-3 shadow-2xl animate-float" style={{ animationDelay: '-2s' }}>
                                <span className="material-icons text-primary">closed_caption</span>
                                <div className="flex flex-col">
                                    <span className="text-[10px] uppercase tracking-widest text-primary font-bold leading-none mb-1">Transcription</span>
                                    <span className="text-sm font-semibold text-foreground leading-none">Real-time CC</span>
                                </div>
                            </div>

                            <div className="absolute top-12 -right-12 z-30 glass px-5 py-3 rounded-2xl flex items-center gap-3 shadow-2xl animate-float" style={{ animationDelay: '-0.5s' }}>
                                <span className="material-icons text-primary">description</span>
                                <div className="flex flex-col">
                                    <span className="text-[10px] uppercase tracking-widest text-primary font-bold leading-none mb-1">Notes</span>
                                    <span className="text-sm font-semibold text-foreground leading-none">Smart Summary</span>
                                </div>
                            </div>

                            {/* Additional Indicators */}
                            <div className="absolute top-1/2 -right-6 z-30 w-12 h-12 rounded-full bg-blue-500 flex items-center justify-center shadow-lg shadow-blue-500/40">
                                <span className="material-icons text-white">mic</span>
                            </div>
                            <div className="absolute bottom-1/4 -right-10 z-30 w-16 h-16 rounded-full bg-gradient-to-br from-primary to-pink-500 flex items-center justify-center shadow-lg shadow-primary/40">
                                <span className="material-icons text-white">videocam</span>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
};

export default Slide1;
