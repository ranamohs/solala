import 'package:solala/features/shops/presentation/widgets/section_card.dart';
import 'package:flutter/material.dart';
import '../../data/models/shops_model.dart';

class ServiceWorkingHours extends StatelessWidget {
  const ServiceWorkingHours({super.key, required this.shopData});

  final ShopData shopData;

  @override
  Widget build(BuildContext context) {
    final onWorkingHours = shopData.onWorkingHourse.isNotEmpty == true
        ? shopData.onWorkingHourse
        : '9:00 AM - 8:00 PM';

    final offWorking = shopData.offWorking.isNotEmpty == true
        ? shopData.offWorking
        : 'Closed';

    final onWorkingDays = shopData.onWorkingDay.isNotEmpty == true
        ? shopData.onWorkingDay
        : 'Sat-Thu';

    return SectionCard(
      title: 'Working Hours',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHoursRow(
            days: onWorkingDays,
            hours: onWorkingHours,
            isWorking: true,
          ),
          const SizedBox(height: 8),
          _buildHoursRow(
            days: 'Fri',
            hours: offWorking,
            isWorking: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHoursRow({
    required String days,
    required String hours,
    required bool isWorking,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isWorking
                ? const Color(0xFFDFEEF9)
                : const Color(0xFFF7E3E3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            days,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isWorking
                  ? const Color(0xFF2C83BD)
                  : const Color(0xFF9C4242),
            ),
          ),
        ),
        Expanded(
          child: Text(
            hours,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isWorking
                  ? const Color(0xFF333333)
                  : Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}