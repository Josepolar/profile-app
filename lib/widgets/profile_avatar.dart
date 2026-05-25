import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:profile_app/utils/constants.dart';
import 'package:profile_app/widgets/loading_indicator.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final File? localImage;
  final double size;
  final VoidCallback? onTap;
  final bool showEditBadge;

  const ProfileAvatar({
    super.key,
    this.photoUrl,
    this.localImage,
    this.size = AppRadius.avatar * 2,
    this.onTap,
    this.showEditBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.divider.withOpacity( 0.3),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity( 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(child: _buildImage()),
          ),
          if (showEditBadge)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.camera_fill,
                  color: CupertinoColors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (localImage != null) {
      return Image.file(
        localImage!,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    }

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: photoUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        placeholder: (_, __) => const Center(child: LoadingIndicator()),
        errorWidget: (_, __, ___) => _placeholderIcon(),
      );
    }

    return _placeholderIcon();
  }

  Widget _placeholderIcon() {
    return Container(
      color: AppColors.divider.withOpacity( 0.2),
      child: Icon(
        CupertinoIcons.person_fill,
        size: size * 0.45,
        color: AppColors.textSecondary,
      ),
    );
  }
}
