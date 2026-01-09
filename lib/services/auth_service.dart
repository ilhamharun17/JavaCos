import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;
  static const _rememberKey = 'remember_me';

  // ================= LOGIN =================
  static Future<String?> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.session == null || res.user == null) {
        return 'Login gagal';
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberKey, rememberMe);

      // 🔥 PASTIKAN PROFILE ADA
      await _ensureProfile(res.user!, email: email);

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Terjadi kesalahan';
    }
  }

  // ================= REGISTER =================
  static Future<String?> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final res = await _supabase.auth.signUp(email: email, password: password);

      final user = res.user;
      if (user == null) {
        return 'Registrasi gagal';
      }

      // 🔥 INSERT PROFILE
      await _supabase.from('profiles').insert({
        'id': user.id,
        'username': username,
        'email': email,
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberKey, true);

      return null;
    } on PostgrestException catch (e) {
      return e.message;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Terjadi kesalahan';
    }
  }

  // ================= ENSURE PROFILE =================
  static Future<void> _ensureProfile(User user, {required String email}) async {
    final existing = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (existing == null) {
      await _supabase.from('profiles').insert({
        'id': user.id,
        'username': email.split('@').first,
        'email': email,
      });
    }
  }

  // ================= CHECK LOGIN (SPLASH) =================
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_rememberKey) ?? false;

    final session = _supabase.auth.currentSession;

    if (!remember && session != null) {
      await _supabase.auth.signOut();
      return false;
    }

    return session != null;
  }

  // ================= GET PROFILE =================
  static Future<Map<String, dynamic>?> getProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    return await _supabase.from('profiles').select().eq('id', user.id).single();
  }

  // ================= UPDATE PROFILE =================
  static Future<String?> updateProfile({required String username}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return 'User tidak ditemukan';

      await _supabase
          .from('profiles')
          .update({'username': username})
          .eq('id', user.id);

      return null;
    } catch (_) {
      return 'Gagal update profile';
    }
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _supabase.auth.signOut();
  }
}
