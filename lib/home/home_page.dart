import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../auth/bloc/auth_bloc.dart';
import '../theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final isSubPage = location != '/home';

    return ResponsiveLayout(
      wideWidget: HomePageWide(child: child),
      narrowWidget: HomePageNarrow(
        isSubPage: isSubPage,
        title: _getTitleForRoute(location),
        child: child,
      ),
    );
  }

  String _getTitleForRoute(String route) {
    switch (route) {
      case '/home/validate_document':
        return 'Validate Document';
      case '/home/customer_management':
        return 'Customer Management';
      case '/home/services':
        return 'Services';
      case '/home/inspection':
        return 'Inspection';
      case '/home/enforcement':
        return 'Enforcement';
      case '/home/maps':
        return 'Maps';
      default:
        return 'Staff Dashboard';
    }
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget narrowWidget;
  final Widget wideWidget;

  const ResponsiveLayout({
    super.key,
    required this.narrowWidget,
    required this.wideWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return wideWidget;
        } else {
          return narrowWidget;
        }
      },
    );
  }
}

class HomePageNarrow extends StatelessWidget {
  final Widget child;
  final bool isSubPage;
  final String title;

  const HomePageNarrow({
    super.key,
    required this.child,
    required this.isSubPage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (isSubPage) {
      return Scaffold(body: SafeArea(child: child));
    }
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(title)],
        ),
        actions: const [UserProfileIcon()],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(child: child),
    );
  }
}

class HomePageWide extends StatelessWidget {
  final Widget child;
  const HomePageWide({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideNavigationPanel(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Staff Dashboard',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'For Nairobi County Authorized Staff only',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const UserProfileIcon(),
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SideNavigationPanel extends StatelessWidget {
  const SideNavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(right: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'LOGO',
              style: GoogleFonts.lato(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              children: [
                _buildModernSideNavItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  isSelected: currentPath == '/home',
                  onTap: () => context.go('/home'),
                ),
                _buildModernSideNavItem(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Validate Document',
                  isSelected: currentPath == '/home/validate_document',
                  onTap: () => context.go('/home/validate_document'),
                ),
                _buildModernSideNavItem(
                  context,
                  icon: Icons.people_outline,
                  title: 'Customer Management',
                  isSelected: currentPath == '/home/customer_management',
                  onTap: () => context.go('/home/customer_management'),
                ),
                _buildModernSideNavItem(
                  context,
                  icon: Icons.grid_view_outlined,
                  title: 'Services',
                  isSelected: currentPath == '/home/services',
                  onTap: () => context.go('/home/services'),
                ),
                _buildModernSideNavItem(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Inspection',
                  isSelected: currentPath == '/home/inspection',
                  onTap: () => context.go('/home/inspection'),
                ),
                _buildModernSideNavItem(
                  context,
                  icon: Icons.policy_outlined,
                  title: 'Enforcement',
                  isSelected: currentPath == '/home/enforcement',
                  onTap: () => context.go('/home/enforcement'),
                ),
                _buildModernSideNavItem(
                  context,
                  icon: Icons.map_outlined,
                  title: 'Maps',
                  isSelected: currentPath == '/home/maps',
                  onTap: () => context.go('/home/maps'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSideNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      decoration: BoxDecoration(
        gradient: isSelected ? AppTheme.primaryGradient : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textColor.withOpacity(0.7),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : AppTheme.textColor,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'John Doe',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Staff ID: 1234',
                  style: GoogleFonts.lato(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: [
                _buildModernNavItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  isSelected: currentPath == '/home',
                  onTap: () => context.go('/home'),
                ),
                _buildModernNavItem(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Validate Document',
                  isSelected: currentPath == '/home/validate_document',
                  onTap: () => context.go('/home/validate_document'),
                ),
                _buildModernNavItem(
                  context,
                  icon: Icons.people_outline,
                  title: 'Customer Management',
                  isSelected: currentPath == '/home/customer_management',
                  onTap: () => context.go('/home/customer_management'),
                ),
                _buildModernNavItem(
                  context,
                  icon: Icons.grid_view_outlined,
                  title: 'Services',
                  isSelected: currentPath == '/home/services',
                  onTap: () => context.go('/home/services'),
                ),
                _buildModernNavItem(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Inspection',
                  isSelected: currentPath == '/home/inspection',
                  onTap: () => context.go('/home/inspection'),
                ),
                _buildModernNavItem(
                  context,
                  icon: Icons.policy_outlined,
                  title: 'Enforcement',
                  isSelected: currentPath == '/home/enforcement',
                  onTap: () => context.go('/home/enforcement'),
                ),
                _buildModernNavItem(
                  context,
                  icon: Icons.map_outlined,
                  title: 'Maps',
                  isSelected: currentPath == '/home/maps',
                  onTap: () => context.go('/home/maps'),
                ),
                const Divider(height: 32),
                _buildModernNavItem(
                  context,
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  isSelected: false,
                  isLogout: true,
                  onTap: () => _showLogoutConfirmationDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildModernNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool isSelected = false,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: isSelected ? AppTheme.primaryGradient : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop(); // Close drawer
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isLogout
                        ? Colors.red.withOpacity(0.1)
                        : isSelected
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isLogout
                        ? Colors.red
                        : isSelected
                            ? Colors.white
                            : AppTheme.textColor.withOpacity(0.7),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isLogout
                          ? Colors.red
                          : isSelected
                              ? Colors.white
                              : AppTheme.textColor,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      );
    },
  );
}

class UserProfileIcon extends StatelessWidget {
  const UserProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 40),
      onSelected: (value) {
        if (value == 'logout') {
          _showLogoutConfirmationDialog(context);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout_outlined, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
      child: const CircleAvatar(
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.person_outline, color: Colors.white),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Gradient gradient;

  DashboardItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.gradient,
  });
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'Validate Document',
        description: 'Verify document authenticity',
        icon: Icons.verified_outlined,
        route: '/home/validate_document',
        gradient: AppTheme.validationGradient,
      ),
      DashboardItem(
        title: 'Customer Management',
        description: 'Manage customer accounts',
        icon: Icons.people_outline,
        route: '/home/customer_management',
        gradient: AppTheme.customerGradient,
      ),
      DashboardItem(
        title: 'Services',
        description: 'Access county services',
        icon: Icons.grid_view_outlined,
        route: '/home/services',
        gradient: AppTheme.servicesGradient,
      ),
      DashboardItem(
        title: 'Inspection',
        description: 'Property inspections',
        icon: Icons.security_outlined,
        route: '/home/inspection',
        gradient: AppTheme.inspectionGradient,
      ),
      DashboardItem(
        title: 'Enforcement',
        description: 'Enforcement actions',
        icon: Icons.policy_outlined,
        route: '/home/enforcement',
        gradient: AppTheme.enforcementGradient,
      ),
      DashboardItem(
        title: 'Maps',
        description: 'View location maps',
        icon: Icons.map_outlined,
        route: '/home/maps',
        gradient: AppTheme.mapsGradient,
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

    return MasonryGridView.count(
      padding: const EdgeInsets.all(16.0),
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
          child: DashboardCard(item: items[index]),
        );
      },
    );
  }
}

class DashboardCard extends StatefulWidget {
  final DashboardItem item;

  const DashboardCard({super.key, required this.item});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
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

