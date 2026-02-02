"use client";

import { useState, useEffect } from "react";
import { searchUser, addContact, fetchContacts, removeContact } from "@/app/lib/api";
import { motion, AnimatePresence } from "framer-motion";

export default function ContactsPage() {
    const [searchEmail, setSearchEmail] = useState("");
    const [foundUser, setFoundUser] = useState<any>(null);
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);
    const [isAddModalOpen, setIsAddModalOpen] = useState(false);
    const [contacts, setContacts] = useState<any[]>([]);

    useEffect(() => {
        const token = localStorage.getItem("access_token");
        if (token) {
            fetchContacts(token).then(setContacts).catch(console.error);
        }
    }, [isAddModalOpen]);

    const getInitials = (name?: string) => {
        if (!name) return "U";
        return name.split(" ").map(n => n[0]).join("").toUpperCase().substring(0, 2);
    };

    const handleSearch = async () => {
        if (!searchEmail) return;
        setLoading(true);
        setError("");
        setFoundUser(null);

        try {
            const token = localStorage.getItem("access_token");
            if (!token) throw new Error("Not authenticated");
            const users = await searchUser(searchEmail, token);
            if (users && users.length > 0) {
                setFoundUser(users[0]);
            } else {
                setError("Utilisateur non trouvé");
            }
        } catch (err: any) {
            setError(err.message || "Utilisateur non présent");
        } finally {
            setLoading(false);
        }
    };

    const handleAddContact = async () => {
        if (!foundUser) return;
        setLoading(true);
        try {
            const token = localStorage.getItem("access_token");
            if (!token) throw new Error("Not authenticated");
            await addContact(foundUser.id, token);

            // Add to local state for now
            setContacts([...contacts, {
                full_name: foundUser.full_name,
                email: foundUser.email,
                id: foundUser.id
            }]);

            setIsAddModalOpen(false);
            setSearchEmail("");
            setFoundUser(null);
        } catch (err: any) {
            setError(err.message || "Failed to add contact");
        } finally {
            setLoading(false);
        }
    };

    const handleDeleteContact = async (id: string) => {
        if (!confirm("Remove this contact?")) return;
        try {
            const token = localStorage.getItem("access_token");
            if (token) {
                await removeContact(id, token);
                setContacts(contacts.filter(c => (c.id || c._id) !== id));
            }
        } catch (err) {
            console.error("Failed to delete contact", err);
        }
    };

    return (
        <div className="p-8">
            <header className="mb-8 flex justify-between items-center">
                <div>
                    <h1 className="text-3xl font-bold">Contacts</h1>
                    <p className="text-slate-500 dark:text-slate-400 mt-1">Manage your team and frequent collaborators.</p>
                </div>
                <button
                    onClick={() => setIsAddModalOpen(true)}
                    className="bg-primary text-white px-6 py-2 rounded-xl font-bold shadow-lg shadow-primary/25"
                >
                    + Add Contact
                </button>
            </header>

            <div className="bg-white dark:bg-card border border-slate-200 dark:border-slate-800 rounded-2xl overflow-hidden shadow-sm">
                <div className="divide-y divide-slate-100 dark:divide-slate-800">
                    {contacts.map((contact, i) => (
                        <div key={i} className="p-4 flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800/30 transition-colors cursor-pointer">
                            <div className="flex items-center">
                                <div className={`w-12 h-12 bg-primary rounded-full flex items-center justify-center text-white font-bold mr-4 shadow-inner`}>
                                    {getInitials(contact.full_name)}
                                </div>
                                <div>
                                    <h3 className="font-bold">{contact.full_name}</h3>
                                    <p className="text-sm text-slate-500">{contact.email}</p>
                                </div>
                            </div>
                            <div className="flex items-center space-x-2">
                                <button className="p-2 text-slate-400 hover:text-primary transition-colors">
                                    <span className="material-icons-round">video_call</span>
                                </button>
                                <button className="p-2 text-slate-400 hover:text-primary transition-colors">
                                    <span className="material-icons-round">message</span>
                                </button>
                                <button
                                    onClick={() => handleDeleteContact(contact.id || contact._id)}
                                    className="p-2 text-slate-400 hover:text-red-500 transition-colors"
                                >
                                    <span className="material-icons-round">delete</span>
                                </button>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            {/* Add Contact Modal */}
            <AnimatePresence>
                {isAddModalOpen && (
                    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                        <motion.div
                            initial={{ scale: 0.9, opacity: 0 }}
                            animate={{ scale: 1, opacity: 1 }}
                            exit={{ scale: 0.9, opacity: 0 }}
                            className="bg-white dark:bg-slate-900 w-full max-w-md rounded-3xl p-8 shadow-2xl border border-white/10"
                        >
                            <div className="flex justify-between items-center mb-6">
                                <h2 className="text-xl font-bold">Add New Contact</h2>
                                <button onClick={() => setIsAddModalOpen(false)} className="text-slate-500">
                                    <span className="material-icons-round">close</span>
                                </button>
                            </div>

                            <div className="space-y-4">
                                <div className="space-y-2">
                                    <label className="text-xs font-bold text-slate-400 uppercase">User Email</label>
                                    <div className="flex gap-2">
                                        <input
                                            type="email"
                                            value={searchEmail}
                                            onChange={(e) => setSearchEmail(e.target.value)}
                                            placeholder="Enter user email..."
                                            className="flex-1 bg-slate-100 dark:bg-slate-800 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none"
                                        />
                                        <button
                                            onClick={handleSearch}
                                            disabled={loading}
                                            className="bg-primary text-white px-4 rounded-xl disabled:opacity-50"
                                        >
                                            <span className="material-icons-round">search</span>
                                        </button>
                                    </div>
                                </div>

                                {loading && (
                                    <div className="flex justify-center p-4">
                                        <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-primary"></div>
                                    </div>
                                )}

                                {error && (
                                    <div className="p-4 bg-red-500/10 border border-red-500/20 rounded-xl">
                                        <p className="text-red-500 text-sm font-medium">{error}</p>
                                    </div>
                                )}

                                {foundUser && (
                                    <div className="p-4 bg-emerald-500/10 border border-emerald-500/20 rounded-xl flex items-center justify-between">
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 bg-emerald-500 rounded-full flex items-center justify-center text-white font-bold">
                                                {foundUser.full_name?.charAt(0)}
                                            </div>
                                            <div>
                                                <p className="font-bold text-sm text-white">{foundUser.full_name}</p>
                                                <p className="text-xs text-slate-400">{foundUser.email}</p>
                                            </div>
                                        </div>
                                        <button
                                            onClick={handleAddContact}
                                            className="bg-emerald-500 text-white px-4 py-2 rounded-lg text-xs font-bold shadow-lg shadow-emerald-500/20"
                                        >
                                            Add
                                        </button>
                                    </div>
                                )}
                            </div>
                        </motion.div>
                    </div>
                )}
            </AnimatePresence>
        </div>
    );
}
