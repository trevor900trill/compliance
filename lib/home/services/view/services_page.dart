import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../theme.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ServiceItem> items = [
      ServiceItem(
        title: 'Unified Business Permit',
        description: 'Apply for business permits',
        icon: Icons.business_outlined,
        route: '/home/services/unified_business_permit',
        gradient: AppTheme.servicesGradient,
      ),
      ServiceItem(
        title: 'Land Rates Bill',
        description: 'View and pay land rates',
        icon: Icons.landscape_outlined,
        route: '/home/services/land_rates_bill',
        gradient: AppTheme.primaryGradient,
      ),
      ServiceItem(
        title: 'Fire & Disaster Management',
        description: 'Fire safety certificates',
        icon: Icons.local_fire_department_outlined,
        route: '/home/services/fire_disaster_management',
        gradient: AppTheme.enforcementGradient,
      ),
      ServiceItem(
        title: 'Advertisement',
        description: 'Advertisement permits',
        icon: Icons.campaign_outlined,
        route: '/home/services/advertisement',
        gradient: AppTheme.accentGradient,
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
        title: const Text('County Services'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Services',
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a service to get started',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: MasonryGridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: ServiceCard(item: items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Gradient gradient;

  ServiceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.gradient,
  });
}

class ServiceCard extends StatefulWidget {
  final ServiceItem item;

  const ServiceCard({super.key, required this.item});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppTheme.mediumAnimation,
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
            boxShadow: _isHovered ? AppTheme.cardShadowHover : AppTheme.cardShadow,
            border: Border.all(
              color: widget.item.gradient.colors.first.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(widget.item.route),
              borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gradient Icon
                    AnimatedContainer(
                      duration: AppTheme.mediumAnimation,
                      transform: Matrix4.identity()
                        ..rotateZ(_isHovered ? 0.05 : 0.0),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: widget.item.gradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.item.gradient.colors.first.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.item.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Title
                    Text(
                      widget.item.title,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      widget.item.description,
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

