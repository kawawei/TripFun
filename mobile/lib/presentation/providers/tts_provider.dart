/**
 * @file tts_provider.dart
 * @description 全域語音服務 / Global Text-to-Speech Service
 * @description_zh 提供穩定、支持長文本的語音朗讀服務，兼容 Mobile 與 Web
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsState {
  final bool isPlaying;
  final bool isPaused;
  final int currentIndex;
  final List<String> chunks;
  final String? currentText;

  TtsState({
    this.isPlaying = false, 
    this.isPaused = false,
    this.currentIndex = 0,
    this.chunks = const [],
    this.currentText,
  });

  TtsState copyWith({
    bool? isPlaying, 
    bool? isPaused,
    int? currentIndex,
    List<String>? chunks,
    String? currentText,
  }) {
    return TtsState(
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      currentIndex: currentIndex ?? this.currentIndex,
      chunks: chunks ?? this.chunks,
      currentText: currentText ?? this.currentText,
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
      await _flutterTts.setSpeechRate(1.2); // 調整為 1.2 倍速
      await _flutterTts.setVolume(1.0);
      
      _flutterTts.setCompletionHandler(() {
        // 全文本讀完時才關閉 Play 狀態
        if (!state.isPaused && state.currentIndex >= state.chunks.length - 1) {
          state = state.copyWith(isPlaying: false, currentIndex: 0);
        }
      });
      _isInitialized = true;
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  Future<void> togglePlay(String text) async {
    if (text.isEmpty) return;
    await _ensureInitialized();

    // 1. 如果是不同文本，或者是重播，重新開始
    if (state.currentText != text) {
      await stop();
      final chunks = _splitText(text);
      state = state.copyWith(chunks: chunks, currentText: text, currentIndex: 0, isPaused: false);
      _playFromCurrent();
      return;
    }

    // 2. 如果正在播放，則暫停
    if (state.isPlaying && !state.isPaused) {
      await _flutterTts.stop();
      state = state.copyWith(isPaused: true);
      return;
    }

    // 3. 如果暫停中，則恢復
    if (state.isPaused) {
      state = state.copyWith(isPaused: false);
      _playFromCurrent();
      return;
    }

    // 4. 初次播放
    final chunks = _splitText(text);
    state = state.copyWith(chunks: chunks, currentText: text, currentIndex: 0, isPaused: false);
    _playFromCurrent();
  }

  Future<void> replay() async {
    final text = state.currentText;
    if (text == null) return;
    await stop();
    await togglePlay(text);
  }

  Future<void> _playFromCurrent() async {
    state = state.copyWith(isPlaying: true);
    
    // 獲取高品質語音
    final dynamic voices = await _flutterTts.getVoices;
    if (voices != null && voices is List && voices.isNotEmpty) {
      final targetVoices = voices.where((v) => v['locale']?.toString().toLowerCase().contains('zh_tw') ?? false).toList();
      if (targetVoices.isNotEmpty) {
        dynamic selected = targetVoices.firstWhere(
          (v) => v['name']?.toString().toLowerCase().contains('female') ?? false,
          orElse: () => targetVoices.firstWhere(
            (v) => v['name']?.toString().toLowerCase().contains('google') ?? false,
            orElse: () => targetVoices.first,
          ),
        );
        await _flutterTts.setVoice({"name": selected["name"], "locale": selected["locale"]});
      }
    }

    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(1.2);

    for (int i = state.currentIndex; i < state.chunks.length; i++) {
      if (!state.isPlaying || state.isPaused) break;
      
      state = state.copyWith(currentIndex: i);
      final syncCompleter = Completer<void>();
      
      _flutterTts.setCompletionHandler(() {
        if (!syncCompleter.isCompleted) syncCompleter.complete();
      });
      _flutterTts.setErrorHandler((_) {
        if (!syncCompleter.isCompleted) syncCompleter.complete();
      });

      await _flutterTts.speak(state.chunks[i]);
      
      await syncCompleter.future.timeout(const Duration(seconds: 20), onTimeout: () {
        if (!syncCompleter.isCompleted) syncCompleter.complete();
      });
      
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // 如果全部讀完
    if (state.currentIndex >= state.chunks.length - 1 && !state.isPaused) {
      state = state.copyWith(isPlaying: false, currentIndex: 0);
    }
  }

  List<String> _splitText(String text) {
    return text.split(RegExp(r'[。！？\n\r]')).where((s) => s.trim().isNotEmpty).toList();
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
    state = TtsState();
  }
}

final ttsProvider = StateNotifierProvider<TtsNotifier, TtsState>((ref) {
  return TtsNotifier();
});
