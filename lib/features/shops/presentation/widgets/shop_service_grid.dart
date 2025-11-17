import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solala/core/widgets/spacing.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/models/shops_model.dart';

class ServiceServicesGrid extends StatelessWidget {
  const ServiceServicesGrid({super.key, required this.services});

  final List<Service> services;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFE8D4B8),
      const Color(0xFFC8E6C9),
      const Color(0xFFB39DDB),
      const Color(0xFF80DEEA),
      const Color(0xFFFFCC80),
      const Color(0xFFEF9A9A),
    ];

    if (services.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          AppStrings.ourServices.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        VerticalSpace(12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            final colorIndex = index % colors.length;

            return Container(
              decoration: BoxDecoration(
                color: colors[colorIndex],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}