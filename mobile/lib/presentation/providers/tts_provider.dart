/**
 * @file tts_provider.dart
 * @description 全域語音服務 / Global Text-to-Speech Service
 * @description_zh 提供穩定、支持長文本的語音朗讀服務，兼容 Mobile 與 Web
 */

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsState {
  final bool isPlaying;
  final String? currentGender;

  TtsState({this.isPlaying = false, this.currentGender});

  TtsState copyWith({bool? isPlaying, String? currentGender}) {
    return TtsState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentGender: currentGender ?? this.currentGender,
    );
  }
}

class TtsNotifier extends StateNotifier<TtsState> {
  TtsNotifier() : super(TtsState());

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setLanguage("zh-TW");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      
      _flutterTts.setCompletionHandler(() {
        state = state.copyWith(isPlaying: false);
      });
      _flutterTts.setCancelHandler(() {
        state = state.copyWith(isPlaying: false);
      });
      _isInitialized = true;
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  Future<void> speak(String text, {String? gender, String languageCode = 'zh-TW'}) async {
    if (text.isEmpty) return;
    await _ensureInitialized();

    try {
      // 嘗試獲取高品質語音 / Select high-quality voices
      final dynamic voices = await _flutterTts.getVoices;
      if (voices != null && voices is List) {
        try {
          final targetVoices = voices.where((v) {
            final String locale = v['locale']?.toString().toLowerCase() ?? '';
            return locale.contains(languageCode.toLowerCase().replaceAll('-', '_')) || 
                   locale.contains(languageCode.toLowerCase());
          }).toList();

          if (targetVoices.isNotEmpty) {
            // 根據性別偏好與品質挑選
            dynamic selected;
            if (gender == 'female') {
              selected = targetVoices.firstWhere(
                (v) => v['name']?.toString().toLowerCase().contains('female') ?? false,
                orElse: () => targetVoices.firstWhere(
                  (v) => v['name']?.toString().toLowerCase().contains('google') ?? false,
                  orElse: () => targetVoices.first,
                ),
              );
            } else if (gender == 'male') {
              selected = targetVoices.firstWhere(
                (v) => v['name']?.toString().toLowerCase().contains('male') ?? false,
                orElse: () => targetVoices.first,
              );
            } else {
              selected = targetVoices.firstWhere(
                (v) => v['name']?.toString().toLowerCase().contains('google') ?? false,
                orElse: () => targetVoices.first,
              );
            }
            await _flutterTts.setVoice({"name": selected["name"], "locale": selected["locale"]});
          }
        } catch (e) {
          debugPrint("Voice Selection Error: $e");
        }
      }

      // 如果正在撥放且點擊同一個，就停止
      if (state.isPlaying && state.currentGender == gender) {
        await stop();
        return;
      }

      await stop(); // 先停止前一個

      // 設定參數 (全面對齊翻譯頁面之黃金比例 1.0) / Align with Translator's 1.0 settings
      if (gender == 'female') {
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(1.0);
      } else if (gender == 'male') {
        await _flutterTts.setPitch(0.9); // 男聲微調音頻即可，維持語速
        await _flutterTts.setSpeechRate(1.0);
      } else {
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(1.0);
      }

      state = state.copyWith(isPlaying: true, currentGender: gender);

      // 分段處理長文本 (確保 Web 穩定讀完) / Split text for Web stability
      if (kIsWeb && text.length > 80) {
        List<String> chunks = _splitText(text);
        for (String chunk in chunks) {
          if (!state.isPlaying) break;
          await _flutterTts.speak(chunk);
          // 在 Web 端，套件會自動處理隊列 / Plugin handles queue on Web
        }
      } else {
        await _flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
      state = state.copyWith(isPlaying: false);
    }
  }

  List<String> _splitText(String text) {
    // 以句號、問號、感嘆號或換行符號切分 / Split by punctuation
    return text.split(RegExp(r'[。！？\n\r]')).where((s) => s.trim().isNotEmpty).toList();
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
    state = state.copyWith(isPlaying: false, currentGender: null);
  }
}

final ttsProvider = StateNotifierProvider<TtsNotifier, TtsState>((ref) {
  return TtsNotifier();
});
