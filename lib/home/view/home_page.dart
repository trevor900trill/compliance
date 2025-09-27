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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text(
          'Dashboard',
          style: TextStyle(fontSize: 18),
        ),
      ),
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
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.person_outline),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
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
            // User Profile Section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              width: double.infinity,
              color: AppTheme.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            // Navigation Items
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
                ],
              ),
            ),

            const Divider(height: 1, color: Color.fromARGB(255, 224, 224, 224)),
            // Logout Button
            _buildLogoutButton(context),
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
              ],
            ),
          ),
          const Divider(height: 1, color: Color.fromARGB(255, 224, 224, 224)),
          _buildLogoutButton(context),
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
  return Material(
    color: isSelected ? AppTheme.primaryColor.withAlpha(26) : Colors.transparent,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textColor.withAlpha(178),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
              ),
            ),
          ],
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

Widget _buildLogoutButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ElevatedButton.icon(
      icon: const Icon(Icons.logout, color: Colors.red),
      label: Text(
        'Logout',
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.withAlpha(26),
        elevation: 0,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () => _showLogoutConfirmationDialog(context),
    ),
  );
}