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
                _buildNavItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  isSelected: currentPath == '/home',
                  onTap: () => context.go('/home'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Validate Document',
                  isSelected: currentPath == '/home/validate_document',
                  onTap: () => context.go('/home/validate_document'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_outline,
                  title: 'Customer Management',
                  isSelected: currentPath == '/home/customer_management',
                  onTap: () => context.go('/home/customer_management'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.grid_view_outlined,
                  title: 'Services',
                  isSelected: currentPath == '/home/services',
                  onTap: () => context.go('/home/services'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Inspection',
                  isSelected: currentPath == '/home/inspection',
                  onTap: () => context.go('/home/inspection'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.policy_outlined,
                  title: 'Enforcement',
                  isSelected: currentPath == '/home/enforcement',
                  onTap: () => context.go('/home/enforcement'),
                ),
                _buildNavItem(
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
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.primaryColor.withAlpha(128),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(
                    Icons.person_outline,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: GoogleFonts.lato(
                        color: AppTheme.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Staff ID: 1234',
                      style: GoogleFonts.lato(
                        color: AppTheme.primaryColor.withAlpha(204),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  isSelected: currentPath == '/home',
                  onTap: () => context.go('/home'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Validate Document',
                  isSelected: currentPath == '/home/validate_document',
                  onTap: () => context.go('/home/validate_document'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_outline,
                  title: 'Customer Management',
                  isSelected: currentPath == '/home/customer_management',
                  onTap: () => context.go('/home/customer_management'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.grid_view_outlined,
                  title: 'Services',
                  isSelected: currentPath == '/home/services',
                  onTap: () => context.go('/home/services'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Inspection',
                  isSelected: currentPath == '/home/inspection',
                  onTap: () => context.go('/home/inspection'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.policy_outlined,
                  title: 'Enforcement',
                  isSelected: currentPath == '/home/enforcement',
                  onTap: () => context.go('/home/enforcement'),
                ),
                _buildNavItem(
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
}

Widget _buildNavItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  bool isSelected = false,
  VoidCallback? onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: 3,
        ),
      ),
    ),
    child: Material(
      color: isSelected
          ? AppTheme.primaryColor.withAlpha(26)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textColor.withAlpha(178),
                size: 20,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textColor,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 14,
                  color: AppTheme.primaryColor,
                ),
            ],
          ),
        ),
      ),
    ),
  );
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
  final IconData icon;
  final String route;

  DashboardItem({required this.title, required this.icon, required this.route});
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'Validate Document',
        icon: Icons.description_outlined,
        route: '/home/validate_document',
      ),
      DashboardItem(
        title: 'Customer Management',
        icon: Icons.people_outline,
        route: '/home/customer_management',
      ),
      DashboardItem(
        title: 'Services',
        icon: Icons.grid_view_outlined,
        route: '/home/services',
      ),
      DashboardItem(
        title: 'Inspection',
        icon: Icons.security_outlined,
        route: '/home/inspection',
      ),
      DashboardItem(
        title: 'Enforcement',
        icon: Icons.policy_outlined,
        route: '/home/enforcement',
      ),
      DashboardItem(
        title: 'Maps',
        icon: Icons.map_outlined,
        route: '/home/maps',
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
      padding: const EdgeInsets.all(10.0),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return DashboardCard(item: items[index]);
      },
    );
  }
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
                child: Text(
                  item.title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
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
