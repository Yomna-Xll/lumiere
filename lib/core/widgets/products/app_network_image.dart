import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final BorderRadius borderRadius;
  final BoxFit fit;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: url.isEmpty
          ? const ImagePlaceholder()
          : CachedNetworkImage(
              imageUrl: url,
              fit: fit,
              width: double.infinity,
              height: double.infinity,
              placeholder: (_, _) => const ImagePlaceholder(),
              errorWidget: (_, _, _) => const ImagePlaceholder(),
            ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.inputFill,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.textHint,
        size: 28,
      ),
    );
  }
}