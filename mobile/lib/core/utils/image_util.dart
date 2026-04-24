/**
 * @file image_util.dart
 * @description 圖片處理工具 / Image Utility
 * @description_zh 提供圖片選擇、大小檢查與高效壓縮功能
 * @description_en Provides image picking, size check, and efficient compression
 */

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageUtil {
  static final ImagePicker _picker = ImagePicker();

  /// 選擇圖片並執行壓縮 / Pick image and compress it
  /// [maxWidth] 預設 1920 確保高清但不過大
  /// [quality] 壓縮品質，通常 80-85 是畫質與大小的最優解
  static Future<File?> pickAndCompressImage({
    ImageSource source = ImageSource.gallery,
    int maxWidth = 1920,
    int maxHeight = 1080,
    int quality = 85,
  }) async {
    // 1. 選擇原始圖片 / Pick original image
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 100, // 這裡先拿原始畫質，隨後手動精確壓縮
    );

    if (image == null) return null;

    final String originalPath = image.path;
    final File originalFile = File(originalPath);
    final int originalSize = await originalFile.length();

    // 2. 準備壓縮輸出的路徑 / Prepare output path
    final tempDir = await getTemporaryDirectory();
    final String targetPath = p.join(
      tempDir.path,
      "compressed_${DateTime.now().millisecondsSinceEpoch}${p.extension(originalPath)}",
    );

    // 3. 執行壓縮邏輯 / Execute compression logic
    XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
      originalPath,
      targetPath,
      quality: quality,
      minWidth: maxWidth,
      minHeight: maxHeight,
    );

    if (compressedXFile == null) return originalFile;

    final File compressedFile = File(compressedXFile.path);
    final int compressedSize = await compressedFile.length();

    print('Original size: ${originalSize / 1024 / 1024} MB');
    print('Compressed size: ${compressedSize / 1024 / 1024} MB');

    // 4. 最後檢查：如果壓縮後竟然還大於 10MB (極端情況)，則降低品質再次嘗試
    if (compressedSize > 10 * 1024 * 1024) {
      return await pickAndCompressImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 900,
        quality: 60, // 強制降低品質
      );
    }

    return compressedFile;
  }
}
