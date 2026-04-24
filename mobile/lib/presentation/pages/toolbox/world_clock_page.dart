/**
 * @file world_clock_page.dart
 * @description 世界時區頁面 / World Clock page
 * @description_zh 顯示所在地時間與預設的全球城市時間，並計算時差
 * @description_en Displays local time and default global city times, calculating time differences
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class WorldClockPage extends StatefulWidget {
  const WorldClockPage({super.key});

  @override
  State<WorldClockPage> createState() => _WorldClockPageState();
}

class _WorldClockPageState extends State<WorldClockPage> {
  late Timer _timer;
  late DateTime _now;
  String _localTimeZone = 'Asia/Taipei';
  bool _isInitialized = false;

  // 預設城市清單
  final List<Map<String, String>> _defaultCities = [
    {'name': '台北, 台灣', 'timezone': 'Asia/Taipei'},
    {'name': '首爾, 韓國', 'timezone': 'Asia/Seoul'},
    {'name': '洛杉磯, 美國', 'timezone': 'America/Los_Angeles'},
    {'name': '拉斯維加斯, 美國', 'timezone': 'America/Los_Angeles'},
  ];

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _initLocalTimeZone();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  Future<void> _initLocalTimeZone() async {
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = tzInfo.identifier;
      setState(() {
        _localTimeZone = timeZoneName;
        _isInitialized = true;
      });
    } catch (e) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // 計算時差文字
  String _getTimeDiff(String targetTimezone) {
    if (!_isInitialized) return '計算中...';
    try {
      final localLoc = tz.getLocation(_localTimeZone);
      final targetLoc = tz.getLocation(targetTimezone);
      
      final nowInLocal = tz.TZDateTime.from(_now, localLoc);
      final nowInTarget = tz.TZDateTime.from(_now, targetLoc);
      
      final diff = nowInTarget.timeZoneOffset.inHours - nowInLocal.timeZoneOffset.inHours;
      
      if (diff == 0) return '與所在地相同';
      final sign = diff > 0 ? '+' : '';
      return '與所在地時差 $sign$diff 小時';
    } catch (e) {
      return '資料準備中...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('世界時區'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 所在地大時鐘區域
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [bgColor, bgColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.mapPin, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '目前所在地 (${_localTimeZone.contains('/') ? _localTimeZone.split('/').last.replaceAll('_', ' ') : _localTimeZone})', 
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    DateFormat('HH:mm:ss').format(_now),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                Text(
                  DateFormat('yyyy年MM月dd日 EEEE').format(_now),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),

          // 其他城市列表 / Other Cities List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _defaultCities.length,
              itemBuilder: (context, index) {
                final city = _defaultCities[index];
                return _buildCityCard(city['name']!, city['timezone']!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityCard(String cityName, String timezone) {
    if (!_isInitialized) {
      return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()));
    }

    DateTime cityTime;
    bool isNight = false;
    
    try {
      final location = tz.getLocation(timezone);
      final tzDateTime = tz.TZDateTime.from(_now, location);
      cityTime = tzDateTime;
      isNight = cityTime.hour < 6 || cityTime.hour >= 18;
    } catch (e) {
      cityTime = _now;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cityName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                _getTimeDiff(timezone),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    isNight ? LucideIcons.moon : LucideIcons.sun,
                    size: 16,
                    color: isNight ? Colors.indigo : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('HH:mm').format(cityTime),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat('MM/dd').format(cityTime),
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
