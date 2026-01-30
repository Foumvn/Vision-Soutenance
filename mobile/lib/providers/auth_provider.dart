import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = false;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null) {
      // Optionnel: vérifier le token ou charger l'utilisateur
      await fetchCurrentUser();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Le backend FastAPI attend form-data pour /login (OAuth2PasswordRequestForm)
      // Mais ApiService.post envoie du JSON. On va utiliser une version personnalisée ou modifier ApiService.
      
      // Cependant, pour simplifier et rester cohérent avec ApiService, 
      // si le backend est configuré pour accepter du JSON, c'est mieux.
      // Vérifions auth.py: il utilise OAuth2PasswordRequestForm qui attend application/x-www-form-urlencoded
      
      // On va faire l'appel directement ici pour gérer le form-data
      final response = await ApiService.login(email, password);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        
        await fetchCurrentUser();
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Erreur login: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/auth/register', {
        'full_name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        // Après inscription, on connecte l'utilisateur
        return await login(email, password);
      }
    } catch (e) {
      print('Erreur register: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> fetchCurrentUser() async {
    try {
      final response = await ApiService.get('/auth/me');
      if (response.statusCode == 200) {
        _user = jsonDecode(response.body);
        notifyListeners();
      }
    } catch (e) {
      print('Erreur fetchCurrentUser: $e');
      logout();
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }
}
