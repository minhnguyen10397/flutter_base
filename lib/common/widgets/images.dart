import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../utils/text_util.dart';

class ImageLocal extends Image {
  ImageLocal.asset({
    Key? key,
    required String name,
    double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.cover,
  }) : super(
          key: key,
          image: ResizeImage.resizeIfNeeded(
            null,
            null,
            AssetImage(name),
          ),
          width: width,
          height: height,
          color: color,
          fit: boxFit,
        );

  ImageLocal.file({
    Key? key,
    required File file,
    required double width,
    required double height,
    Color? color,
    BoxFit boxFit = BoxFit.cover,
  }) : super(
          key: key,
          image: ResizeImage.resizeIfNeeded(
            null,
            null,
            FileImage(file),
          ),
          width: width,
          height: height,
          color: color,
          fit: boxFit,
        );
}

class AvatarRoundedImage extends StatelessWidget {

  const AvatarRoundedImage({
    Key? key,
    required this.url,
    this.size = 60,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final String url;
  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (TextUtils.isEmpty(url)) {
      return SizedBox(
        width: size,
        height: size,
        child: CircleAvatar(
          radius: size/2,
          backgroundColor: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size/2),
            child: ImageLocal.asset(
              name: 'assets/images/avatar.png',
              width: (size - 8),
              height: (size - 8),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: size/2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size),
          child: CachedNetworkImage(
            imageUrl: url,
            width: size,
            height: size,
            fit: fit,
            placeholder: (BuildContext context, String url) {
              if (Platform.isAndroid) {
                return const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        UIColors.primary,
                      ),
                    ),
                  ),
                );
              }
              return const CupertinoActivityIndicator();
            },
            errorWidget: (BuildContext context, String url, _) {
              return ImageLocal.asset(
                name: 'assets/images/avatar.png',
                width: size,
                height: size,
                boxFit: BoxFit.contain,
              );
            },
          ),
        ),
      ),
    );
  }
}

class AvatarImage extends StatelessWidget {

  const AvatarImage({
    Key? key,
    required this.url,
    this.size = 45,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final String url;
  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (TextUtils.isEmpty(url)) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(width: 1, color: UIColors.gray),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ImageLocal.asset(
            name: 'assets/images/default_avatar_icon.png',
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 1, color: UIColors.gray),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl: url,
          width: size,
          height: size,
          fit: fit,
          placeholder: (BuildContext context, String url) {
            if (Platform.isAndroid) {
              return const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      UIColors.primary,
                    ),
                  ),
                ),
              );
            }
            return const CupertinoActivityIndicator();
          },
          errorWidget: (BuildContext context, String url, _) {
            return ImageLocal.asset(
              name: 'assets/images/avatar.png',
              width: size,
              height: size,
              boxFit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}

class ImageNetwork extends StatelessWidget {

  const ImageNetwork({
    Key? key,
    required this.url,
    this.width = 0,
    this.height = 0,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.color,
  }) : super(key: key);

  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (TextUtils.isEmpty(url)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ImageLocal.asset(
          name: 'assets/images/default_avatar_icon.png',
          width: width,
          height: height,
          boxFit: fit,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        color: color,
        placeholder: (BuildContext context, String url) {
          if (Platform.isAndroid) {
            return const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(UIColors.primary),
                ),
              ),
            );
          }
          return const CupertinoActivityIndicator();
        },
        errorWidget: (BuildContext context, String url, _) {
          return ImageLocal.asset(
            name: 'assets/images/avatar.png',
            width: width,
            height: height,
            boxFit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
