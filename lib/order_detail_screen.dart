import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models.dart';
import 'theme.dart';
import 'widgets.dart';

class WorkOrderDetailScreen extends StatelessWidget {
  final String orderId;

  const WorkOrderDetailScreen({
    super.key,
    required this.orderId,
  });

  bool _can(UserRole role, String action) {
    if (role == UserRole.admin) return true;
    switch (action) {
      case 'pedido':
        return role == UserRole.cotizaciones;
      case 'dxf':
        return role == UserRole.dibujante;
      case 'recepcion':
        return role == UserRole.chofer;
      case 'soldadura':
        return role == UserRole.supervisorSoldadura;
      case 'maestranza':
        return role == UserRole.supervisorMaestranza;
      case 'finalizar':
        return role == UserRole.gerencia;
      default:
        return false;
    }
  }

  Future<void> _pickDxf(BuildContext context, WorkOrder order) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: const <String>['dxf'],
  );

  if (result == null || result.files.isEmpty) {
    return;
  }

  final file = result.files.single;

  await AppState.instance.attachDxf(
    id: order.id,
    fileName: file.name,
    filePath: file.path,
  );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('DXF ${file.name} cargado.'),
      ),
    );
  }
}

  Future<void> _showProgressDialog(
    BuildContext context,
    WorkOrder order, {
    required bool welding,
  }) async {
    double value = (welding
            ? order.weldingProgress
            : order.machiningProgress)
        .toDouble();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                welding ? 'Avance de Soldadura' : 'Avance de Maestranza',
              ),
              content: SizedBox(
                width: 430,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${value.round()}%',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: progressColor(value.round()),
                      ),
                    ),
                    Slider(
                      value: value,
                      min: 0,
                      max: 100,
                      divisions: 20,
                      label: '${value.round()}%',
                      onChanged: (newValue) {
                        setState(() => value = newValue);
                      },
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
                      await AppState.instance.setWeldingProgress(
                        order.id,
                        value.round(),
                      );
                    } else {
                      await AppState.instance.setMachiningProgress(
                        order.id,
                        value.round(),
                      );
                    }
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  },
                  child: const Text('Guardar avance'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final order = state.findOrder(orderId);
        final user = state.currentUser!;
        final color = progressColor(order.progress);

        return Scaffold(
          appBar: AppBar(
            title: Text(order.code),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: StatusChip(
                    text: order.isLate && !order.finished
                        ? 'Atrasada'
                        : order.status,
                    color: statusColor(order),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.code,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                order.description,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${order.progress}%',
                          style: TextStyle(
                            color: color,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ProgressBar(progress: order.progress, height: 14),
                    const SizedBox(height: 28),
                    _DetailCard(
                      title: 'Información general',
                      child: Wrap(
                        spacing: 55,
                        runSpacing: 24,
                        children: [
                          _InfoItem(label: 'Cliente', value: order.client),
                          _InfoItem(label: 'Estado', value: order.status),
                          _InfoItem(
                            label: 'Fecha de inicio',
                            value: formatDate(order.startDate),
                          ),
                          _InfoItem(
                            label: 'Fecha de entrega',
                            value: formatDate(order.dueDate),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _DetailCard(
                      title: 'Flujo de la OT',
                      child: Column(
                        children: [
                          _ProcessStep(
                            title: 'OT aprobada y registrada',
                            subtitle: order.orderPdfName ??
                                'Orden creada en el sistema local.',
                            completed: order.approved,
                          ),
                          _ProcessStep(
                            title: 'Pedido realizado',
                            subtitle: 'Responsable: Cotizaciones',
                            completed: order.orderPlaced,
                            active: order.approved && !order.orderPlaced,
                          ),
                          _ProcessStep(
                            title: 'Archivo DXF cargado',
                            subtitle: order.dxfFileName ??
                                'Responsable: Dibujante',
                            completed: order.dxfUploaded,
                            active: order.orderPlaced && !order.dxfUploaded,
                          ),
                          _ProcessStep(
                            title: 'Pedido recibido',
                            subtitle: 'Responsable: Chofer',
                            completed: order.received,
                            active: order.dxfUploaded && !order.received,
                          ),
                          _ProcessStep(
                            title: 'Producción',
                            subtitle:
                                'Soldadura ${order.weldingProgress}% · Maestranza ${order.machiningProgress}%',
                            completed: order.productionProgress == 100,
                            active: order.received &&
                                order.productionProgress < 100,
                          ),
                          _ProcessStep(
                            title: 'Cierre al 100%',
                            subtitle: 'Cierre formal de la orden de trabajo.',
                            completed: order.finished,
                            active: order.productionProgress == 100 &&
                                !order.finished,
                            last: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _DetailCard(
                      title: 'Producción',
                      child: Column(
                        children: [
                          _AreaProgress(
                            name: 'Soldadura',
                            progress: order.weldingProgress,
                            onEdit: order.received &&
                                    !order.finished &&
                                    _can(user.role, 'soldadura')
                                ? () => _showProgressDialog(
                                      context,
                                      order,
                                      welding: true,
                                    )
                                : null,
                          ),
                          const SizedBox(height: 24),
                          _AreaProgress(
                            name: 'Maestranza',
                            progress: order.machiningProgress,
                            onEdit: order.received &&
                                    !order.finished &&
                                    _can(user.role, 'maestranza')
                                ? () => _showProgressDialog(
                                      context,
                                      order,
                                      welding: false,
                                    )
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (!order.finished)
                      _DetailCard(
                        title: 'Acciones disponibles',
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            if (!order.orderPlaced &&
                                _can(user.role, 'pedido'))
                              FilledButton.icon(
                                onPressed: () => state.markOrderPlaced(order.id),
                                icon: const Icon(Icons.shopping_cart_checkout),
                                label: const Text('Confirmar pedido'),
                              ),
                            if (order.orderPlaced &&
                                !order.dxfUploaded &&
                                _can(user.role, 'dxf'))
                              FilledButton.icon(
                                onPressed: () => _pickDxf(context, order),
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Seleccionar DXF'),
                              ),
                            if (order.dxfUploaded &&
                                !order.received &&
                                _can(user.role, 'recepcion'))
                              FilledButton.icon(
                                onPressed: () => state.markReceived(order.id),
                                icon: const Icon(Icons.inventory_2_outlined),
                                label: const Text('Confirmar recepción'),
                              ),
                            if (order.productionProgress == 100 &&
                                !order.finished &&
                                _can(user.role, 'finalizar'))
                              FilledButton.icon(
                                onPressed: () => state.finishOrder(order.id),
                                icon: const Icon(Icons.task_alt),
                                label: const Text('Finalizar OT al 100%'),
                              ),
                            if (!_hasVisibleAction(order, user.role))
                              const Text(
                                'No hay acciones disponibles para tu rol en esta etapa.',
                                style: TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 18),
                    _DetailCard(
                      title: 'Archivos asociados',
                      child: Column(
                        children: [
                          _FileTile(
                            icon: Icons.picture_as_pdf_outlined,
                            name: order.orderPdfName ?? 'Sin PDF de OT adjunto',
                            subtitle: 'Orden de trabajo',
                          ),
                          _FileTile(
                            icon: Icons.architecture_outlined,
                            name: order.dxfFileName ?? 'DXF pendiente',
                            subtitle: 'Archivo de fabricación',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _DetailCard(
                      title: 'Historial',
                      child: order.history.isEmpty
                          ? const Text(
                              'Todavía no hay movimientos registrados.',
                              style: TextStyle(color: Colors.grey),
                            )
                          : Column(
                              children: order.history
                                  .map((item) => _HistoryTile(log: item))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _hasVisibleAction(WorkOrder order, UserRole role) {
    if (!order.orderPlaced && _can(role, 'pedido')) return true;
    if (order.orderPlaced && !order.dxfUploaded && _can(role, 'dxf')) {
      return true;
    }
    if (order.dxfUploaded && !order.received && _can(role, 'recepcion')) {
      return true;
    }
    if (order.productionProgress == 100 &&
        !order.finished &&
        _can(role, 'finalizar')) {
      return true;
    }
    if (order.received &&
        !order.finished &&
        (_can(role, 'soldadura') || _can(role, 'maestranza'))) {
      return true;
    }
    return false;
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 205,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final bool active;
  final bool last;

  const _ProcessStep({
    required this.title,
    required this.subtitle,
    this.completed = false,
    this.active = false,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = completed
        ? Colors.green
        : active
            ? kPrimary
            : Colors.grey;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 38,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: color.withValues(alpha: .12),
                  child: Icon(
                    completed
                        ? Icons.check
                        : active
                            ? Icons.circle
                            : Icons.circle_outlined,
                    size: 17,
                    color: color,
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: const Color(0xFFE4E8ED),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaProgress extends StatelessWidget {
  final String name;
  final int progress;
  final VoidCallback? onEdit;

  const _AreaProgress({
    required this.name,
    required this.progress,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            Text(
              '$progress%',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: progressColor(progress),
              ),
            ),
            if (onEdit != null) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Actualizar avance',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ],
        ),
        const SizedBox(height: 9),
        ProgressBar(progress: progress, height: 10),
      ],
    );
  }
}

class _FileTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final String subtitle;

  const _FileTile({
    required this.icon,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: kPrimary.withValues(alpha: .10),
        child: Icon(icon, color: kPrimary),
      ),
      title: Text(name),
      subtitle: Text(subtitle),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final ActivityLog log;

  const _HistoryTile({required this.log});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        radius: 17,
        backgroundColor: Color(0xFFF0F4F8),
        child: Icon(Icons.history, size: 17, color: kPrimary),
      ),
      title: Text(log.title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${log.detail}\n${log.actor}'),
      trailing: Text(
        formatDateTime(log.timestamp),
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
      isThreeLine: true,
    );
  }
}
