import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models.dart';
import 'order_detail_screen.dart';
import 'theme.dart';
import 'widgets.dart';

class DashboardPage extends StatelessWidget {
  final AppUser user;

  const DashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: user.role == UserRole.admin
                    ? 'Panel de administración'
                    : 'Dashboard',
                subtitle: user.role == UserRole.admin
                    ? 'Control general del ERP local de 2RM.'
                    : 'Resumen del estado actual de las órdenes de trabajo.',
              ),
              const SizedBox(height: 28),
              LayoutBuilder(
                builder: (context, constraints) {
                  int columns = 4;
                  if (constraints.maxWidth < 650) {
                    columns = 1;
                  } else if (constraints.maxWidth < 1050) {
                    columns = 2;
                  }
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: columns == 1 ? 3.4 : 1.75,
                    children: [
                      MetricCard(
                        label: 'OT activas',
                        value: '${state.activeOrders}',
                        icon: Icons.assignment_outlined,
                      ),
                      MetricCard(
                        label: 'En producción',
                        value: '${state.productionOrders}',
                        icon: Icons.precision_manufacturing_outlined,
                        accent: Colors.indigo,
                      ),
                      MetricCard(
                        label: 'Atrasadas',
                        value: '${state.lateOrders}',
                        icon: Icons.warning_amber_rounded,
                        accent: Colors.red,
                      ),
                      MetricCard(
                        label: user.role == UserRole.admin
                            ? 'Usuarios activos'
                            : 'Completadas',
                        value: user.role == UserRole.admin
                            ? '${state.activeUsers}'
                            : '${state.finishedOrders}',
                        icon: user.role == UserRole.admin
                            ? Icons.people_outline
                            : Icons.check_circle_outline,
                        accent: Colors.green,
                      ),
                    ],
                  );
                },
              ),
              if (user.role == UserRole.admin) ...[
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: cardDecoration(),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    runSpacing: 14,
                    children: [
                      const SizedBox(
                        width: 620,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Administración local',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Admin puede gestionar usuarios, crear/editar/eliminar OTs y ejecutar cualquier etapa del flujo para pruebas.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _confirmReset(context),
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Restablecer demo'),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              const SectionTitle(
                title: 'Órdenes en seguimiento',
                subtitle: 'Últimas órdenes registradas',
              ),
              const SizedBox(height: 14),
              ...state.orders.take(5).map(
                    (order) => OrderCard(
                      order: order,
                      onTap: () => _openOrder(context, order.id),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restablecer datos demo'),
        content: const Text(
          'Se borrarán los cambios locales y volverán los usuarios y OTs iniciales.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restablecer'),
          ),
        ],
      ),
    );
    if (accepted == true) {
      await AppState.instance.resetDemoData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos demo restablecidos.')),
        );
      }
    }
  }
}

class OrdersPage extends StatefulWidget {
  final AppUser user;

  const OrdersPage({super.key, required this.user});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final searchController = TextEditingController();

  bool get canCreate => widget.user.role == UserRole.admin ||
      widget.user.role == UserRole.gerencia;
  bool get canEdit => canCreate;
  bool get canDelete => widget.user.role == UserRole.admin;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final query = searchController.text.trim().toLowerCase();
        final orders = state.orders.where((order) {
          if (query.isEmpty) return true;
          return order.code.toLowerCase().contains(query) ||
              order.client.toLowerCase().contains(query) ||
              order.description.toLowerCase().contains(query) ||
              order.status.toLowerCase().contains(query);
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'Órdenes de trabajo',
                subtitle: 'Seguimiento y control de todas las OT.',
                trailing: canCreate
                    ? FilledButton.icon(
                        onPressed: () => _showOrderDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Nueva OT'),
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Buscar por OT, cliente, estado o descripción...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              if (orders.isEmpty)
                const EmptyState(
                  icon: Icons.search_off,
                  title: 'No encontramos órdenes',
                  subtitle: 'Prueba con otro término de búsqueda.',
                )
              else
                ...orders.map(
                  (order) => OrderCard(
                    order: order,
                    onTap: () => _openOrder(context, order.id),
                    trailingAction: (canEdit || canDelete)
                        ? PopupMenuButton<String>(
                            tooltip: 'Opciones',
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showOrderDialog(context, order: order);
                              } else if (value == 'delete') {
                                _confirmDelete(context, order);
                              }
                            },
                            itemBuilder: (context) => [
                              if (canEdit)
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Editar'),
                                ),
                              if (canDelete)
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Eliminar'),
                                ),
                            ],
                          )
                        : null,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, WorkOrder order) async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar ${order.code}'),
        content: const Text('Esta acción eliminará la OT del almacenamiento local.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (accepted == true) {
      await AppState.instance.deleteOrder(order.id);
    }
  }

  Future<void> _showOrderDialog(
    BuildContext context, {
    WorkOrder? order,
  }) async {
    final clientController = TextEditingController(text: order?.client ?? '');
    final descriptionController =
        TextEditingController(text: order?.description ?? '');
    DateTime dueDate =
        order?.dueDate ?? DateTime.now().add(const Duration(days: 14));
    String? pdfName = order?.orderPdfName;
    String? pdfPath = order?.orderPdfPath;
    String? validationError;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(order == null ? 'Registrar nueva OT' : 'Editar ${order.code}'),
              content: SizedBox(
                width: 560,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (validationError != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            validationError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      TextField(
                        controller: clientController,
                        decoration: const InputDecoration(
                          labelText: 'Cliente',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descripción del trabajo',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE3E8EE)),
                        ),
                        tileColor: Colors.white,
                        leading: const Icon(Icons.event_outlined),
                        title: const Text('Fecha de entrega'),
                        subtitle: Text(formatDate(dueDate)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final selected = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2025),
                            lastDate: DateTime.now().add(const Duration(days: 730)),
                            initialDate: dueDate,
                          );
                          if (selected != null) {
                            setDialogState(() => dueDate = selected);
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE3E8EE)),
                        ),
                        tileColor: Colors.white,
                        leading: const Icon(Icons.picture_as_pdf_outlined),
                        title: Text(pdfName ?? 'Adjuntar OT en PDF (opcional)'),
                        subtitle: const Text('Seleccionar archivo local'),
                        trailing: const Icon(Icons.upload_file),
                        onTap: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: const <String>['pdf'],
                          );

                          if (result != null && result.files.isNotEmpty) {
                            final file = result.files.single;
                            
                            setDialogState(() {
                                  pdfName = file.name;
                                  pdfPath = file.path;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (clientController.text.trim().isEmpty ||
                        descriptionController.text.trim().isEmpty) {
                      setDialogState(() {
                        validationError = 'Completa cliente y descripción.';
                      });
                      return;
                    }
                    if (order == null) {
                      await AppState.instance.addOrder(
                        client: clientController.text,
                        description: descriptionController.text,
                        dueDate: dueDate,
                        orderPdfName: pdfName,
                        orderPdfPath: pdfPath,
                      );
                    } else {
                      await AppState.instance.updateOrder(
                        id: order.id,
                        client: clientController.text,
                        description: descriptionController.text,
                        dueDate: dueDate,
                        orderPdfName: pdfName,
                        orderPdfPath: pdfPath,
                      );
                    }
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  },
                  child: Text(order == null ? 'Crear OT' : 'Guardar cambios'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class RoleTasksPage extends StatelessWidget {
  final AppUser user;

  const RoleTasksPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final tasks = _filterTasks(state.orders, user.role);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'Mis tareas · ${user.role.shortLabel}',
                subtitle: _description(user.role),
              ),
              const SizedBox(height: 24),
              if (tasks.isEmpty)
                const EmptyState(
                  icon: Icons.task_alt,
                  title: 'No tienes tareas pendientes',
                  subtitle: 'Las nuevas tareas aparecerán aquí automáticamente.',
                )
              else
                ...tasks.map(
                  (order) => Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(21),
                    decoration: cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.code,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(order.description),
                                  Text(
                                    order.client,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusChip(
                              text: order.status,
                              color: statusColor(order),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _taskAction(context, order),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _openOrder(context, order.id),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Ver detalle'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _taskAction(BuildContext context, WorkOrder order) {
    final state = AppState.instance;
    switch (user.role) {
      case UserRole.cotizaciones:
        return FilledButton.icon(
          onPressed: () => state.markOrderPlaced(order.id),
          icon: const Icon(Icons.shopping_cart_checkout),
          label: const Text('Confirmar pedido realizado'),
        );
      case UserRole.dibujante:
        return FilledButton.icon(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: const <String>['dxf'],
            );
            if (result != null && result.files.isNotEmpty) {
              final file = result.files.single;
              
              await state.attachDxf(
                id: order.id,
                fileName: file.name,
                filePath: file.path,
              );
            }
          },
          icon: const Icon(Icons.upload_file),
          label: const Text('Seleccionar y cargar DXF'),
        );
      case UserRole.chofer:
        return FilledButton.icon(
          onPressed: () => state.markReceived(order.id),
          icon: const Icon(Icons.inventory_2_outlined),
          label: const Text('Confirmar recepción'),
        );
      case UserRole.supervisorSoldadura:
        return _ProgressTask(
          progress: order.weldingProgress,
          onTap: () => _showQuickProgress(context, order, welding: true),
        );
      case UserRole.supervisorMaestranza:
        return _ProgressTask(
          progress: order.machiningProgress,
          onTap: () => _showQuickProgress(context, order, welding: false),
        );
      case UserRole.admin:
      case UserRole.gerencia:
        return const SizedBox.shrink();
    }
  }

  List<WorkOrder> _filterTasks(List<WorkOrder> orders, UserRole role) {
    switch (role) {
      case UserRole.cotizaciones:
        return orders.where((o) => o.approved && !o.orderPlaced).toList();
      case UserRole.dibujante:
        return orders.where((o) => o.orderPlaced && !o.dxfUploaded).toList();
      case UserRole.chofer:
        return orders.where((o) => o.dxfUploaded && !o.received).toList();
      case UserRole.supervisorSoldadura:
      case UserRole.supervisorMaestranza:
        return orders.where((o) => o.received && !o.finished).toList();
      case UserRole.admin:
      case UserRole.gerencia:
        return <WorkOrder>[];
    }
  }

  String _description(UserRole role) {
    switch (role) {
      case UserRole.cotizaciones:
        return 'OT aprobadas pendientes de pedido.';
      case UserRole.dibujante:
        return 'OT listas para adjuntar el archivo DXF.';
      case UserRole.chofer:
        return 'Pedidos listos para confirmar recepción.';
      case UserRole.supervisorSoldadura:
        return 'Actualiza el avance real de Soldadura.';
      case UserRole.supervisorMaestranza:
        return 'Actualiza el avance real de Maestranza.';
      case UserRole.admin:
      case UserRole.gerencia:
        return 'Seguimiento general.';
    }
  }

  Future<void> _showQuickProgress(
    BuildContext context,
    WorkOrder order, {
    required bool welding,
  }) async {
    double value = (welding ? order.weldingProgress : order.machiningProgress)
        .toDouble();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(welding ? 'Avance Soldadura' : 'Avance Maestranza'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${value.round()}%',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: progressColor(value.round()),
                  ),
                ),
                Slider(
                  value: value,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  onChanged: (newValue) => setState(() => value = newValue),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (welding) {
                  await AppState.instance
                      .setWeldingProgress(order.id, value.round());
                } else {
                  await AppState.instance
                      .setMachiningProgress(order.id, value.round());
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTask extends StatelessWidget {
  final int progress;
  final VoidCallback onTap;

  const _ProgressTask({required this.progress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ProgressBar(progress: progress)),
        const SizedBox(width: 12),
        Text(
          '$progress%',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: progressColor(progress),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(onPressed: onTap, child: const Text('Actualizar')),
      ],
    );
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'Usuarios',
                subtitle: 'Administración local de accesos y roles.',
                trailing: FilledButton.icon(
                  onPressed: () => _showUserDialog(context),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Nuevo usuario'),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: cardDecoration(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Usuario')),
                      DataColumn(label: Text('Rol')),
                      DataColumn(label: Text('Estado')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: state.users.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user.fullName)),
                          DataCell(Text(user.username)),
                          DataCell(Text(user.role.label)),
                          DataCell(
                            StatusChip(
                              text: user.active ? 'Activo' : 'Inactivo',
                              color: user.active ? Colors.green : Colors.grey,
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'Editar',
                                  onPressed: () =>
                                      _showUserDialog(context, user: user),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  onPressed: () => _deleteUser(context, user),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteUser(BuildContext context, AppUser user) async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar ${user.fullName}'),
        content: const Text('¿Deseas eliminar este usuario local?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (accepted != true) return;
    final error = await AppState.instance.deleteUser(user.id);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _showUserDialog(
    BuildContext context, {
    AppUser? user,
  }) async {
    final nameController = TextEditingController(text: user?.fullName ?? '');
    final usernameController = TextEditingController(text: user?.username ?? '');
    final passwordController = TextEditingController();
    UserRole role = user?.role ?? UserRole.cotizaciones;
    bool active = user?.active ?? true;
    String? error;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(user == null ? 'Nuevo usuario' : 'Editar usuario'),
          content: SizedBox(
            width: 540,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (error != null) ...[
                    Text(error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 10),
                  ],
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 13),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 13),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: user == null
                          ? 'Contraseña'
                          : 'Nueva contraseña (opcional)',
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 13),
                  DropdownButtonFormField<UserRole>(
                    value: role,
                    decoration: const InputDecoration(
                      labelText: 'Rol',
                      prefixIcon: Icon(Icons.manage_accounts_outlined),
                    ),
                    items: UserRole.values
                        .map(
                          (item) => DropdownMenuItem<UserRole>(
                            value: item,
                            child: Text(item.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setDialogState(() => role = value);
                    },
                  ),
                  const SizedBox(height: 6),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Usuario activo'),
                    value: active,
                    onChanged: (value) => setDialogState(() => active = value),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty ||
                    usernameController.text.trim().isEmpty ||
                    (user == null && passwordController.text.isEmpty)) {
                  setDialogState(() => error = 'Completa los campos obligatorios.');
                  return;
                }
                String? result;
                if (user == null) {
                  result = await AppState.instance.createUser(
                    username: usernameController.text,
                    password: passwordController.text,
                    fullName: nameController.text,
                    role: role,
                    active: active,
                  );
                } else {
                  result = await AppState.instance.updateUser(
                    id: user.id,
                    username: usernameController.text,
                    fullName: nameController.text,
                    role: role,
                    active: active,
                    newPassword: passwordController.text.isEmpty
                        ? null
                        : passwordController.text,
                  );
                }
                if (result != null) {
                  setDialogState(() => error = result);
                  return;
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Reportes',
                subtitle: 'Indicadores calculados con los datos locales.',
              ),
              const SizedBox(height: 25),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 700 ? 1 : 3;
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: columns == 1 ? 3.4 : 1.6,
                    children: [
                      MetricCard(
                        label: 'Avance promedio',
                        value: '${state.averageProgress}%',
                        icon: Icons.analytics_outlined,
                        accent: progressColor(state.averageProgress),
                      ),
                      MetricCard(
                        label: 'OT atrasadas',
                        value: '${state.lateOrders}',
                        icon: Icons.schedule_outlined,
                        accent: Colors.red,
                      ),
                      MetricCard(
                        label: 'OT finalizadas',
                        value: '${state.finishedOrders}',
                        icon: Icons.task_alt,
                        accent: Colors.green,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Avance por OT',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 20),
                    ...state.orders.map(
                      (order) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 110,
                              child: Text(
                                order.code,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(child: ProgressBar(progress: order.progress)),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 48,
                              child: Text(
                                '${order.progress}%',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: progressColor(order.progress),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void _openOrder(BuildContext context, String orderId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => WorkOrderDetailScreen(orderId: orderId),
    ),
  );
}
