import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';
import 'api_service.dart';

class MeetingProvider with ChangeNotifier {
  bool _isConnecting = false;
  bool get isConnecting => _isConnecting;

  Room? _room;
  Room? get room => _room;

  String? _roomName;
  String? get roomName => _roomName;

  Future<void> joinMeeting(String meetingName, String userName) async {
    _isConnecting = true;
    _roomName = meetingName;
    notifyListeners();

    try {
      // 1. Demander un token au backend
      final response = await ApiService.post('/livekit/token', {
        'room_name': meetingName,
        'username': userName,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'];
        final String wsUrl = data['url'];

        // 2. Initialiser la room LiveKit
        _room = Room();
        
        // Listener pour les événements de la room
        final listener = _room!.createListener();
        
        // Connecter à la room
        await _room!.connect(wsUrl, token);
        
        // Publier les tracks locales (Micro/Caméra par défaut)
        await _room!.localParticipant?.setMicrophoneEnabled(true);
        await _room!.localParticipant?.setCameraEnabled(true);

        _isConnecting = false;
        notifyListeners();
      } else {
        throw Exception('Erreur backend: ${response.body}');
      }
    } catch (e) {
      _isConnecting = false;
      debugPrint('Erreur joinMeeting: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> leaveMeeting() async {
    await _room?.disconnect();
    _room = null;
    _roomName = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _room?.disconnect();
    super.dispose();
  }
}
