"use client";

export default function CalendarPage() {
    return (
        <div className="p-8">
            <header className="mb-8">
                <h1 className="text-3xl font-bold">Calendar</h1>
                <p className="text-slate-500 dark:text-slate-400 mt-1">Schedule and manage your upcoming meetings.</p>
            </header>

            <div className="bg-white dark:bg-card border border-slate-200 dark:border-slate-800 rounded-2xl p-8 flex flex-col items-center justify-center min-h-[400px]">
                <div className="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center text-primary mb-4">
                    <span className="material-icons-round text-3xl">calendar_today</span>
                </div>
                <h2 className="text-xl font-bold mb-2">Calendar Integration</h2>
                <p className="text-slate-500 text-center max-w-md">
                    Synchronize your Google Calendar or Outlook to manage all your meetings directly from V-Sync AI.
                </p>
                <button className="mt-6 bg-primary text-white px-8 py-3 rounded-xl font-bold shadow-lg shadow-primary/25">Connect Calendar</button>
            </div>
        </div>
    );
}
