"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { motion } from "framer-motion";
import { ThemeToggle } from "../ThemeToggle";

interface SidebarProps {
    user: {
        email: string;
        full_name?: string;
    } | null;
}

export default function Sidebar({ user }: SidebarProps) {
    const pathname = usePathname();
    const router = useRouter();

    const navItems = [
        { name: "Dashboard", icon: "dashboard", href: "/dashboard" },
        { name: "Calendar", icon: "calendar_today", href: "/dashboard/calendar" },
        { name: "Contacts", icon: "contacts", href: "/dashboard/contacts" },
        { name: "AI Assistant", icon: "psychology", href: "/dashboard/ai" },
        { name: "Settings", icon: "settings", href: "/dashboard/settings" },
    ];

    const handleLogout = () => {
        localStorage.removeItem("access_token");
        router.push("/login");
    };

    return (
        <aside className="w-64 border-r border-slate-200 dark:border-slate-800 flex flex-col glass h-screen sticky top-0 hidden lg:flex">
            <div className="p-6 flex items-center justify-between">
                <Link href="/dashboard" className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-primary rounded-xl flex items-center justify-center shadow-lg shadow-primary/20">
                        <span className="material-icons-round text-white">videocam</span>
                    </div>
                    <span className="text-xl font-bold tracking-tight">V-Sync AI</span>
                </Link>
                <ThemeToggle />
            </div>

            <nav className="flex-1 px-4 space-y-1 mt-4">
                {navItems.map((item) => {
                    const isActive = pathname === item.href;
                    return (
                        <Link
                            key={item.name}
                            href={item.href}
                            className={`flex items-center px-4 py-3 rounded-xl transition-all duration-200 group ${isActive
                                ? "bg-primary/10 text-primary shadow-sm"
                                : "text-slate-500 hover:text-primary dark:text-slate-400 dark:hover:text-white hover:bg-slate-50 dark:hover:bg-slate-800"
                                }`}
                        >
                            <span className="material-icons-round mr-3">{item.icon}</span>
                            <span className="font-medium">{item.name}</span>
                        </Link>
                    );
                })}
            </nav>

            <div className="p-4 border-t border-slate-200 dark:border-slate-800">
                <div
                    className="flex items-center p-3 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer transition-colors"
                    onClick={handleLogout}
                >
                    <img
                        alt="User Profile"
                        className="w-10 h-10 rounded-full object-cover ring-2 ring-primary/20"
                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuBpBuakP_YIz4V1K1p1wv7YU2b56-V5h9N9aKNdU3w_yEI0ZcKvsocaFmD8pqqtdmidPnUTJLckoh7vWGoqu-7E_oumffmshizDke9ZmI3oiNtux15ijTyCOa8LLfLz5ASPX_64iMnYrEeEjbIqKg4fYmhFtyX5BUTczuXjS-EnIfhIA4_ICYZuH4A5DFPIPSw4tqRy2ejikfBjyYb5MmC1y068S7KhkeVOeUq0hsk2JzuXBuCDNfpooDIfhBRdwJWu2unPuyZMQJ0"
                    />
                    <div className="ml-3 overflow-hidden">
                        <p className="text-sm font-semibold truncate">{user?.full_name || "User"}</p>
                        <p className="text-xs text-slate-500 truncate">Pro Account</p>
                    </div>
                    <span className="material-icons-round text-slate-400 ml-auto text-sm">logout</span>
                </div>
            </div>
        </aside>
    );
}
