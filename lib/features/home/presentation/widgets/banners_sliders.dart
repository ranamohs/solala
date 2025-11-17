
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/end_points.dart';
import '../../../../core/functions/open_url.dart';
import '../../../../core/widgets/fixit_buttons.dart';
import '../../../../core/widgets/image_loading_effect.dart';
import '../../data/models/banners_models/banners_model.dart';


class BannersSliders extends StatefulWidget {
  const BannersSliders({super.key, required this.bannerData});

  final List<Data> bannerData;

  @override
  State<BannersSliders> createState() => _BannersSlidersState();
}

class _BannersSlidersState extends State<BannersSliders> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return CarouselSlider.builder(
      itemCount: widget.bannerData.length,
      itemBuilder: (context, index, realIndex) {
        return GestureDetector(
          onTap: () {
            openUrl(widget.bannerData[index].url.toString());
          },
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  imageUrl: widget.bannerData[index].image ?? AppConstants.noImageUrl,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  placeholder: (context, url) => const ImageLoadingEffect(),
                  errorWidget: (context, url, error) => const SizedBox(),
                ),
              ),

            ],
          ),
        );
      },
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 1.7,
        enableInfiniteScroll: true,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
