import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../theme.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'Unified Business Permit',
        icon: Icons.article_outlined,
        route: '/home/services/unified_business_permit',
      ),
      DashboardItem(
        title: 'Land Rates Bill',
        icon: Icons.landscape_outlined,
        route: '/home/services/land_rates_bill',
      ),
      DashboardItem(
        title: 'Fire & Disaster Management',
        icon: Icons.local_fire_department_outlined,
        route: '/home/services/fire_disaster_management',
      ),
      DashboardItem(
        title: 'Advertisement (Small Format)',
        icon: Icons.campaign_outlined,
        route: '/home/services/advertisement',
      ),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 900) {
      crossAxisCount = 3;
    } else if (screenWidth > 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: MasonryGridView.count(
        padding: const EdgeInsets.all(10.0),
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return DashboardCard(item: items[index]);
        },
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final String route;

  DashboardItem({required this.title, required this.icon, required this.route});
}

class DashboardCard extends StatelessWidget {
  final DashboardItem item;

  const DashboardCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(item.route),
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                left: 16,
                right: 16, // Added to allow wrapping
                child: Text(
                  item.title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                  maxLines: 2, // Allow title to wrap to 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                bottom: -25,
                right: -25,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0E8D0), // Darker green circle
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                right: 30,
                child: Icon(item.icon, size: 30, color: AppTheme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
