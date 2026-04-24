/**
 * @file activity_detail_page.dart
 * @description 活動/景點詳情頁面 / Activity or Attraction Detail page
 * @description_zh 顯示景點詳細介紹、圖片與周邊資訊
 * @description_en Displays detailed attraction info, images, and nearby info
 */

import 'dart:async';
import 'package:flutter/foundation.dart'; // 用於 kIsWeb 判斷
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/tts_provider.dart';

class ActivityDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String category;
  final String? content;
  final List<String>? imageUrls;
  final Map<String, String>? personalInfo;
  final String? locationName;

  const ActivityDetailPage({
    super.key,
    required this.title,
    required this.category,
    this.content,
    this.imageUrls,
    this.personalInfo,
    this.locationName,
  });

  @override
  ConsumerState<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends ConsumerState<ActivityDetailPage> with WidgetsBindingObserver {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      ref.read(ttsProvider.notifier).stop();
    }
  }

  Future<void> _handlePlayPause() async {
    if (widget.content == null || widget.content!.isEmpty) return;
    await ref.read(ttsProvider.notifier).togglePlay(widget.content!);
  }

  Future<void> _handleReplay() async {
    if (widget.content == null || widget.content!.isEmpty) return;
    await ref.read(ttsProvider.notifier).replay();
  }

  Future<void> _openGoogleMaps() async {
    final query = widget.locationName;
    if (query == null || query.isEmpty) return;

    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedQuery');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('無法開啟 Google Maps')),
        );
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
    // 銷毀時停止所有語音，但保留進度在 Provider 中（如果需要的話）
    // ref.read(ttsProvider.notifier).stop(); 
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
                  if (widget.personalInfo != null) const SizedBox(height: 16),
                  if (widget.locationName != null && widget.locationName!.isNotEmpty) _buildLocationCard(),
                  const SizedBox(height: 16),
                  _buildVoicePanel(),
                  const SizedBox(height: 24),
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

  Widget _buildLocationCard() {
    return GestureDetector(
      onTap: _openGoogleMaps,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueGrey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.mapPin, size: 18, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '地點與導航',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Text(
                    widget.locationName!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.externalLink, size: 20, color: Colors.blueGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildVoicePanel() {
    final ttsState = ref.watch(ttsProvider);
    final isPlaying = ttsState.isPlaying && !ttsState.isPaused;

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue[50]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 1),
      ),
      child: Row(
        children: [
          // AI 標籤 / AI Label
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.sparkles, size: 16, color: Colors.blue[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 語音導覽',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                Text(
                  isPlaying ? '正在播放介紹...' : (ttsState.isPaused ? '已暫停' : '點擊聆聽景點亮點'),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          // 播放/暫停按鈕 / Play/Pause Button
          _buildControlButton(
            icon: isPlaying ? LucideIcons.pause : LucideIcons.play,
            label: isPlaying ? '暫停' : '播放',
            onTap: _handlePlayPause,
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          // 重播按鈕 / Replay Button
          _buildControlButton(
            icon: LucideIcons.rotateCcw,
            label: '重播',
            onTap: _handleReplay,
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
          ),
        ],
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

