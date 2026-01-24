"use client";

import React from 'react';
import { motion, Variants } from 'framer-motion';

interface Slide3Props {
    onNext: () => void;
    onBack: () => void;
}

const floatingVariants = (yDelta: number, duration: number, delay: number = 0): Variants => ({
    animate: {
        y: [0, -yDelta, 0],
        transition: {
            duration: duration,
            repeat: Infinity,
            repeatType: "reverse",
            ease: "easeInOut",
            delay: delay
        }
    }
});

const Slide3: React.FC<Slide3Props> = ({ onNext, onBack }) => {
    return (
        <div className="flex-1 flex flex-col">
            {/* Main Content (Hero Section) */}
            <main className="flex-1 flex items-center justify-center px-6 lg:px-40 py-10 relative overflow-hidden">
                <div className="max-w-[1200px] w-full grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
                    {/* Left Side: Content */}
                    <div className="flex flex-col gap-8">
                        <div className="flex flex-col gap-4">
                            <h1 className="text-primary text-5xl lg:text-7xl font-bold leading-[1.1] tracking-tight">
                                Capture Every Detail
                            </h1>
                            <p className="text-muted-foreground text-lg lg:text-xl font-normal leading-relaxed max-w-[500px] font-sans">
                                Let our AI assistant generate comprehensive meeting summaries, action items, and key insights automatically.
                            </p>
                        </div>
                        <div className="flex flex-wrap gap-4">
                            <button
                                onClick={onNext}
                                className="flex min-w-[160px] cursor-pointer items-center justify-center rounded-lg h-14 px-8 bg-primary text-white text-lg font-bold shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all font-sans"
                            >
                                Get Started
                            </button>
                            <button
                                onClick={onBack}
                                className="flex min-w-[160px] cursor-pointer items-center justify-center rounded-lg h-14 px-8 border-2 border-primary/50 text-foreground text-lg font-bold hover:bg-primary/10 transition-all font-sans">
                                Back
                            </button>
                        </div>
                        {/* Progress Indicators for Slide 3 */}
                        <div className="flex items-center gap-3 mt-8">
                            <div className="h-2 w-2 rounded-full bg-muted"></div>
                            <div className="h-2 w-2 rounded-full bg-muted"></div>
                            <div className="h-2 w-10 rounded-full bg-primary shadow-sm shadow-primary/50"></div>
                        </div>
                    </div>

                    {/* Right Side: Visuals */}
                    <div className="relative w-full aspect-square max-w-[500px] mx-auto lg:mx-0">
                        {/* AI Glow Background */}
                        <div className="absolute inset-0 flex items-center justify-center">
                            <motion.div
                                animate={{ scale: [1, 1.1, 1], opacity: [0.5, 0.7, 0.5] }}
                                transition={{ duration: 5, repeat: Infinity, ease: "easeInOut" }}
                                className="w-full h-full bg-[radial-gradient(circle,rgba(127,19,236,0.3)_0%,rgba(25,16,34,0)_70%)] opacity-60"
                            ></motion.div>
                        </div>

                        {/* Digital Notepad Container */}
                        <div className="absolute inset-0 flex items-center justify-center p-4">
                            <div className="w-[85%] h-[85%] bg-card border border-border rounded-xl shadow-2xl p-8 relative overflow-hidden">
                                {/* Header of "Doc" */}
                                <div className="flex items-center gap-3 mb-8">
                                    <span className="material-symbols-outlined text-primary">description</span>
                                    <div className="h-4 w-32 bg-muted rounded-full"></div>
                                </div>
                                {/* Auto-filling text lines */}
                                <div className="space-y-4">
                                    <div className="h-3 w-full bg-muted rounded-full"></div>
                                    <div className="h-3 w-4/5 bg-muted rounded-full"></div>
                                    <div className="h-3 w-full bg-muted rounded-full opacity-60"></div>
                                    <div className="h-3 w-2/3 bg-muted rounded-full opacity-40"></div>
                                </div>
                                {/* Floating Glassmorphism Elements from slide3.html */}
                                <motion.div
                                    variants={floatingVariants(10, 4, 0.5)}
                                    animate="animate"
                                    className="absolute top-[15%] right-4 glass p-4 rounded-xl flex items-center gap-3 w-[240px] shadow-[0_0_50px_rgba(127,19,236,0.4)] bg-white/10 border border-white/20 backdrop-blur-md z-10"
                                >
                                    <div className="bg-primary/20 p-2 rounded-lg">
                                        <span className="material-symbols-outlined text-primary text-sm">check_circle</span>
                                    </div>
                                    <div>
                                        <p className="text-[10px] text-primary font-bold uppercase tracking-widest leading-none mb-1">Decision</p>
                                        <p className="text-sm text-foreground font-medium leading-none">Launch Q3 Strategy</p>
                                    </div>
                                </motion.div>
                                <motion.div
                                    variants={floatingVariants(12, 5, 0)}
                                    animate="animate"
                                    className="absolute bottom-[15%] left-4 glass p-4 rounded-xl flex items-center gap-3 w-[220px] shadow-[0_0_50px_rgba(127,19,236,0.4)] bg-white/10 border border-white/20 backdrop-blur-md z-10"
                                >
                                    <div className="bg-primary/20 p-2 rounded-lg">
                                        <span className="material-symbols-outlined text-primary text-sm">assignment</span>
                                    </div>
                                    <div>
                                        <p className="text-[10px] text-primary font-bold uppercase tracking-widest leading-none mb-1">Task</p>
                                        <p className="text-sm text-foreground font-medium leading-none">Update API Documentation</p>
                                    </div>
                                </motion.div>
                                {/* AI Chip Icon */}
                                <motion.div
                                    variants={floatingVariants(8, 3.5, 1)}
                                    animate="animate"
                                    className="absolute bottom-6 right-6 flex items-center justify-center"
                                >
                                    <div className="size-16 rounded-xl bg-primary/10 border border-primary/30 flex items-center justify-center shadow-[0_0_40px_rgba(127,19,236,0.2)]">
                                        <span className="material-symbols-outlined text-primary text-3xl">psychology</span>
                                    </div>
                                </motion.div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
};

export default Slide3;
