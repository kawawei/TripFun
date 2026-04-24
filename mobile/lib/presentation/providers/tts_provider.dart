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
      // 如果正在撥放且點擊同一個，就停止
      if (state.isPlaying && state.currentGender == gender) {
        await stop();
        return;
      }

      await stop(); // 先停止前一個

      // 設定音色與參數
      await _flutterTts.setLanguage(languageCode);
      if (gender == 'female') {
        await _flutterTts.setPitch(1.2);
        await _flutterTts.setSpeechRate(0.52);
      } else if (gender == 'male') {
        await _flutterTts.setPitch(0.85);
        await _flutterTts.setSpeechRate(0.48);
      } else {
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(1.0);
      }

      state = state.copyWith(isPlaying: true, currentGender: gender);

      // 分段處理長文本 (Web 兼容性優化) / Split long text for Web stability
      if (kIsWeb && text.length > 100) {
        List<String> chunks = _splitText(text);
        for (String chunk in chunks) {
          if (!state.isPlaying) break;
          await _flutterTts.speak(chunk);
          // 在 Web 上需要等待前一段播完，這裡可以使用 await 確保順序
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
