import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models.dart';
import 'pages.dart';
import 'theme.dart';
import 'widgets.dart';

enum AppPage { dashboard, orders, tasks, users, reports }

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  AppPage selectedPage = AppPage.dashboard;

  List<AppPage> _pagesFor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return <AppPage>[
          AppPage.dashboard,
          AppPage.orders,
          AppPage.users,
          AppPage.reports,
        ];
      case UserRole.gerencia:
        return <AppPage>[
          AppPage.dashboard,
          AppPage.orders,
          AppPage.reports,
        ];
      case UserRole.cotizaciones:
      case UserRole.dibujante:
      case UserRole.chofer:
      case UserRole.supervisorSoldadura:
      case UserRole.supervisorMaestranza:
        return <AppPage>[
          AppPage.dashboard,
          AppPage.tasks,
          AppPage.orders,
        ];
    }
  }

  String _label(AppPage page) {
    switch (page) {
      case AppPage.dashboard:
        return 'Dashboard';
      case AppPage.orders:
        return 'Órdenes de trabajo';
      case AppPage.tasks:
        return 'Mis tareas';
      case AppPage.users:
        return 'Usuarios';
      case AppPage.reports:
        return 'Reportes';
    }
  }

  IconData _icon(AppPage page) {
    switch (page) {
      case AppPage.dashboard:
        return Icons.dashboard_outlined;
      case AppPage.orders:
        return Icons.assignment_outlined;
      case AppPage.tasks:
        return Icons.task_alt_outlined;
      case AppPage.users:
        return Icons.people_outline;
      case AppPage.reports:
        return Icons.bar_chart_outlined;
    }
  }

  Widget _body(AppPage page, AppUser user) {
    switch (page) {
      case AppPage.dashboard:
        return DashboardPage(user: user);
      case AppPage.orders:
        return OrdersPage(user: user);
      case AppPage.tasks:
        return RoleTasksPage(user: user);
      case AppPage.users:
        return const UsersPage();
      case AppPage.reports:
        return const ReportsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final user = state.currentUser!;
    final availablePages = _pagesFor(user.role);
    if (!availablePages.contains(selectedPage)) {
      selectedPage = availablePages.first;
    }

    final desktop = MediaQuery.of(context).size.width >= 900;

    if (!desktop) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_label(selectedPage)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  user.role.shortLabel,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Cerrar sesión',
              onPressed: state.logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: _body(selectedPage, user),
        bottomNavigationBar: NavigationBar(
          selectedIndex: availablePages.indexOf(selectedPage),
          destinations: availablePages
              .map(
                (page) => NavigationDestination(
                  icon: Icon(_icon(page)),
                  label: _label(page),
                ),
              )
              .toList(),
          onDestinationSelected: (index) {
            setState(() => selectedPage = availablePages[index]);
          },
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 270,
            color: kNavy,
            padding: const EdgeInsets.fromLTRB(16, 25, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      BrandLogo(size: 50),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2RM ERP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Gestión de producción',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 38),
                ...availablePages.map(
                  (page) => _SideItem(
                    icon: _icon(page),
                    label: _label(page),
                    selected: selectedPage == page,
                    onTap: () => setState(() => selectedPage = page),
                  ),
                ),
                const Spacer(),
                const Divider(color: Colors.white12),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white12,
                        child: Icon(
                          iconForRole(user.role),
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              user.role.label,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _SideItem(
                  icon: Icons.logout,
                  label: 'Cerrar sesión',
                  selected: false,
                  onTap: state.logout,
                ),
              ],
            ),
          ),
          Expanded(child: _body(selectedPage, user)),
        ],
      ),
    );
  }
}

class _SideItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SideItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Material(
        color: selected
            ? Colors.white.withValues(alpha: .10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? Colors.white : Colors.white60,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white60,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                    ),
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
