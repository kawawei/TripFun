/**
 * @file translator_page.dart
 * @description 即時翻譯頁面 / Instant Translation page
 * @description_zh 提供中、英、韓語即時文本翻譯與旅行常用語句
 * @description_en Provides instant text translation between Chinese, English, and Korean, plus common travel phrases
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ========================================
// 狀態管理 / State Management
// ========================================

class TranslationState {
  final String sourceText;
  final String translatedText;
  final String sourceLang;
  final String targetLang;
  final bool isLoading;

  TranslationState({
    this.sourceText = '',
    this.translatedText = '',
    this.sourceLang = 'zh-tw',
    this.targetLang = 'en',
    this.isLoading = false,
  });

  TranslationState copyWith({
    String? sourceText,
    String? translatedText,
    String? sourceLang,
    String? targetLang,
    bool? isLoading,
  }) {
    return TranslationState(
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TranslationNotifier extends StateNotifier<TranslationState> {
  TranslationNotifier() : super(TranslationState());

  final GoogleTranslator _translator = GoogleTranslator();

  void updateSourceText(String text) {
    state = state.copyWith(sourceText: text);
    if (text.isEmpty) {
      state = state.copyWith(translatedText: '', isLoading: false);
    }
  }

  void setSourceLang(String lang) {
    state = state.copyWith(sourceLang: lang);
    if (state.sourceText.isNotEmpty) {
      translate();
    }
  }

  void setTargetLang(String lang) {
    state = state.copyWith(targetLang: lang);
    if (state.sourceText.isNotEmpty) {
      translate();
    }
  }

  void swapLanguages() {
    state = state.copyWith(
      sourceLang: state.targetLang,
      targetLang: state.sourceLang,
      sourceText: state.translatedText,
      translatedText: state.sourceText,
    );
  }

  Future<void> translate() async {
    if (state.sourceText.isEmpty) return;

    state = state.copyWith(isLoading: true);
    try {
      final translation = await _translator.translate(
        state.sourceText,
        from: state.sourceLang,
        to: state.targetLang,
      );
      state = state.copyWith(translatedText: translation.text, isLoading: false);
    } catch (e) {
      state = state.copyWith(translatedText: '翻譯出錯，請稍後再試', isLoading: false);
    }
  }
}

final translationProvider =
    StateNotifierProvider<TranslationNotifier, TranslationState>((ref) {
  return TranslationNotifier();
});

// ========================================
// 語音播放狀態管理 / TTS State Management
// ========================================

class TtsNotifier extends StateNotifier<bool> {
  TtsNotifier() : super(false);

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text, String languageCode) async {
    if (text.isEmpty) return;

    try {
      // 1. 設定語言
      String ttsLang = 'en-US';
      if (languageCode == 'zh-tw') {
        ttsLang = 'zh-TW';
      } else if (languageCode == 'ko') {
        ttsLang = 'ko-KR';
      }
      await _flutterTts.setLanguage(ttsLang);

      // 2. 獲取所有可用語音並嘗試尋找女聲/高品質語音
      final dynamic voices = await _flutterTts.getVoices;
      if (voices != null && voices is List) {
        // 嘗試在該語言中尋找包含 'Google' 或 'Female' 的語音（通常品質較好）
        try {
          final targetVoices = voices.where((v) {
            final String name = v['name']?.toString().toLowerCase() ?? '';
            final String locale = v['locale']?.toString().toLowerCase() ?? '';
            return locale.contains(ttsLang.toLowerCase().replaceAll('-', '_')) || 
                   locale.contains(ttsLang.toLowerCase());
          }).toList();

          if (targetVoices.isNotEmpty) {
            // 優先序：包含 female -> 包含 Google -> 第一個
            dynamic selectedVoice = targetVoices.firstWhere(
              (v) => v['name']?.toString().toLowerCase().contains('female') ?? false,
              orElse: () => targetVoices.firstWhere(
                (v) => v['name']?.toString().toLowerCase().contains('google') ?? false,
                orElse: () => targetVoices.first,
              ),
            );
            await _flutterTts.setVoice({"name": selectedVoice["name"], "locale": selectedVoice["locale"]});
          }
        } catch (e) {
          debugPrint('Voice selection error: $e');
        }
      }

      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(1.0);
      
      state = true;
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS Error: $e');
    } finally {
      state = false;
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    state = false;
  }
}

final ttsProvider = StateNotifierProvider<TtsNotifier, bool>((ref) {
  return TtsNotifier();
});

// ========================================
// 頁面組件 / Page Component
// ========================================

class TranslatorPage extends ConsumerStatefulWidget {
  const TranslatorPage({super.key});

  @override
  ConsumerState<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends ConsumerState<TranslatorPage> {
  final TextEditingController _controller = TextEditingController();

  final Map<String, String> _languages = {
    'zh-tw': '繁體中文',
    'en': 'English',
    'ko': '한국어',
  };

  final List<Map<String, String>> _travelPhrases = [
    // 交通與自駕
    {'en': 'Excuse me, where is the subway station?', 'zh': '請問地鐵站在哪裡？', 'ko': '실례합니다, 지하철역이 어디인가요?', 'category': '交通'},
    {'en': 'What kind of gasoline should I use for this car?', 'zh': '請問這台車要加什麼油？', 'ko': '이 차는 어떤 연료를 넣어야 하나요?', 'category': '交通'},
    {'en': 'Does this car take gasoline or diesel?', 'zh': '這是汽油還是柴油？', 'ko': '이것은 휘발유인가요 아니면 경유인가요?', 'category': '交通'},
    {'en': 'Fill it up, please.', 'zh': '請幫我加滿。', 'ko': '가득 채워주세요.', 'category': '交通'},
    {'en': 'Where can I return the car?', 'zh': '我可以在哪裡還車？', 'ko': '어디에서 차를 반납할 수 있나요?', 'category': '交通'},
    // 住宿
    {'en': 'I have a reservation.', 'zh': '我有預約。', 'ko': '예약했습니다.', 'category': '住宿'},
    {'en': 'What time is the check-out?', 'zh': '退房時間是什麼時候？', 'ko': '체크아웃 시간이 언제인가요?', 'category': '住宿'},
    {'en': 'Can I leave my luggage here?', 'zh': '我可以把行李寄放在這裡嗎？', 'ko': '여기에 짐을 맡길 수 있나요?', 'category': '住宿'},
    // 用餐
    {'en': 'Can I have the check, please?', 'zh': '請給我帳單。', 'ko': '계산서 좀 주시겠어요?', 'category': '用餐'},
    {'en': 'How much does this cost?', 'zh': '這個多少錢？', 'ko': '이것은 얼마인가요?', 'category': '用餐'},
    // 緊急
    {'en': 'Where is the nearest pharmacy?', 'zh': '最近的藥局在哪裡？', 'ko': '가장 가까운 약국이 어디인가요?', 'category': '緊急'},
    {'en': 'Could you please help me?', 'zh': '可以請你幫幫我嗎？', 'ko': '도와주실 수 있나요?', 'category': '緊急'},
    {'en': 'I do not speak English very well.', 'zh': '我的英文不太好。', 'ko': '영어를 잘 못합니다.', 'category': '緊急'},
  ];

  String _selectedCategory = '全部';
  final List<String> _categories = ['全部', '交通', '住宿', '用餐', '緊急'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(translationProvider);
    final notifier = ref.read(translationProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('即時翻譯'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 語言切換欄 / Language Switcher
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: _buildLanguagePicker(
                      context,
                      selectedLang: state.sourceLang,
                      onSelected: (lang) => notifier.setSourceLang(lang),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeftRight, color: Colors.blue),
                    onPressed: () {
                      notifier.swapLanguages();
                      _controller.text = ref.read(translationProvider).sourceText;
                    },
                  ),
                  Expanded(
                    child: _buildLanguagePicker(
                      context,
                      selectedLang: state.targetLang,
                      onSelected: (lang) => notifier.setTargetLang(lang),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 輸入與翻譯區域 / Input & Translation Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // 源文字輸入 / Source Text Input
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _languages[state.sourceLang]!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              if (state.sourceText.isNotEmpty)
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => ref.read(ttsProvider.notifier).speak(state.sourceText, state.sourceLang),
                                      child: const Icon(LucideIcons.volume2, size: 18, color: Colors.blue),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () {
                                        _controller.clear();
                                        notifier.updateSourceText('');
                                      },
                                      child: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _controller,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: '請輸入文字...',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 18),
                            onChanged: (text) {
                              notifier.updateSourceText(text);
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: state.isLoading ? null : () => notifier.translate(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: state.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('翻譯'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 翻譯結果 / Translation Result
                  Card(
                    elevation: 0,
                    color: Colors.blue[50]?.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.blue.shade100),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _languages[state.targetLang]!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.translatedText.isEmpty ? '等待翻譯...' : state.translatedText,
                            style: TextStyle(
                              fontSize: 18,
                              color: state.translatedText.isEmpty ? Colors.grey : Colors.black,
                            ),
                          ),
                          if (state.translatedText.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(LucideIcons.volume2, size: 20, color: Colors.blue),
                                  onPressed: () => ref.read(ttsProvider.notifier).speak(state.translatedText, state.targetLang),
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.copy, size: 20, color: Colors.blue),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: state.translatedText));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('已複製到剪貼簿')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.share2, size: 20, color: Colors.blue),
                                  onPressed: () {
                                    // 實作分享功能
                                  },
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 旅行常用語句 / Common Travel Phrases
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(LucideIcons.plane, size: 20, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        '旅行常用英文句子',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 分類標籤 / Category Chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = category);
                            }
                          },
                          selectedColor: Colors.blue.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.blue[700] : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? Colors.blue : Colors.grey.shade300,
                            ),
                          ),
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _travelPhrases.where((p) => _selectedCategory == '全部' || p['category'] == _selectedCategory).length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final filteredPhrases = _travelPhrases
                          .where((p) => _selectedCategory == '全部' || p['category'] == _selectedCategory)
                          .toList();
                      final phrase = filteredPhrases[index];
                      return _buildPhraseCard(context, phrase, notifier);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguagePicker(
    BuildContext context, {
    required String selectedLang,
    required Function(String) onSelected,
  }) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      '選擇語言',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ..._languages.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.value),
                      trailing: selectedLang == entry.key
                          ? const Icon(LucideIcons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        onSelected(entry.key);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _languages[selectedLang]!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const Icon(LucideIcons.chevronDown, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPhraseCard(BuildContext context, Map<String, String> phrase, TranslationNotifier notifier) {
    return GestureDetector(
      onTap: () {
        _controller.text = phrase['en']!;
        notifier.updateSourceText(phrase['en']!);
        notifier.setSourceLang('en');
        notifier.setTargetLang('zh-tw');
        notifier.translate();
        // 滾動到頂部
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          phrase['en']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.volume2, color: Colors.blue, size: 18),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () => ref.read(ttsProvider.notifier).speak(phrase['en']!, 'en'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phrase['zh']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          phrase['ko']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.volume2, color: Colors.grey, size: 18),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () => ref.read(ttsProvider.notifier).speak(phrase['ko']!, 'ko'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
