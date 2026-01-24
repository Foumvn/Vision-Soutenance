"use client";

import React from 'react';
import { motion, Variants } from 'framer-motion';

interface Slide2Props {
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

const Slide2: React.FC<Slide2Props> = ({ onNext, onBack }) => {
    return (
        <div className="flex-1 flex flex-col">
            {/* Main Content */}
            <main className="flex-1 flex items-center justify-center px-6 md:px-20 lg:px-40 py-12 relative overflow-hidden">
                <div className="max-w-[1200px] flex-1">
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
                        <div className="flex flex-col gap-8 order-2 lg:order-1">
                            <div className="flex flex-col gap-4">
                                <div className="flex items-center gap-2">
                                    <span className="px-3 py-1 bg-primary/20 text-primary text-[10px] font-bold tracking-widest uppercase rounded-full border border-primary/30">Slide 02</span>
                                    <div className="h-[1px] w-12 bg-primary/30"></div>
                                </div>
                                <h1 className="text-foreground text-5xl md:text-7xl font-bold leading-[1.05] tracking-tight">
                                    Break Language <br /><span className="text-primary">Barriers</span>
                                </h1>
                                <p className="text-muted-foreground text-lg md:text-xl font-normal leading-relaxed max-w-md font-sans">
                                    Engage in global collaboration with seamless real-time audio and text translation in over 50 languages.
                                </p>
                            </div>
                            <div className="flex flex-wrap gap-4">
                                <button
                                    onClick={onNext}
                                    className="flex min-w-[180px] cursor-pointer items-center justify-center overflow-hidden rounded-xl h-14 px-8 bg-primary text-white text-base font-bold shadow-xl shadow-primary/30 hover:brightness-110 active:scale-[0.98] transition-all font-sans"
                                >
                                    <span className="truncate">Get Started</span>
                                </button>
                                <button
                                    onClick={onBack}
                                    className="flex min-w-[180px] cursor-pointer items-center justify-center overflow-hidden rounded-xl h-14 px-8 bg-transparent text-foreground text-base font-bold border-2 border-border hover:bg-foreground/5 transition-all font-sans"
                                >
                                    <span className="truncate">Back to Start</span>
                                </button>
                            </div>
                            {/* Pagination Indicators for Slide 2 */}
                            <div className="flex items-center gap-3 mt-4">
                                <div className="h-2 w-2 rounded-full bg-muted"></div>
                                <div className="h-2 w-10 rounded-full bg-primary shadow-[0_0_25px_rgba(139,92,246,0.5)] transition-all duration-500"></div>
                                <div className="h-2 w-2 rounded-full bg-muted"></div>
                            </div>
                        </div>

                        <div className="relative order-1 lg:order-2 flex justify-center items-center">
                            <div className="absolute inset-0 bg-primary/10 rounded-full blur-[120px] -z-10"></div>
                            <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 opacity-[0.03] select-none pointer-events-none">
                                <span className="material-symbols-outlined text-[500px]">language</span>
                            </div>
                            <div className="relative w-full max-w-[500px] aspect-square">
                                <div className="grid grid-cols-2 gap-4 h-full w-full p-4">
                                    <div className="rounded-2xl bg-cover bg-center border border-border relative overflow-hidden group shadow-2xl bg-card" style={{ backgroundImage: "url('https://lh3.googleusercontent.com/aida-public/AB6AXuCk35fUk2AyZLnR7H4Kk0HmgpBai7G0iuDIZPBdahiM2RfTDhRsTr9v2JIOIhcL99bxhsUlOdpVZE_-rsbBrATqFVWWCV91CjOYojMidm5Bf7xoyblfDDlAH7kXSyWPFT61oHfRz4ZyvoNRrW2-VAeiU5aHSYmbRNp-a4PrMSbzDQ6KzYuIm7qNr6EAOe1ZUmStu-D4eTWo8qTwOVw-xXxGofl13GFVO-BLUMhuJY8FVxOpjbkc5Qy57QMBZRm4q8Mj3Pm5rMFV6R0')" }}>
                                        <div className="absolute bottom-3 left-3 px-2 py-1 glass rounded text-[10px] uppercase font-bold tracking-tight text-foreground">Sophie — Paris</div>
                                    </div>
                                    <div className="rounded-2xl bg-cover bg-center border border-border relative overflow-hidden group shadow-2xl bg-card" style={{ backgroundImage: "url('https://lh3.googleusercontent.com/aida-public/AB6AXuBj2P-t75s3U03WJCHSNsp_R1Ebm68G9IhJ7L81B-UqFiHbKIo6JdW1e41PfciC3b8ODAQbyZrVqPiIMwdKMCoSsgSKLEo2JlrtfX36dAH123zMQyrTX_2M-sCbjQcfMTiKIuU_5CrS91CouUKRtTXN8UJkJO55-K30MGtmH0BLf8r8StyeAiw2pOqfpFfD_teXkdFzNZv5facwm7oM0iX2hb51U1jr4d82cMksRg_LO8gidCGcaMSyfsRoCCsVjxQm5CEGd-8PZS0')" }}>
                                        <div className="absolute bottom-3 left-3 px-2 py-1 glass rounded text-[10px] uppercase font-bold tracking-tight text-foreground">Chen — Beijing</div>
                                    </div>
                                    <motion.div
                                        variants={floatingVariants(10, 4, 0.5)}
                                        animate="animate"
                                        className="rounded-2xl bg-cover bg-center border border-border relative overflow-hidden group shadow-2xl bg-card"
                                        style={{ backgroundImage: "url('https://lh3.googleusercontent.com/aida-public/AB6AXuAg-mx5LSqqEaSeKjR2jolGmuNF0o5qu65D0LBe7QWgHTc81MxANR6bpWm3unEEvRVqlPbviHH9AVpswLr2n1Ak-uL_Q9r3HFt3e0aADyZSiusgpX8jZ8kidM6iaOObJ84CKSQIRW2Nm9M6qW4npIOja8rtS-eG7YF5TLoMszxlU--GC6rho9e3xRlovD1cAZie4GuUP96fBEGo1k3yl3K6rdUFc2W5fS0-ZSC7nrFQoCl0RS7Llk2RpqOF_oUfYr72-T1c7TBa6DM')" }}
                                    >
                                        <div className="absolute bottom-3 left-3 px-2 py-1 glass rounded text-[10px] uppercase font-bold tracking-tight text-foreground">James — London</div>
                                    </motion.div>
                                    <motion.div
                                        variants={floatingVariants(8, 3.5, 0)}
                                        animate="animate"
                                        className="rounded-2xl bg-cover bg-center border border-border relative overflow-hidden group shadow-2xl bg-card"
                                        style={{ backgroundImage: "url('https://lh3.googleusercontent.com/aida-public/AB6AXuAmnHfLF_hbi4O6nB34F3c4R5Ao3__P9bcbr9wOMreRQID7WCKE841v2SDCjrmsmg8fnfmzGpXd2ZgyBB2qrOuH_c3UY0drzIwYtZKwZyCsedZWyCxn9-lS8JyCacTwsirDgm_ikmwofeOPvuv06lohnJSX1Nmrk5rhah0IfzCFmH5T1ickGdZR97itaX-fWu07mhnRr1LMhNI1HIiQlFE-zhl22Dpv9V6h3IeYdCpPH4Z11KH4j9EHQJwEg1AJO4yQz9lGj6213uY')" }}
                                    >
                                        <div className="absolute bottom-3 left-3 px-2 py-1 glass rounded text-[10px] uppercase font-bold tracking-tight text-foreground">Elena — Madrid</div>
                                    </motion.div>
                                </div>
                                <motion.div
                                    variants={floatingVariants(15, 5, 1)}
                                    animate="animate"
                                    className="absolute -top-4 left-4 glass rounded-xl px-4 py-3 flex items-center gap-3 shadow-2xl border-primary/20"
                                >
                                    <div className="size-8 rounded-full bg-primary/20 flex items-center justify-center">
                                        <span className="material-symbols-outlined text-primary text-[18px]">mic</span>
                                    </div>
                                    <div>
                                        <p className="text-[9px] text-primary font-bold uppercase tracking-wider leading-none mb-1">Detecting French</p>
                                        <p className="text-sm font-bold text-foreground leading-none">Bonjour tout le monde!</p>
                                    </div>
                                </motion.div>
                                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[110%] h-auto z-20 pointer-events-none">
                                    <div className="flex items-center justify-between px-2">
                                        <motion.div
                                            variants={floatingVariants(12, 4.5, 0.2)}
                                            animate="animate"
                                            className="glass p-3 rounded-lg shadow-2xl flex flex-col gap-1 border-primary/30 min-w-[100px] pointer-events-auto"
                                        >
                                            <p className="text-[8px] text-primary font-bold uppercase tracking-tighter leading-none">English</p>
                                            <p className="text-xs font-medium italic text-foreground leading-none">"Hello everyone!"</p>
                                        </motion.div>
                                        <div className="flex-1 px-4 relative">
                                            <div className="h-[2px] w-full bg-gradient-to-r from-transparent via-[#8B5CF6] to-transparent"></div>
                                            <motion.div
                                                animate={{
                                                    scale: [1, 1.2, 1],
                                                    opacity: [0.8, 1, 0.8]
                                                }}
                                                transition={{
                                                    duration: 2,
                                                    repeat: Infinity,
                                                    ease: "easeInOut"
                                                }}
                                                className="absolute -top-5 left-1/2 -translate-x-1/2 bg-primary rounded-full p-1.5 border-4 border-background shadow-lg shadow-primary/40"
                                            >
                                                <span className="material-symbols-outlined text-white text-[14px] leading-none">bolt</span>
                                            </motion.div>
                                        </div>
                                        <motion.div
                                            variants={floatingVariants(10, 4.2, 0.8)}
                                            animate="animate"
                                            className="glass p-3 rounded-lg shadow-2xl flex flex-col gap-1 border-primary/30 min-w-[100px] pointer-events-auto"
                                        >
                                            <p className="text-[8px] text-primary font-bold uppercase tracking-tighter leading-none">Mandarin</p>
                                            <p className="text-xs font-medium italic text-foreground leading-none">"你好，大家!"</p>
                                        </motion.div>
                                    </div>
                                </div>
                                <div className="absolute -bottom-6 right-10 flex gap-2">
                                    <motion.div
                                        variants={floatingVariants(6, 3, 0.3)}
                                        animate="animate"
                                        className="glass px-4 py-2.5 rounded-xl flex items-center gap-2 shadow-xl"
                                    >
                                        <span className="material-symbols-outlined text-primary text-[18px]">closed_caption</span>
                                        <span className="text-[11px] font-bold uppercase tracking-tight text-foreground">Live Captions</span>
                                    </motion.div>
                                    <motion.div
                                        variants={floatingVariants(5, 3.2, 0.6)}
                                        animate="animate"
                                        className="glass px-4 py-2.5 rounded-xl flex items-center gap-2 shadow-xl"
                                    >
                                        <span className="material-symbols-outlined text-primary text-[18px]">record_voice_over</span>
                                        <span className="text-[11px] font-bold uppercase tracking-tight text-foreground">AI Dubbing</span>
                                    </motion.div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
};

export default Slide2;
