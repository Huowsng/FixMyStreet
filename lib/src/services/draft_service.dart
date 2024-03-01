import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/constants.dart';

class DraftService {
  static const _draftsKey = 'drafts_key';
  static Future<void> saveDraft(Draft draft) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Draft> drafts = await getDrafts();
    drafts.add(draft);
    final String draftsJson = jsonEncode(drafts);
    await prefs.setString(_draftsKey, draftsJson);
  }

  static Future<List<Draft>> getDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? draftsJson = prefs.getString(_draftsKey);
    if (draftsJson != null) {
      final List<dynamic> draftsMap = jsonDecode(draftsJson);
      return draftsMap.map((draftMap) => Draft.fromJson(draftMap)).toList();
    }
    return [];
  }

  static Future<int> getDraftCount() async {
    final drafts = await getDrafts();
    return drafts.length;
  }

  static Future<void> clearDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftsKey);
  }
}
