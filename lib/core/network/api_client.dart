import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';
import 'api_config.dart';

/// Exception levée pour toute réponse HTTP en erreur, avec le corps
/// JSON déjà décodé pour pouvoir afficher les messages du backend
/// (ex: {"telephone": ["Un utilisateur avec ce numéro existe déjà."]}).
class ApiException implements Exception {
  final int statusCode;
  final Map<String, dynamic>? body;
  ApiException(this.statusCode, this.body);

  /// Concatène les messages d'erreur retournés par DRF.
  String get message {
    if (body == null) return 'Erreur réseau ($statusCode)';
    if (body!['detail'] != null) return body!['detail'].toString();
    final parts = <String>[];
    body!.forEach((key, value) {
      if (value is List) {
        parts.addAll(value.map((e) => e.toString()));
      } else {
        parts.add(value.toString());
      }
    });
    return parts.isNotEmpty ? parts.join('\n') : 'Erreur ($statusCode)';
  }

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final _http = http.Client();
  final _tokenStorage = TokenStorage.instance;

  Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'X-Canal': ApiConfig.canal,
    };
    if (auth) {
      final token = await _tokenStorage.accessToken;
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    if (query == null || query.isEmpty) return uri;
    return uri.replace(queryParameters: query);
  }

  Map<String, dynamic>? _decode(http.Response res) {
    if (res.body.isEmpty) return null;
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is List) return {'results': decoded};
    return null;
  }

  Future<dynamic> _handle(http.Response res) async {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _decode(res));
  }

  /// Tente de rafraîchir l'access token via le refresh token stocké.
  /// Retourne true si le rafraîchissement a réussi.
  Future<bool> _tryRefreshToken() async {
    final refresh = await _tokenStorage.refreshTokenValue;
    if (refresh == null) return false;
    try {
      final res = await _http.post(
        _uri(ApiConfig.refreshToken),
        headers: await _headers(auth: false),
        body: jsonEncode({'refresh': refresh}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        await _tokenStorage.saveAccessToken(data['access']);
        return true;
      }
    } catch (_) {
      // ignore, on retombe sur l'échec plus bas
    }
    return false;
  }

  Future<dynamic> get(String path, {Map<String, String>? query, bool auth = true}) async {
    var res = await _http.get(_uri(path, query), headers: await _headers(auth: auth));
    if (res.statusCode == 401 && auth) {
      if (await _tryRefreshToken()) {
        res = await _http.get(_uri(path, query), headers: await _headers(auth: auth));
      }
    }
    return _handle(res);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body, bool auth = true}) async {
    var res = await _http.post(_uri(path), headers: await _headers(auth: auth), body: jsonEncode(body ?? {}));
    if (res.statusCode == 401 && auth) {
      if (await _tryRefreshToken()) {
        res = await _http.post(_uri(path), headers: await _headers(auth: auth), body: jsonEncode(body ?? {}));
      }
    }
    return _handle(res);
  }

  Future<dynamic> patch(String path, {Map<String, dynamic>? body, bool auth = true}) async {
    var res = await _http.patch(_uri(path), headers: await _headers(auth: auth), body: jsonEncode(body ?? {}));
    if (res.statusCode == 401 && auth) {
      if (await _tryRefreshToken()) {
        res = await _http.patch(_uri(path), headers: await _headers(auth: auth), body: jsonEncode(body ?? {}));
      }
    }
    return _handle(res);
  }
}
