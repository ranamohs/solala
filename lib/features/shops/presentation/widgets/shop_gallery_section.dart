import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/shops_model.dart';

class ServiceImageGallery extends StatefulWidget {
  const ServiceImageGallery({super.key, required this.shopData});

  final ShopData shopData;

  @override
  State<ServiceImageGallery> createState() => _ServiceImageGalleryState();
}

class _ServiceImageGalleryState extends State<ServiceImageGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }
  List<String> _getImages() {
    final images = <String>[];

    if (widget.shopData.gallery != null && widget.shopData.gallery!.isNotEmpty) {
      for (final galleryItem in widget.shopData.gallery!) {
        if (galleryItem.url!.isNotEmpty) {
          images.add(galleryItem.url!);
        }
      }
    }

    if (images.isEmpty && widget.shopData.image.isNotEmpty) {
      images.add(widget.shopData.image);
    }

    return images;
  }
  void _startAutoScroll() {
    final images = _getImages();
    if (images.length <= 1) return;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients && mounted) {
        final nextPage = (_currentPage + 1) % images.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final images = _getImages();

    if (images.isEmpty) {
      return const SizedBox();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _timer?.cancel();
                    Future.delayed(const Duration(seconds: 10), () {
                      if (mounted) _startAutoScroll();
                    });
                  },
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: const Color(0xFFECECEC),
                      child: const Center(
                        child: Icon(Icons.image, size: 48, color: Colors.grey),
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFECECEC),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: _DotsIndicator(
                count: images.length,
                active: _currentPage,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          count,
              (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == active ? 10 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? Colors.white : Colors.white.withOpacity(.6),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}