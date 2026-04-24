/**
 * @file activity_detail_page.dart
 * @description 活動/景點詳情頁面 / Activity or Attraction Detail page
 * @description_zh 顯示景點詳細介紹、圖片與周邊資訊
 * @description_en Displays detailed attraction info, images, and nearby info
 */

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
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
                  return GestureDetector(
                    onTap: () => _showFullScreenImage(context, url),
                    child: CachedNetworkImage(
                      imageUrl: url,
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
            const DecoratedBox(
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
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentPage == index ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey.shade300,
              ),
            ),
          ),
        ),
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

