import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost/api-test/public';

  Future<bool> testerConnexion() async {
    final res = await http.get(Uri.parse('$baseUrl/famille-membres'));
    return res.statusCode == 200;
  }

  Future<Map<String, dynamic>> seConnecter(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> getFamilyMembers() async {
    final res = await http.get(Uri.parse('$baseUrl/famille-membres'));
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 && data['success'] == true) {
      return (data['data'] as List<dynamic>? ?? []);
    }
    throw Exception(data['message'] ?? 'Erreur de chargement des membres');
  }

  Future<void> ajouterMembre({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/famille-membres'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      }),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Erreur lors de l\'ajout (${res.statusCode})');
    }
  }

  Future<void> modifierMembre({
    required int id,
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
  }) async {
    final res = await http.put(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      }),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Erreur lors de la modification (${res.statusCode})');
    }
  }

  Future<void> supprimerMembre(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/famille-membres/$id'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Erreur lors de la suppression (${res.statusCode})');
    }
  }
}
