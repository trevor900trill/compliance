import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      narrowWidget: HomePageNarrow(),
      wideWidget: HomePageWide(),
    );
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
  const HomePageNarrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Staff Dashboard'),
            Text(
              'For Nairobi County Authorized Staff only',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ],
        ),
        actions: const [
          UserProfileIcon(),
        ],
      ),
      drawer: const AppDrawer(),
      body: const DashboardContent(),
    );
  }
}

class HomePageWide extends StatelessWidget {
  const HomePageWide({super.key});

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
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'For Nairobi County Authorized Staff only',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const UserProfileIcon(),
                    ],
                  ),
                ),
                const Expanded(
                  child: DashboardContent(),
                ),
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
    return Container(
        width: 250,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          border: Border(
            right: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    isSelected: true,
                  ),
                   _buildNavItem(
                    context,
                    icon: Icons.document_scanner_outlined,
                    title: 'Validate Document',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.people_outline,
                    title: 'Customer Management',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.grid_view_outlined,
                    title: 'Services',
                  ),
                   _buildNavItem(
                    context,
                    icon: Icons.security_outlined,
                    title: 'Inspection',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.policy_outlined,
                    title: 'Enforcement',
                  ),
                   _buildNavItem(
                    context,
                    icon: Icons.map_outlined,
                    title: 'Maps',
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
              border: Border(bottom: BorderSide(color: AppTheme.primaryColor.withAlpha(128), width: 0.5)),
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
                  isSelected: true,
                ),
                 _buildNavItem(
                    context,
                    icon: Icons.document_scanner_outlined,
                    title: 'Validate Document',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.people_outline,
                    title: 'Customer Management',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.grid_view_outlined,
                    title: 'Services',
                  ),
                   _buildNavItem(
                    context,
                    icon: Icons.security_outlined,
                    title: 'Inspection',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.policy_outlined,
                    title: 'Enforcement',
                  ),
                   _buildNavItem(
                    context,
                    icon: Icons.map_outlined,
                    title: 'Maps',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildNavItem(BuildContext context, {
  required IconData icon,
  required String title,
  bool isSelected = false,
  VoidCallback? onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border(left: BorderSide(color: isSelected ? AppTheme.primaryColor: Colors.transparent, width: 3)),
    ),
    child: Material(
    color: isSelected ? AppTheme.primaryColor.withAlpha(26) : Colors.transparent,
    child: InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textColor.withAlpha(178),
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
              ),
            ),
            const Spacer(),
            if(isSelected)
              const Icon(Icons.arrow_forward_ios_outlined, size: 14, color: AppTheme.primaryColor)
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
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout_outlined, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'logout') {
          _showLogoutConfirmationDialog(context);
        }
      },
      child: const CircleAvatar(
        backgroundColor: AppTheme.primaryColor,
        child: Icon(
          Icons.person_outline,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final String subtitle;
  final IconData icon;

  DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'Validate Document',
        subtitle: 'Scan the document QR code or key NairobiPay document identifier to verify the County issued document',
        icon: Icons.document_scanner_outlined,
      ),
      DashboardItem(
        title: 'Customer Management',
        subtitle: 'Scan the document QR code or key NairobiPay document identifier to verify the County issued document',
        icon: Icons.people_outline,
      ),
      DashboardItem(
        title: 'Services',
        subtitle: 'Scan the document QR code or key NairobiPay document identifier to verify the County issued document',
        icon: Icons.grid_view_outlined,
      ),
      DashboardItem(
        title: 'Inspection',
        subtitle: 'Scan the document QR code or key NairobiPay document identifier to verify the County issued document',
        icon: Icons.security_outlined,
      ),
      DashboardItem(
        title: 'Enforcement',
        subtitle: 'Scan the document QR code or key NairobiPay document identifier to verify the County issued document',
        icon: Icons.policy_outlined,
      ),
      DashboardItem(
        title: 'Maps',
        subtitle: 'Scan the document QR code or key NairobiPay document identifier to verify the County issued document',
        icon: Icons.map_outlined,
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(24.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400.0,
        crossAxisSpacing: 24.0,
        mainAxisSpacing: 24.0,
        childAspectRatio: 2.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return DashboardCard(item: items[index]);
      },
    );
  }
}

class DashboardCard extends StatelessWidget {
  final DashboardItem item;

  const DashboardCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFfbe116),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 32, color: AppTheme.primaryColor),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    item.subtitle,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
