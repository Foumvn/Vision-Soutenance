// Translation system for the application
const translations = {
    'en': {
        // Navigation
        'nav_create': 'Create',
        'nav_schedule': 'Schedule',
        'nav_history': 'History',
        'nav_settings': 'Settings',

        // Create Page
        'create_title': 'Create Meeting',
        'create_greeting': 'Hi, Alison',
        'create_subtitle': 'Ready for your next session?',
        'create_meeting_title': 'Meeting Title',
        'create_meeting_title_placeholder': 'e.g. Weekly Sync',
        'create_meeting_type': 'Meeting Type',
        'create_type_video': 'Video',
        'create_type_ai': 'AI Assisted',
        'create_type_audio': 'Audio',
        'create_button': 'Create Meeting',
        'create_scheduled_meetings': 'Scheduled Meetings',
        'create_see_all': 'See all',
        'create_design_sprint': 'Design Sprint',
        'create_monthly_recap': 'Monthly Recap',
        'create_today': 'Today',
        'create_tomorrow': 'Tomorrow',
        'create_participants': 'participants',

        // Schedule Page
        'schedule_title': 'Schedule',
        'schedule_todays_meetings': "Today's Meetings",
        'schedule_events': 'Events',
        'schedule_strategy': 'Strategy Alignment',
        'schedule_design': 'Design Critique',
        'schedule_ai_workshop': 'AI Integration Workshop',
        'schedule_upcoming': 'Upcoming',
        'schedule_pending': 'Pending',
        'schedule_details': 'Details',
        'schedule_ai_insight': 'AI Insight',
        'schedule_mon': 'MON',
        'schedule_tue': 'TUE',
        'schedule_wed': 'WED',
        'schedule_thu': 'THU',
        'schedule_fri': 'FRI',
        'schedule_sat': 'SAT',
        'schedule_sun': 'SUN',

        // History Page
        'history_title': 'History',
        'history_search_placeholder': 'Search meetings or summaries...',
        'history_recent_meetings': 'Recent Meetings',
        'history_this_week': 'This Week',
        'history_project_sync': 'Project Sync: Alpha',
        'history_weekly_review': 'Weekly Product Review',
        'history_backend': 'Backend Architecture',
        'history_investor': 'Investor Pitch Deck',
        'history_yesterday': 'Yesterday',
        'history_ai_summary': 'AI Summary',
        'history_no_summary': 'No Summary',

        // Settings Page
        'settings_title': 'Settings',
        'settings_account': 'Account',
        'settings_profile': 'Profile',
        'settings_notifications': 'Notifications',
        'settings_meeting_settings': 'Meeting Settings',
        'settings_ai_transcription': 'AI Transcription',
        'settings_background_blur': 'Background Blur',
        'settings_app_preferences': 'App Preferences',
        'settings_dark_mode': 'Dark Mode',
        'settings_language': 'Language',
        'settings_sign_out': 'Sign Out',
        'settings_full_name': 'Full Name',
        'settings_email': 'Email',
        'settings_push_notifications': 'Push Notifications',
        'settings_email_digest': 'Email Digest',

        // Common
        'common_am': 'AM',
        'common_pm': 'PM',
    },
    'fr': {
        // Navigation
        'nav_create': 'Créer',
        'nav_schedule': 'Agenda',
        'nav_history': 'Historique',
        'nav_settings': 'Paramètres',

        // Create Page
        'create_title': 'Créer une Réunion',
        'create_greeting': 'Bonjour, Alison',
        'create_subtitle': 'Prêt pour votre prochaine session ?',
        'create_meeting_title': 'Titre de la Réunion',
        'create_meeting_title_placeholder': 'ex. Sync Hebdomadaire',
        'create_meeting_type': 'Type de Réunion',
        'create_type_video': 'Vidéo',
        'create_type_ai': 'Assisté par IA',
        'create_type_audio': 'Audio',
        'create_button': 'Créer la Réunion',
        'create_scheduled_meetings': 'Réunions Planifiées',
        'create_see_all': 'Voir tout',
        'create_design_sprint': 'Sprint Design',
        'create_monthly_recap': 'Récap Mensuel',
        'create_today': "Aujourd'hui",
        'create_tomorrow': 'Demain',
        'create_participants': 'participants',

        // Schedule Page
        'schedule_title': 'Agenda',
        'schedule_todays_meetings': "Réunions d'Aujourd'hui",
        'schedule_events': 'Événements',
        'schedule_strategy': 'Alignement Stratégique',
        'schedule_design': 'Critique Design',
        'schedule_ai_workshop': "Atelier d'Intégration IA",
        'schedule_upcoming': 'À venir',
        'schedule_pending': 'En attente',
        'schedule_details': 'Détails',
        'schedule_ai_insight': 'Aperçu IA',
        'schedule_mon': 'LUN',
        'schedule_tue': 'MAR',
        'schedule_wed': 'MER',
        'schedule_thu': 'JEU',
        'schedule_fri': 'VEN',
        'schedule_sat': 'SAM',
        'schedule_sun': 'DIM',

        // History Page
        'history_title': 'Historique',
        'history_search_placeholder': 'Rechercher des réunions ou résumés...',
        'history_recent_meetings': 'Réunions Récentes',
        'history_this_week': 'Cette Semaine',
        'history_project_sync': 'Sync Projet : Alpha',
        'history_weekly_review': 'Revue Produit Hebdomadaire',
        'history_backend': 'Architecture Backend',
        'history_investor': 'Présentation Investisseurs',
        'history_yesterday': 'Hier',
        'history_ai_summary': 'Résumé IA',
        'history_no_summary': 'Pas de Résumé',

        // Settings Page
        'settings_title': 'Paramètres',
        'settings_account': 'Compte',
        'settings_profile': 'Profil',
        'settings_notifications': 'Notifications',
        'settings_meeting_settings': 'Paramètres de Réunion',
        'settings_ai_transcription': 'Transcription IA',
        'settings_background_blur': 'Flou d\'Arrière-plan',
        'settings_app_preferences': 'Préférences de l\'App',
        'settings_dark_mode': 'Mode Sombre',
        'settings_language': 'Langue',
        'settings_sign_out': 'Se Déconnecter',
        'settings_full_name': 'Nom Complet',
        'settings_email': 'Email',
        'settings_push_notifications': 'Notifications Push',
        'settings_email_digest': 'Digest Email',

        // Common
        'common_am': 'AM',
        'common_pm': 'PM',
    },
    'es': {
        // Navigation
        'nav_create': 'Crear',
        'nav_schedule': 'Agenda',
        'nav_history': 'Historial',
        'nav_settings': 'Ajustes',

        // Create Page
        'create_title': 'Crear Reunión',
        'create_greeting': 'Hola, Alison',
        'create_subtitle': '¿Listo para tu próxima sesión?',
        'create_meeting_title': 'Título de la Reunión',
        'create_meeting_title_placeholder': 'ej. Sincronización Semanal',
        'create_meeting_type': 'Tipo de Reunión',
        'create_type_video': 'Video',
        'create_type_ai': 'Asistido por IA',
        'create_type_audio': 'Audio',
        'create_button': 'Crear Reunión',
        'create_scheduled_meetings': 'Reuniones Programadas',
        'create_see_all': 'Ver todo',
        'create_design_sprint': 'Sprint de Diseño',
        'create_monthly_recap': 'Resumen Mensual',
        'create_today': 'Hoy',
        'create_tomorrow': 'Mañana',
        'create_participants': 'participantes',

        // Schedule Page
        'schedule_title': 'Agenda',
        'schedule_todays_meetings': 'Reuniones de Hoy',
        'schedule_events': 'Eventos',
        'schedule_strategy': 'Alineación Estratégica',
        'schedule_design': 'Crítica de Diseño',
        'schedule_ai_workshop': 'Taller de Integración IA',
        'schedule_upcoming': 'Próximo',
        'schedule_pending': 'Pendiente',
        'schedule_details': 'Detalles',
        'schedule_ai_insight': 'Perspectiva IA',
        'schedule_mon': 'LUN',
        'schedule_tue': 'MAR',
        'schedule_wed': 'MIÉ',
        'schedule_thu': 'JUE',
        'schedule_fri': 'VIE',
        'schedule_sat': 'SÁB',
        'schedule_sun': 'DOM',

        // History Page
        'history_title': 'Historial',
        'history_search_placeholder': 'Buscar reuniones o resúmenes...',
        'history_recent_meetings': 'Reuniones Recientes',
        'history_this_week': 'Esta Semana',
        'history_project_sync': 'Sincronización Proyecto: Alpha',
        'history_weekly_review': 'Revisión Semanal del Producto',
        'history_backend': 'Arquitectura Backend',
        'history_investor': 'Presentación a Inversores',
        'history_yesterday': 'Ayer',
        'history_ai_summary': 'Resumen IA',
        'history_no_summary': 'Sin Resumen',

        // Settings Page
        'settings_title': 'Ajustes',
        'settings_account': 'Cuenta',
        'settings_profile': 'Perfil',
        'settings_notifications': 'Notificaciones',
        'settings_meeting_settings': 'Ajustes de Reunión',
        'settings_ai_transcription': 'Transcripción IA',
        'settings_background_blur': 'Desenfoque de Fondo',
        'settings_app_preferences': 'Preferencias de la App',
        'settings_dark_mode': 'Modo Oscuro',
        'settings_language': 'Idioma',
        'settings_sign_out': 'Cerrar Sesión',
        'settings_full_name': 'Nombre Completo',
        'settings_email': 'Correo',
        'settings_push_notifications': 'Notificaciones Push',
        'settings_email_digest': 'Resumen por Correo',

        // Common
        'common_am': 'AM',
        'common_pm': 'PM',
    }
};

// Language mapping
const languageMap = {
    'English (US)': 'en',
    'French (FR)': 'fr',
    'Spanish (ES)': 'es'
};

// Get current language from localStorage or default to English
function getCurrentLanguage() {
    const savedLang = localStorage.getItem('language') || 'English (US)';
    return languageMap[savedLang] || 'en';
}

// Get translation for a key
function t(key) {
    const lang = getCurrentLanguage();
    return translations[lang][key] || translations['en'][key] || key;
}

// Apply translations to the page
function applyTranslations() {
    const elements = document.querySelectorAll('[data-i18n]');
    elements.forEach(element => {
        const key = element.getAttribute('data-i18n');
        const translation = t(key);

        // Check if it's an input with placeholder
        if (element.tagName === 'INPUT' && element.hasAttribute('placeholder')) {
            element.setAttribute('placeholder', translation);
        }
        // For other elements, replace text content
        else {
            element.textContent = translation;
        }
    });
}

// Initialize translations when DOM is loaded
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', applyTranslations);
} else {
    applyTranslations();
}
