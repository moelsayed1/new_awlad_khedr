import 'package:flutter/material.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class ImageUtils {
  /// Encodes a URL to handle spaces and special characters properly
  static String encodeImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return '';
    }
    
    try {
      // Use Uri.encodeFull for complete URL encoding
      return Uri.encodeFull(url);
    } catch (e) {
      // Fallback to original URL if encoding fails
      return url;
    }
  }

  /// Validates if an image URL is valid and not empty
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    
    // Check if URL starts with http or https
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// Creates a network image widget with proper error handling and URL encoding
  static Widget buildNetworkImage({
    required String? imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
    Duration timeout = const Duration(seconds: 10),
    int maxRetries = 2,
  }) {
    final encodedUrl = encodeImageUrl(imageUrl);
    final isValidUrl = isValidImageUrl(imageUrl);
    
    // Default placeholder
    final defaultPlaceholder = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      ),
    );

    // Default error widget
    final defaultErrorWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: borderRadius,
      ),
      child: Image.asset(
        AssetsData.logoPng,
        fit: fit,
      ),
    );

    if (!isValidUrl) {
      return defaultErrorWidget;
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        encodedUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return placeholder ?? defaultPlaceholder;
        },
        errorBuilder: (context, error, stackTrace) {
          // Log the error for debugging
          debugPrint('Image loading error: $error');
          return errorWidget ?? defaultErrorWidget;
        },
        // Add headers to handle potential CORS issues and improve compatibility
        headers: const {
          'Accept': 'image/*',
          'User-Agent': 'Mozilla/5.0 (compatible; Flutter App)',
        },
        // Add timeout and retry mechanism
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
      ),
    );
  }

  /// Load image with retry mechanism
  static Future<Uint8List?> _loadImageWithRetry(
    String url, 
    Duration timeout, 
    int maxRetries,
  ) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final httpClient = HttpClient();
        httpClient.connectionTimeout = timeout;
        
        final request = await httpClient.getUrl(Uri.parse(url));
        request.headers.set('Accept', 'image/*');
        request.headers.set('User-Agent', 'Mozilla/5.0 (compatible; Flutter App)');
        
        final response = await request.close();
        
        if (response.statusCode == 200) {
          final bytes = await consolidateHttpClientResponseBytes(response);
          httpClient.close();
          return bytes;
        } else {
          httpClient.close();
          throw Exception('HTTP ${response.statusCode}');
        }
      } catch (e) {
        if (attempt == maxRetries) {
          rethrow;
        }
        // Wait before retry (exponential backoff)
        await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }
    return null;
  }

  /// Creates a circular network image with proper error handling
  static Widget buildCircularNetworkImage({
    required String? imageUrl,
    required double radius,
    Widget? placeholder,
    Widget? errorWidget,
    Duration timeout = const Duration(seconds: 10),
    int maxRetries = 2,
  }) {
    final encodedUrl = encodeImageUrl(imageUrl);
    final isValidUrl = isValidImageUrl(imageUrl);
    
    // Default placeholder
    final defaultPlaceholder = CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
      ),
    );

    // Default error widget
    final defaultErrorWidget = CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[100],
      child: Image.asset(
        AssetsData.logoPng,
        fit: BoxFit.contain,
      ),
    );

    if (!isValidUrl) {
      return defaultErrorWidget;
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(
        encodedUrl,
        headers: const {
          'Accept': 'image/*',
          'User-Agent': 'Mozilla/5.0 (compatible; Flutter App)',
        },
      ),
      onBackgroundImageError: (exception, stackTrace) {
        // Log the error for debugging
        debugPrint('Circular image loading error: $exception');
      },
      child: errorWidget ?? defaultErrorWidget,
    );
  }
} 