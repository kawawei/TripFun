/**
 * @file activity_detail_page.dart
 * @description 活動/景點詳情頁面 / Activity or Attraction Detail page
 * @description_zh 顯示景點詳細介紹、圖片與周邊資訊
 * @description_en Displays detailed attraction info, images, and nearby info
 */

import 'dart:async';
import 'dart:js' as js; // 用於 Web 原生調用 / For native JS interop
import 'package:flutter/foundation.dart'; // 用於 kIsWeb 判斷
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ActivityDetailPage extends StatefulWidget {
  final String title;
  final String category;
  final String? content;
  final List<String>? imageUrls;
  final Map<String, String>? personalInfo;

  const ActivityDetailPage({
    super.key,
    required this.title,
    required this.category,
    this.content,
    this.imageUrls,
    this.personalInfo,
  });

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> with WidgetsBindingObserver {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  
  // 語音組件 / TTS Components
  FlutterTts? _flutterTts;
  bool _isPlaying = false;
  String? _currentVoiceGender; // 'male' or 'female'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb) {
      _initTts();
    }
  }

  void _initTts() async {
    try {
      _flutterTts ??= FlutterTts();
      await _flutterTts!.setLanguage("zh-TW");
      await _flutterTts!.setSpeechRate(0.5);
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.0);

      _flutterTts!.setCompletionHandler(() {
        if (mounted) setState(() => _isPlaying = false);
      });

      _flutterTts!.setCancelHandler(() {
        if (mounted) setState(() => _isPlaying = false);
      });
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _stopTts();
    }
  }

  void _stopTts() {
    try {
      if (kIsWeb) {
        js.context.callMethod('eval', ['window.speechSynthesis.cancel()']);
      } else {
        _flutterTts?.stop();
      }
    } catch (_) {}
    if (mounted) setState(() => _isPlaying = false);
  }

  Future<void> _toggleSpeak(String gender) async {
    if (widget.content == null || widget.content!.isEmpty) return;

    // 處理朗讀文字：避開訂單資訊，鎖定精彩亮點
    String textToSpeak = widget.content!;
    if (textToSpeak.contains("--- 🌟 飯店亮點 (Highlights) ---")) {
      textToSpeak = textToSpeak.split("--- 🌟 飯店亮點 (Highlights) ---").last;
    }
    // 清除特殊符號
    textToSpeak = textToSpeak.replaceAll('"', '').replaceAll("'", "").replaceAll('\n', ' ');

    if (_isPlaying && _currentVoiceGender == gender) {
      _stopTts();
      return;
    }

    _stopTts(); // 先停止

    setState(() {
      _isPlaying = true;
      _currentVoiceGender = gender;
    });

    if (kIsWeb) {
      // --- Web 核心備援方案：直接調用原生 JS ---
      try {
        final double pitch = (gender == 'female' ? 1.4 : 0.8);
        final double rate = (gender == 'female' ? 1.1 : 0.9);
        
        js.context.callMethod('eval', ["""
          (function() {
            window.speechSynthesis.cancel();
            var msg = new SpeechSynthesisUtterance();
            msg.text = '$textToSpeak';
            msg.lang = 'zh-TW';
            msg.pitch = $pitch;
            msg.rate = $rate;
            msg.onend = function(event) {
              // 此部分無法直接回傳 Dart，故配合 Dart 的 Timer
            };
            window.speechSynthesis.speak(msg);
          })();
        """]);

        // Web 端手動設定一個估計的結束時間或讓使用者手動點擊停止
        // 為簡單起見，我們先假設播放中
      } catch (e) {
        debugPrint("Web Native TTS Error: $e");
        setState(() => _isPlaying = false);
      }
    } else {
      // --- 非 Web 環境：使用插件 ---
      try {
        _initTts();
        if (gender == 'female') {
          await _flutterTts!.setPitch(1.2); 
          await _flutterTts!.setSpeechRate(0.52);
        } else {
          await _flutterTts!.setPitch(0.85); 
          await _flutterTts!.setSpeechRate(0.48);
        }
        await _flutterTts!.speak(textToSpeak);
      } catch (e) {
        debugPrint("Plugin TTS Error: $e");
        setState(() => _isPlaying = false);
      }
    }
  }

  String _parseImageUrl(String url) {
    if (url.startsWith('/')) {
      return 'http://43.103.3.57:8087$url';
    }
    return url;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _stopTts(); // 銷毀時安全停止所有語音 / Safely stop TTS on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          if (_hasMultipleImages()) _buildPageIndicator(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.personalInfo != null) _buildPersonalInfoCard(context),
                  const SizedBox(height: 24),
                  _buildVoiceGuideSection(),
                  const SizedBox(height: 12),
                  _buildSectionTitle('詳細介紹'),
                  const SizedBox(height: 12),
                  Text(
                    widget.content ?? '暫無詳細介紹',
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('周邊景點與美食'),
                  const SizedBox(height: 16),
                  _buildNearbyList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceGuideSection() {
    final themeColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.mic2, color: themeColor, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI 語音導覽', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('為您朗讀景點亮點', style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          _buildVoiceButton(
            label: '優雅女聲',
            gender: 'female',
            icon: LucideIcons.user,
            activeColor: Colors.pink.shade400,
          ),
          const SizedBox(width: 8),
          _buildVoiceButton(
            label: '穩重男聲',
            gender: 'male',
            icon: LucideIcons.userCheck,
            activeColor: Colors.blue.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceButton({
    required String label,
    required String gender,
    required IconData icon,
    required Color activeColor,
  }) {
    final isCurrent = _isPlaying && _currentVoiceGender == gender;
    
    return GestureDetector(
      onTap: () => _toggleSpeak(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent ? activeColor : activeColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCurrent)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
              )
            else
              Icon(icon, size: 14, color: activeColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isCurrent ? Colors.white : activeColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final List<String> images = widget.imageUrls ?? [];
    final bool hasImages = images.isNotEmpty;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 背景圖片輪播 / Background Image Slider
            if (hasImages)
              PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                scrollBehavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
                ),
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final url = images[index];
                  final fullUrl = _parseImageUrl(url);
                  return GestureDetector(
                    onTap: () => _showFullScreenImage(context, fullUrl),
                    child: CachedNetworkImage(
                      imageUrl: fullUrl,
                      fit: BoxFit.cover,
                      fadeOutDuration: const Duration(milliseconds: 300),
                      fadeInDuration: const Duration(milliseconds: 500),
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) {
                        print('Image load error: $url - $error');
                        return _buildPlaceholder();
                      },
                    ),
                  );
                },
              )
            else
              _buildPlaceholder(),
            
            // 漸層遮罩 / Gradient overlay
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.4, 1.0],
                    colors: [
                      Colors.black38,
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),
            
            // 左右切換箭頭 (Web 友善) / Left-Right Navigation Arrows
            if (hasImages && images.length > 1)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: _currentPage > 0 ? 1.0 : 0.0,
                      child: _buildImageNavArrow(LucideIcons.chevronLeft, false),
                    ),
                    Opacity(
                      opacity: _currentPage < images.length - 1 ? 1.0 : 0.0,
                      child: _buildImageNavArrow(LucideIcons.chevronRight, true),
                    ),
                  ],
                ),
              ),
          ],
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        titlePadding: const EdgeInsetsDirectional.only(start: 50, bottom: 16),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(LucideIcons.camera, size: 64, color: Colors.grey.shade400),
      ),
    );
  }

  bool _hasMultipleImages() => widget.imageUrls != null && widget.imageUrls!.length > 1;

  Widget _buildPageIndicator() {
    final images = widget.imageUrls!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (index) => GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == index ? 20 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageNavArrow(IconData icon, bool isNext) {
    return GestureDetector(
      onTap: () {
        if (isNext && _currentPage < (widget.imageUrls?.length ?? 1) - 1) {
          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        } else if (!isNext && _currentPage > 0) {
          _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),
            InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, err) => const Icon(LucideIcons.imageOff, color: Colors.white, size: 48),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(LucideIcons.x, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.user, size: 18, color: themeColor),
              const SizedBox(width: 8),
              const Text('我的預訂資訊', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.personalInfo!.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.key, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildNearbyList() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildNearbyCard('Porto\'s Bakery', '附近美食', LucideIcons.cakeSlice),
          _buildNearbyCard('Columbia Memorial', '相關景點', LucideIcons.landmark),
          _buildNearbyCard('In-N-Out Burger', '附近美食', LucideIcons.beef),
        ],
      ),
    );
  }

  Widget _buildNearbyCard(String title, String subtitle, IconData icon) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(child: Icon(icon, color: Colors.grey.shade400)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

