"use client";

import { useState } from "react";
import Link from "next/link";
import { motion, AnimatePresence } from "framer-motion";
import Slide1 from "@/components/onboarding/Slide1";
import Slide2 from "@/components/onboarding/Slide2";
import Slide3 from "@/components/onboarding/Slide3";
import { ThemeToggle } from "@/components/ThemeToggle";

export default function Onboarding() {
  const [current, setCurrent] = useState(0);
  const [direction, setDirection] = useState(0);

  const nextSlide = () => {
    if (current < 2) {
      setDirection(1);
      setCurrent(current + 1);
    } else {
      window.location.href = "/login";
    }
  };

  const prevSlide = () => {
    if (current > 0) {
      setDirection(-1);
      setCurrent(current - 1);
    }
  };

  return (
    <div className="relative min-h-screen bg-background text-foreground selection:bg-primary/30 flex flex-col font-sans transition-colors duration-300">
      {/* Static Header */}
      <nav className="fixed top-0 w-full z-50 border-b border-border bg-background/80 backdrop-blur-md">
        <div className="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 bg-primary rounded-xl flex items-center justify-center shadow-lg shadow-primary/20">
              <span className="material-icons text-white">blur_on</span>
            </div>
            <span className="font-extrabold text-xl tracking-tight">WHISPER AI</span>
          </div>
          <div className="flex items-center gap-8">
            <a className="hidden md:block text-sm font-medium hover:text-primary transition-colors" href="#">How it works</a>
            <a className="hidden md:block text-sm font-medium hover:text-primary transition-colors" href="#">Enterprise</a>
            <Link href="/login">
              <button className="px-6 py-2.5 rounded-full border border-border text-sm font-semibold hover:bg-foreground/5 transition-all">
                Sign In
              </button>
            </Link>
            <ThemeToggle />
          </div>
        </div>
      </nav>

      {/* Main Content Area - Only this part animates */}
      <main className="flex-1 relative mt-20 flex flex-col">
        <AnimatePresence mode="wait" custom={direction}>
          <motion.div
            key={current}
            custom={direction}
            initial={{ opacity: 0, x: direction > 0 ? 100 : -100 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: direction > 0 ? -100 : 100 }}
            transition={{
              type: "spring",
              stiffness: 300,
              damping: 30,
              opacity: { duration: 0.3 }
            }}
            className="flex-1 flex flex-col"
          >
            {current === 0 && <Slide1 onNext={nextSlide} />}
            {current === 1 && <Slide2 onNext={nextSlide} onBack={prevSlide} />}
            {current === 2 && <Slide3 onNext={nextSlide} onBack={prevSlide} />}
          </motion.div>
        </AnimatePresence>
      </main >

      {/* Static Footer */}
      <footer className="w-full py-12 border-t border-border bg-background mt-auto">
        <div className="max-w-7xl mx-auto px-6">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            <div className="flex flex-col items-center text-center space-y-2 opacity-50 hover:opacity-100 transition-opacity cursor-default">
              <span className="material-icons text-primary text-3xl">psychology</span>
              <span className="text-xs font-bold uppercase tracking-widest">Cognitive Engine</span>
            </div>
            <div className="flex flex-col items-center text-center space-y-2 opacity-50 hover:opacity-100 transition-opacity cursor-default">
              <span className="material-icons text-primary text-3xl">security</span>
              <span className="text-xs font-bold uppercase tracking-widest">Enterprise Privacy</span>
            </div>
            <div className="flex flex-col items-center text-center space-y-2 opacity-50 hover:opacity-100 transition-opacity cursor-default">
              <span className="material-icons text-primary text-3xl">hub</span>
              <span className="text-xs font-bold uppercase tracking-widest">Global Connect</span>
            </div>
            <div className="flex flex-col items-center text-center space-y-2 opacity-50 hover:opacity-100 transition-opacity cursor-default">
              <span className="material-icons text-primary text-3xl">bolt</span>
              <span className="text-xs font-bold uppercase tracking-widest">Ultra Low Latency</span>
            </div>
          </div>
        </div>
      </footer >
    </div >
  );
}
