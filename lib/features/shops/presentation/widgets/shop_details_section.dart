import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/functions/is_arabic.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:flutter/material.dart';

import '../../data/models/shops_model.dart';

class ShopDetailsSection extends StatelessWidget {
  const ShopDetailsSection({
    super.key,
    required this.shopData,
  });

  final ShopData shopData;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColors.lightGreyColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.pureWhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  shopData.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            VerticalSpace(16),
            // Shop Name
            Text(
              isArabic(context) ? shopData.name.ar : shopData.name.en,
              style: AppStyles.styleBold16(context)
                  .copyWith(color: AppColors.primaryColor),
            ),
            VerticalSpace(8),
            // Shop Description
            Text(
              isArabic(context)
                  ? shopData.description.ar
                  : shopData.description.en,
              style: AppStyles.styleMedium12(context)
                  .copyWith(color: const Color(0xFF666666)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            VerticalSpace(16),
            // Business Details Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    icon: Icons.medical_services_outlined,
                    title: 'Activity',
                    value: 'Medical & Health Services',
                  ),
                  VerticalSpace(8),
                  _buildDetailRow(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    value: shopData.address,
                  ),
                  VerticalSpace(8),
                  _buildDetailRow(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: shopData.phone ?? 'N/A',
                  ),
                ],
              ),
            ),
            VerticalSpace(16),
            // Working Hours Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Working Hours',
                  style: AppStyles.styleSemiBold12(context),
                ),
                VerticalSpace(8),
                _buildWorkingHoursRow(
                  day: 'Sat Thu',
                  time: '10:00 AM - 8:00 PM',
                  isClosed: false,
                ),
                VerticalSpace(4),
                _buildWorkingHoursRow(
                  day: 'Fri',
                  time: 'Closed',
                  isClosed: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkingHoursRow({
    required String day,
    required String time,
    required bool isClosed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isClosed ? Colors.red : const Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}