import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/shops/presentation/widgets/service_working_hours.dart';
import 'package:solala/features/shops/presentation/widgets/shop_map_widget.dart';
import 'package:solala/features/shops/presentation/widgets/shop_service_grid.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/fixit_buttons.dart';
import '../../../../core/widgets/login_is_required.dart';
import '../../data/models/shops_model.dart';

class ServiceInfoCard extends StatelessWidget {
  const ServiceInfoCard({
    super.key,
    required this.shopData,
    required this.isGuest,
    required this.onRequestService,
    this.isLoading = false,
  });

  final ShopData shopData;
  final bool isGuest;
  final VoidCallback onRequestService;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.splashBackgroundStart,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            const VerticalSpace(12),
            _buildBusinessDetailsCard(),
            const VerticalSpace(12),
            ServiceWorkingHours(shopData: shopData),
            const VerticalSpace(12),
            ServiceServicesGrid(services: shopData.services ?? []),
            const VerticalSpace(16),
            PrimaryButton(
              isLoading: isLoading,
              text: AppStrings.requestService.tr(),
              onPressed: isLoading
                  ? () {}
                  : () {
                if (isGuest) {
                  showDialog(
                    context: context,
                    builder: (context) => LoginIsRequired(),
                  );
                } else {
                  onRequestService();
                }
              },
            ),
            const VerticalSpace(12),
            _buildLocationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shopData.name.ar,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF303030),
          ),
        ),
        const VerticalSpace(4),
        Text(
          shopData.description.ar,
          style: const TextStyle(
            fontSize: 12,
            height: 1.4,
            color: Color(0xFF6A6A6A),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessDetailsCard() {
    return _SectionCard(
      title: 'Business Details',
      child: Column(
        children: [
          _InfoItem(
            icon: Icons.verified_user_outlined,
            title: 'Activity',
            value: '${shopData.category.name.ar} Service',
          ),
          const SizedBox(height: 10),
          _InfoItem(
            icon: Icons.location_on_outlined,
            title: 'Location',
            value: shopData.address,
          ),
          const SizedBox(height: 10),
          _InfoItem(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: shopData.phone ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: AppColors.primaryColor),
            const SizedBox(width: 6),
            const Text(
              'Find us:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3A3A3A),
              ),
            ),
          ],
        ),
        const VerticalSpace(10),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              border: Border.all(color: const Color(0xFFE2E2E2)),
            ),
            child: ShopMapWidget(
              latitude: shopData.latitude,
              longitude: shopData.longitude,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.50),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF383838),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F3EA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF2F9D5C)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9A9A9A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}