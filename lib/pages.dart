import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models.dart';
import 'order_detail_screen.dart';
import 'widgets.dart';

class DashboardPage
    extends StatelessWidget {
  const DashboardPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state =
        AppState.instance;

    final user =
        state.currentUser!;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return SingleChildScrollView(
          padding:
              const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: user.role ==
                        UserRole.admin
                    ? 'Panel de administración'
                    : 'Panel de ${user.name}',
                subtitle:
                    'Resumen general de órdenes de trabajo.',
              ),
              const SizedBox(height: 25),
              LayoutBuilder(
                builder:
                    (context, constraints) {
                  int columns = 4;

                  if (constraints
                          .maxWidth <
                      650) {
                    columns = 1;
                  } else if (constraints
                          .maxWidth <
                      1050) {
                    columns = 2;
                  }

                  return GridView.count(
                    crossAxisCount:
                        columns,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    crossAxisSpacing:
                        14,
                    mainAxisSpacing:
                        14,
                    childAspectRatio:
                        columns == 1
                            ? 3.2
                            : 1.8,
                    children: [
                      MetricCard(
                        label:
                            'OT activas',
                        value:
                            '${state.activeOrders}',
                        icon: Icons
                            .assignment_outlined,
                      ),
                      MetricCard(
                        label:
                            'OT atrasadas',
                        value:
                            '${state.overdueOrders}',
                        icon: Icons
                            .warning_amber,
                      ),
                      MetricCard(
                        label:
                            'OT cerradas',
                        value:
                            '${state.closedOrders}',
                        icon:
                            Icons.task_alt,
                      ),
                      MetricCard(
                        label:
                            'Usuarios activos',
                        value:
                            '${state.activeUsers}',
                        icon: Icons
                            .people_outline,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Órdenes recientes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              const SizedBox(height: 15),
              ...state.orders
                  .take(5)
                  .map(
                    (order) =>
                        OrderCard(
                      order: order,
                      onTap: () {
                        openOrder(
                          context,
                          order.id,
                        );
                      },
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}

class OrdersPage
    extends StatefulWidget {
  const OrdersPage({
    super.key,
  });

  @override
  State<OrdersPage> createState() {
    return _OrdersPageState();
  }
}

class _OrdersPageState
    extends State<OrdersPage> {
  final searchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state =
        AppState.instance;

    final user =
        state.currentUser!;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final query =
            searchController.text
                .trim()
                .toLowerCase();

        final orders =
            state.orders.where(
          (order) {
            if (query.isEmpty) {
              return true;
            }

            return order.code
                    .toLowerCase()
                    .contains(query) ||
                order.client
                    .toLowerCase()
                    .contains(query) ||
                order.description
                    .toLowerCase()
                    .contains(query);
          },
        ).toList();

        return SingleChildScrollView(
          padding:
              const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              PageHeader(
                title:
                    'Órdenes de trabajo',
                subtitle:
                    'Las OT vencidas aparecen automáticamente en rojo.',
                action:
                    user.canCreateOrder
                        ? FilledButton
                            .icon(
                            onPressed:
                                () {
                              showNewOrderDialog(
                                context,
                              );
                            },
                            icon:
                                const Icon(
                              Icons.add,
                            ),
                            label:
                                const Text(
                              'Nueva OT',
                            ),
                          )
                        : null,
              ),
              const SizedBox(height: 22),
              TextField(
                controller:
                    searchController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration:
                    const InputDecoration(
                  hintText:
                      'Buscar OT, cliente o descripción...',
                  prefixIcon:
                      Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              ...orders.map(
                (order) => OrderCard(
                  order: order,
                  onTap: () {
                    openOrder(
                      context,
                      order.id,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyTasksPage
    extends StatelessWidget {
  const MyTasksPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state =
        AppState.instance;

    final user =
        state.currentUser!;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final references =
            <TaskReference>[];

        for (final order
            in state.orders) {
          for (final task
              in order.tasks) {
            if (task.assignedUsername ==
                    user.username ||
                user.role ==
                    UserRole.admin) {
              references.add(
                TaskReference(
                  order: order,
                  task: task,
                ),
              );
            }
          }
        }

        return SingleChildScrollView(
          padding:
              const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Mis tareas',
                subtitle:
                    user.role ==
                            UserRole.admin
                        ? 'Vista de todas las tareas.'
                        : 'Tareas asignadas a ${user.name}.',
              ),
              const SizedBox(height: 22),
              ...references.map(
                (reference) {
                  final task =
                      reference.task;

                  final editable =
                      user.role ==
                              UserRole.admin ||
                          task.assignedUsername ==
                              user.username;

                  return TaskTile(
                    task: task,
                    assignedName: state
                            .userByUsername(
                              task.assignedUsername,
                            )
                            ?.name ??
                        task.assignedUsername,
                    editable: editable,
                    onTap: () async {
                      final value =
                          await showStepProgressDialog(
                        context,
                        title:
                            'Avance de ${task.title}',
                        currentValue:
                            task.progress,
                      );

                      if (value ==
                          null) {
                        return;
                      }

                      await state
                          .updateTaskProgress(
                        orderId:
                            reference
                                .order.id,
                        taskId:
                            task.id,
                        value: value,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class UsersPage
    extends StatelessWidget {
  const UsersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state =
        AppState.instance;

    final current =
        state.currentUser!;

    if (!current.canManageUsers) {
      return const Center(
        child: Text(
          'Sin permisos.',
        ),
      );
    }

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return SingleChildScrollView(
          padding:
              const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Usuarios',
                subtitle:
                    'Usuarios y roles del ERP.',
                action:
                    FilledButton.icon(
                  onPressed: () {
                    showNewUserDialog(
                      context,
                    );
                  },
                  icon:
                      const Icon(
                    Icons.person_add,
                  ),
                  label:
                      const Text(
                    'Nuevo usuario',
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets
                        .all(16),
                decoration:
                    cardDecoration(),
                child:
                    SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Nombre',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Usuario',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Rol',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Estado',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Activo',
                        ),
                      ),
                    ],
                    rows: state.users
                        .map(
                          (user) =>
                              DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  user.name,
                                ),
                              ),
                              DataCell(
                                Text(
                                  user.username,
                                ),
                              ),
                              DataCell(
                                Text(
                                  user.role
                                      .label,
                                ),
                              ),
                              DataCell(
                                Text(
                                  user.active
                                      ? 'Activo'
                                      : 'Inactivo',
                                ),
                              ),
                              DataCell(
                                Switch(
                                  value: user
                                      .active,
                                  onChanged: user
                                              .username ==
                                          'admin'
                                      ? null
                                      : (_) {
                                          state.toggleUser(
                                            user.id,
                                          );
                                        },
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ReportsPage
    extends StatelessWidget {
  const ReportsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state =
        AppState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return SingleChildScrollView(
          padding:
              const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'Reportes',
                subtitle:
                    'Avance general de las órdenes.',
              ),
              const SizedBox(height: 22),
              Container(
                padding:
                    const EdgeInsets
                        .all(22),
                decoration:
                    cardDecoration(),
                child: Column(
                  children:
                      state.orders.map(
                    (order) {
                      return Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          bottom: 20,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                order.code,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w800,
                                ),
                              ),
                            ),
                            Expanded(
                              child:
                                  LinearProgressIndicator(
                                value: order
                                        .totalProgress /
                                    100,
                                minHeight:
                                    10,
                                valueColor:
                                    AlwaysStoppedAnimation<
                                        Color>(
                                  progressColor(
                                    order
                                        .totalProgress,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              '${order.totalProgress}%',
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MetricCard
    extends StatelessWidget {
  final String label;

  final String value;

  final IconData icon;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor:
                const Color(
              0xFF1F4E79,
            ).withOpacity(.1),
            child: Icon(
              icon,
              color:
                  const Color(
                0xFF1F4E79,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              Text(
                label,
                style:
                    const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TaskReference {
  final WorkOrder order;
  final WorkTask task;

  TaskReference({
    required this.order,
    required this.task,
  });
}

void openOrder(
  BuildContext context,
  int id,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          OrderDetailScreen(
        orderId: id,
      ),
    ),
  );
}

Future<void> showNewOrderDialog(
  BuildContext context,
) async {
  final state =
      AppState.instance;

  final clientController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  DateTime dueDate =
      DateTime.now().add(
    const Duration(days: 14),
  );

  String? pdfName;
  String? pdfPath;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder:
            (context, setDialogState) {
          return AlertDialog(
            title:
                const Text(
              'Nueva OT',
            ),
            content: SizedBox(
              width: 520,
              child:
                  SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller:
                          clientController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Cliente',
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller:
                          descriptionController,
                      maxLines: 3,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Descripción',
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ListTile(
                      title:
                          const Text(
                        'Fecha de entrega',
                      ),
                      subtitle: Text(
                        formatDate(
                          dueDate,
                        ),
                      ),
                      trailing:
                          const Icon(
                        Icons.event,
                      ),
                      onTap:
                          () async {
                        final date =
                            await showDatePicker(
                          context:
                              context,
                          initialDate:
                              dueDate,
                          firstDate:
                              DateTime.now(),
                          lastDate:
                              DateTime(
                            2035,
                          ),
                        );

                        if (date !=
                            null) {
                          setDialogState(
                            () {
                              dueDate =
                                  date;
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    OutlinedButton.icon(
                      onPressed:
                          () async {
                        final result =
                            await FilePicker
                                .platform
                                .pickFiles(
                          type: FileType
                              .custom,
                          allowedExtensions: const [
                            'pdf',
                          ],
                        );

                        if (result ==
                                null ||
                            result.files
                                .isEmpty) {
                          return;
                        }

                        final file =
                            result.files
                                .single;

                        setDialogState(
                          () {
                            pdfName =
                                file.name;
                            pdfPath =
                                file.path;
                          },
                        );
                      },
                      icon:
                          const Icon(
                        Icons
                            .picture_as_pdf,
                      ),
                      label: Text(
                        pdfName ??
                            'Adjuntar PDF',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
                },
                child:
                    const Text(
                  'Cancelar',
                ),
              ),
              FilledButton(
                onPressed:
                    () async {
                  if (clientController
                          .text
                          .trim()
                          .isEmpty ||
                      descriptionController
                          .text
                          .trim()
                          .isEmpty) {
                    return;
                  }

                  await state
                      .createOrder(
                    client:
                        clientController
                            .text
                            .trim(),
                    description:
                        descriptionController
                            .text
                            .trim(),
                    dueDate:
                        dueDate,
                    pdfName:
                        pdfName,
                    pdfPath:
                        pdfPath,
                  );

                  if (!dialogContext
                      .mounted) {
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                  );
                },
                child:
                    const Text(
                  'Crear',
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showNewUserDialog(
  BuildContext context,
) async {
  final state =
      AppState.instance;

  final nameController =
      TextEditingController();

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController(
    text: '1234',
  );

  UserRole role =
      UserRole.cotizaciones;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder:
            (context, setDialogState) {
          return AlertDialog(
            title:
                const Text(
              'Nuevo usuario',
            ),
            content: SizedBox(
              width: 470,
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  TextField(
                    controller:
                        nameController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Nombre',
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller:
                        usernameController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Usuario',
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller:
                        passwordController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Contraseña',
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  DropdownButtonFormField<
                      UserRole>(
                    value: role,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Rol',
                    ),
                    items: UserRole
                        .values
                        .map(
                      (item) {
                        return DropdownMenuItem<
                            UserRole>(
                          value:
                              item,
                          child:
                              Text(
                            item.label,
                          ),
                        );
                      },
                    ).toList(),
                    onChanged:
                        (value) {
                      if (value !=
                          null) {
                        setDialogState(
                          () {
                            role =
                                value;
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
                },
                child:
                    const Text(
                  'Cancelar',
                ),
              ),
              FilledButton(
                onPressed:
                    () async {
                  await state
                      .createUser(
                    name:
                        nameController
                            .text,
                    username:
                        usernameController
                            .text,
                    password:
                        passwordController
                            .text,
                    role: role,
                  );

                  if (!dialogContext
                      .mounted) {
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                  );
                },
                child:
                    const Text(
                  'Crear',
                ),
              ),
            ],
          );
        },
      );
    },
  );
}