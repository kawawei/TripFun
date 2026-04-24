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
      // 獲取高品質語音 (省略部分重複邏輯以節省篇幅)
      final dynamic voices = await _flutterTts.getVoices;
      if (voices != null && voices is List && voices.isNotEmpty) {
        final targetVoices = voices.where((v) => v['locale']?.toString().toLowerCase().contains(languageCode.toLowerCase().replaceAll('-', '_')) ?? false).toList();
        if (targetVoices.isNotEmpty) {
          dynamic selected = targetVoices.firstWhere(
            (v) => v['name']?.toString().toLowerCase().contains(gender == 'female' ? 'female' : 'male') ?? false,
            orElse: () => targetVoices.first,
          );
          await _flutterTts.setVoice({"name": selected["name"], "locale": selected["locale"]});
        }
      }

      await stop(); 
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(kIsWeb ? 0.9 : 1.0);

      state = state.copyWith(isPlaying: true, currentGender: gender);

      if (kIsWeb && text.length > 50) {
        List<String> chunks = _splitText(text);
        for (String chunk in chunks) {
          if (!state.isPlaying) break;
          
          // 建立一個等待鎖 / Create a lock to wait for speech completion
          final syncCompleter = Completer<void>();
          _flutterTts.setCompletionHandler(() {
            if (!syncCompleter.isCompleted) syncCompleter.complete();
          });
          _flutterTts.setErrorHandler((_) {
            if (!syncCompleter.isCompleted) syncCompleter.complete();
          });

          await _flutterTts.speak(chunk);
          
          // 等待這句讀完，或最多等 15 秒避免卡死 / Wait for completion or timeout
          await syncCompleter.future.timeout(const Duration(seconds: 15), onTimeout: () {
            if (!syncCompleter.isCompleted) syncCompleter.complete();
          });
          
          // 句與句之間的自然停頓
          await Future.delayed(const Duration(milliseconds: 200));
        }
        state = state.copyWith(isPlaying: false);
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
