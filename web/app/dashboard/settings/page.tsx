"use client";

export default function SettingsPage() {
    return (
        <div className="p-8">
            <header className="mb-8">
                <h1 className="text-3xl font-bold">Settings</h1>
                <p className="text-slate-500 dark:text-slate-400 mt-1">Configure your account and application preferences.</p>
            </header>

            <div className="space-y-6 max-w-2xl">
                <section className="bg-white dark:bg-card border border-slate-200 dark:border-slate-800 rounded-2xl p-6 shadow-sm">
                    <h2 className="text-lg font-bold mb-4 flex items-center">
                        <span className="material-icons-round mr-2 text-primary">person</span> Profile Information
                    </h2>
                    <div className="space-y-4">
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-xs font-bold text-slate-400 uppercase mb-1">Full Name</label>
                                <input type="text" className="w-full bg-slate-50 dark:bg-slate-900 border-slate-200 dark:border-slate-800 rounded-xl px-4 py-2 text-sm" defaultValue="John Doe" />
                            </div>
                            <div>
                                <label className="block text-xs font-bold text-slate-400 uppercase mb-1">Email Address</label>
                                <input type="email" className="w-full bg-slate-50 dark:bg-slate-900 border-slate-200 dark:border-slate-800 rounded-xl px-4 py-2 text-sm" defaultValue="john@example.com" disabled />
                            </div>
                        </div>
                        <button className="bg-primary text-white px-6 py-2 rounded-xl font-bold text-sm">Save Changes</button>
                    </div>
                </section>

                <section className="bg-white dark:bg-card border border-slate-200 dark:border-slate-800 rounded-2xl p-6 shadow-sm">
                    <h2 className="text-lg font-bold mb-4 flex items-center">
                        <span className="material-icons-round mr-2 text-primary">dark_mode</span> Appearance
                    </h2>
                    <div className="flex items-center justify-between">
                        <div>
                            <p className="font-semibold">Dark Mode</p>
                            <p className="text-xs text-slate-500">Switch between light and dark themes.</p>
                        </div>
                        <div className="w-12 h-6 bg-primary rounded-full relative cursor-pointer">
                            <div className="absolute right-1 top-1 w-4 h-4 bg-white rounded-full"></div>
                        </div>
                    </div>
                </section>

                <section className="bg-white dark:bg-card border border-slate-200 dark:border-slate-800 rounded-2xl p-6 shadow-sm">
                    <h2 className="text-lg font-bold mb-4 flex items-center">
                        <span className="material-icons-round mr-2 text-red-500">dangerous</span> Danger Zone
                    </h2>
                    <p className="text-sm text-slate-500 mb-4">Permanently delete your account and all associated meeting data.</p>
                    <button className="border border-red-500 text-red-500 hover:bg-red-500 hover:text-white px-6 py-2 rounded-xl font-bold text-sm transition-colors">Delete Account</button>
                </section>
            </div>
        </div>
    );
}
