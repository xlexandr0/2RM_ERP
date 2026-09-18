import 'package:flutter/material.dart';

import 'app_state.dart';
import 'login_screen.dart';
import 'models.dart';
import 'pages.dart';
import 'widgets.dart';

enum AppPage {
  dashboard,
  orders,
  tasks,
  users,
  reports,
}

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
  });

  @override
  State<HomeShell> createState() {
    return _HomeShellState();
  }
}

class _HomeShellState
    extends State<HomeShell> {
  AppPage selected =
      AppPage.dashboard;

  List<AppPage> get pages {
    final user =
        AppState.instance.currentUser!;

    if (user.role ==
        UserRole.admin) {
      return [
        AppPage.dashboard,
        AppPage.orders,
        AppPage.tasks,
        AppPage.users,
        AppPage.reports,
      ];
    }

    return [
      AppPage.dashboard,
      AppPage.orders,
      AppPage.tasks,
    ];
  }

  String label(AppPage page) {
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

  IconData icon(AppPage page) {
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

  Widget pageWidget(
    AppPage page,
  ) {
    switch (page) {
      case AppPage.dashboard:
        return const DashboardPage();

      case AppPage.orders:
        return const OrdersPage();

      case AppPage.tasks:
        return const MyTasksPage();

      case AppPage.users:
        return const UsersPage();

      case AppPage.reports:
        return const ReportsPage();
    }
  }

  void logout() {
    AppState.instance.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user =
        AppState.instance.currentUser!;

    final desktop =
        MediaQuery.of(context)
                .size
                .width >=
            900;

    final available = pages;

    if (!available
        .contains(selected)) {
      selected =
          available.first;
    }

    if (!desktop) {
      return Scaffold(
        appBar: AppBar(
          title:
              Text(label(selected)),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(
                right: 10,
              ),
              child: Center(
                child: Text(
                  user.role.label,
                  style:
                      const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: logout,
              icon:
                  const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body:
            pageWidget(selected),
        bottomNavigationBar:
            NavigationBar(
          selectedIndex:
              available.indexOf(
            selected,
          ),
          onDestinationSelected:
              (index) {
            setState(() {
              selected =
                  available[index];
            });
          },
          destinations:
              available.map(
            (page) {
              return NavigationDestination(
                icon:
                    Icon(icon(page)),
                label:
                    label(page),
              );
            },
          ).toList(),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 270,
            color:
                const Color(
              0xFF142A3A,
            ),
            padding:
                const EdgeInsets
                    .fromLTRB(
              16,
              24,
              16,
              18,
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    BrandLogo(
                      size: 50,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          '2RM ERP',
                          style:
                              TextStyle(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight
                                    .w900,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Producción',
                          style:
                              TextStyle(
                            color: Colors
                                .white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                ...available.map(
                  (page) {
                    final active =
                        selected ==
                            page;

                    return Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        bottom: 7,
                      ),
                      child:
                          Material(
                        color: active
                            ? Colors
                                .white
                                .withOpacity(
                                    .1)
                            : Colors
                                .transparent,
                        borderRadius:
                            BorderRadius
                                .circular(
                                    10),
                        child:
                            InkWell(
                          onTap: () {
                            setState(
                              () {
                                selected =
                                    page;
                              },
                            );
                          },
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      10),
                          child:
                              Padding(
                            padding:
                                const EdgeInsets
                                    .all(
                                        13),
                            child: Row(
                              children: [
                                Icon(
                                  icon(
                                    page,
                                  ),
                                  color: active
                                      ? Colors
                                          .white
                                      : Colors
                                          .white60,
                                ),
                                const SizedBox(
                                  width:
                                      12,
                                ),
                                Text(
                                  label(
                                    page,
                                  ),
                                  style:
                                      TextStyle(
                                    color: active
                                        ? Colors
                                            .white
                                        : Colors
                                            .white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                const Divider(
                  color:
                      Colors.white12,
                ),
                ListTile(
                  leading:
                      const CircleAvatar(
                    backgroundColor:
                        Colors.white12,
                    child: Icon(
                      Icons.person,
                      color:
                          Colors.white70,
                    ),
                  ),
                  title: Text(
                    user.name,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    user.role.label,
                    style:
                        const TextStyle(
                      color:
                          Colors.white54,
                    ),
                  ),
                ),
                ListTile(
                  onTap: logout,
                  leading:
                      const Icon(
                    Icons.logout,
                    color:
                        Colors.white60,
                  ),
                  title:
                      const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color:
                          Colors.white60,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                pageWidget(selected),
          ),
        ],
      ),
    );
  }
}