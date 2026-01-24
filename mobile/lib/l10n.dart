import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome': 'Let\'s get to know each other',
      'onboarding_sub1': 'Whisper learns your voice so it can follow the conversation and give you prompts that fit your goals, your interests, and the context.',
      'record_voice': 'Record voice sample',
      'voice_sample_hint': 'To help filter out the other noise, we\'ll need a short sample of your voice.',
      'patterns': 'Patterns',
      'rhythm': 'Rhythm',
      'frequency': 'Frequency',
      'tone': 'Tone',
      'smart_prompts': 'Get real-time prompts through your notifications',
      'smart_prompts_sub': 'Turn on push notifications to get discreet conversation prompts on your lock screen during meetings.',
      'continue': 'Continue',
      'back': 'Back',
      'experience_intelligence': 'Experience Intelligence',
      'experience_intelligence_sub': 'Elevate your video meetings with real-time AI features that help you focus on the conversation, not the notes.',
      'live_translation': 'Live Translation',
      'smart_notes': 'Smart Notes',
      'ai_transcription': 'AI Transcription',
      'get_started': 'Get Started',
      'skip': 'Skip for now',
      'settings': 'Settings',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'today_meetings': 'TODAY\'S MEETINGS',
      'history': 'History',
      'schedule': 'Schedule',
      'create': 'Create',
      'welcome_hi': 'Hi, Alison',
      'ready_session': 'Ready for your next session?',
      'create_meeting': 'Create Meeting',
      'meeting_title_label': 'MEETING TITLE',
      'meeting_type_label': 'MEETING TYPE',
      'video': 'Video',
      'ai_assisted': 'AI Assisted',
      'audio': 'Audio',
      'scheduled_meetings': 'Scheduled Meetings',
      'see_all': 'See all',
      'search_hint': 'Search meetings or summaries...',
      'recent_meetings': 'RECENT MEETINGS',
      'this_week': 'This Week',
      'ai_summary': 'AI SUMMARY',
      'no_summary': 'NO SUMMARY',
      'invite_participants': 'Invite Participants',
      'meeting_link_label_caps': 'MEETING LINK',
      'copy_link': 'Copy Link',
      'frequent_contacts': 'Frequent Contacts',
      'invite': 'Invite',
      'share_via': 'Share Via',
      'individuals': 'Individuals',
      'groups': 'Groups',
      'members': 'members',
      'launch': 'Launch',
      'launch_meeting': 'Launch Meeting',
      'pre_meeting_title': 'Weekly Sync - Marketing',
      'starting_in': 'Starting in 2 mins',
      'mirroring_on': 'Mirroring On',
      'active': 'Active',
      'camera_on': 'Camera On',
      'ai_multi_lang': 'AI Multi-language Transcription',
      'enable_live_transcription': 'Enable Live AI Transcription',
      'real_time_captions': 'Real-time captions as you speak',
      'translate_to': 'Translate to',
      'test_speaker': 'Test Speaker',
      'join_meeting': 'Join Meeting',
      'development_team': 'Development Team',

    },
    'fr': {
      'welcome': 'Apprenons à nous connaître',
      'onboarding_sub1': 'Whisper apprend votre voix pour pouvoir suivre la conversation et vous proposer des suggestions adaptées à vos objectifs, vos intérêts et au contexte.',
      'record_voice': 'Enregistrer un échantillon vocal',
      'voice_sample_hint': 'Pour aider à filtrer les bruits ambiants, nous aurons besoin d\'un court échantillon de votre voix.',
      'patterns': 'Modèles',
      'rhythm': 'Rythme',
      'frequency': 'Fréquence',
      'tone': 'Tonalité',
      'smart_prompts': 'Recevez des suggestions en temps réel via vos notifications',
      'smart_prompts_sub': 'Activez les notifications push pour obtenir des suggestions de conversation discrètes sur votre écran de verrouillage pendant les réunions.',
      'continue': 'Continuer',
      'back': 'Retour',
      'experience_intelligence': 'L\'Intelligence en Action',
      'experience_intelligence_sub': 'Améliorez vos réunions vidéo avec des fonctionnalités d\'IA en temps réel qui vous permettent de vous concentrer sur la conversation, pas sur les notes.',
      'live_translation': 'Traduction en direct',
      'smart_notes': 'Notes intelligentes',
      'ai_transcription': 'Transcription IA',
      'get_started': 'Commencer',
      'skip': 'Passer pour le moment',
      'settings': 'Paramètres',
      'language': 'Langue',
      'dark_mode': 'Mode Sombre',
      'today_meetings': 'RÉUNIONS D\'AUJOURD\'HUI',
      'history': 'Historique',
      'schedule': 'Calendrier',
      'create': 'Créer',
      'welcome_hi': 'Salut, Alison',
      'ready_session': 'Prêt pour votre prochaine session ?',
      'create_meeting': 'Créer une réunion',
      'meeting_title_label': 'TITRE DE LA RÉUNION',
      'meeting_type_label': 'TYPE DE RÉUNION',
      'video': 'Vidéo',
      'ai_assisted': 'Assisté par IA',
      'audio': 'Audio',
      'scheduled_meetings': 'Réunions programmées',
      'see_all': 'Voir tout',
      'search_hint': 'Rechercher des réunions ou des résumés...',
      'recent_meetings': 'RÉUNIONS RÉCENTES',
      'this_week': 'Cette semaine',
      'ai_summary': 'RÉSUMÉ IA',
      'no_summary': 'AUCUN RÉSUMÉ',
      'invite_participants': 'Inviter des participants',
      'meeting_link_label_caps': 'LIEN DE LA RÉUNION',
      'copy_link': 'Copier le lien',
      'frequent_contacts': 'Contacts Fréquents',
      'invite': 'Inviter',
      'share_via': 'Partager via',
      'individuals': 'Individus',
      'groups': 'Groupes',
      'members': 'membres',
      'launch': 'Lancer',
      'launch_meeting': 'Lancer la réunion',
      'pre_meeting_title': 'Synchro Hebdo - Marketing',
      'starting_in': 'Commence dans 2 min',
      'mirroring_on': 'Miroir Activé',
      'active': 'Actif',
      'camera_on': 'Caméra Activée',
      'ai_multi_lang': 'Transcription IA Multi-langue',
      'enable_live_transcription': 'Activer la Transcription IA',
      'real_time_captions': 'Sous-titres en temps réel',
      'translate_to': 'Traduire en',
      'test_speaker': 'Tester le haut-parleur',
      'join_meeting': 'Rejoindre la réunion',
      'development_team': 'Équipe de développement',

    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
