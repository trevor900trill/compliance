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
        title: const Text('Staff Dashboard'),
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
                      Text(
                        'Staff Dashboard',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
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
              top: MediaQuery.of(context).padding.top,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            color: AppTheme.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'John Doe',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Staff ID: 1234',
                  style: GoogleFonts.lato(
                    color: Colors.white.withAlpha(204),
                    fontSize: 14,
                  ),
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
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.primaryColor)
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
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
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
          Icons.person,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(24.0),
      crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : 2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 2.0,
      children: const [
        DashboardCard(
          icon: Icons.document_scanner_outlined,
          title: 'Validate',
          subtitle: 'Scan the document QR code or key NairobiPay document identifier.',
          color: Color(0xFFFFC107),
        ),
        DashboardCard(
          icon: Icons.people_outline,
          title: 'Customer',
          subtitle: 'Scan the document QR code or key NairobiPay document identifier.',
          color: Color(0xFFFFC107),
        ),
        DashboardCard(
          icon: Icons.grid_view_outlined,
          title: 'Services',
          subtitle: 'Scan the document QR code or key NairobiPay document identifier.',
          color: Color(0xFFFFC107),
        ),
        DashboardCard(
          icon: Icons.security_outlined,
          title: 'Inspection',
          subtitle: 'Scan the document QR code or key NairobiPay document identifier.',
          color: Color(0xFFFFC107),
        ),
        DashboardCard(
          icon: Icons.policy_outlined,
          title: 'Enforcement',
          subtitle: 'Scan the document QR code or key NairobiPay document identifier.',
           color: Color(0xFFFFC107),
        ),
        DashboardCard(
          icon: Icons.map_outlined,
          title: 'Maps',
          subtitle: 'Scan the document QR code or key NairobiPay document identifier.',
          color: Color(0xFFFFC107),
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
         boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              subtitle, 
              style: GoogleFonts.lato(fontSize: 13, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
