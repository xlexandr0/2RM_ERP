import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models.dart';
import 'widgets.dart';

class OrderDetailScreen
    extends StatelessWidget {
  final int orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final state =
        AppState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final order =
            state.orderById(orderId);

        final user =
            state.currentUser!;

        return Scaffold(
          appBar: AppBar(
            title: Text(order.code),
          ),
          body:
              SingleChildScrollView(
            padding:
                const EdgeInsets.all(28),
            child: Center(
              child:
                  ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 1120,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets
                              .all(24),
                      decoration:
                          cardDecoration(
                        overdue:
                            order.isOverdue,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Expanded(
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          order
                                              .code,
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                30,
                                            fontWeight:
                                                FontWeight.w900,
                                          ),
                                        ),
                                        if (order
                                            .isOverdue) ...[
                                          const SizedBox(
                                            width:
                                                10,
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal:
                                                  10,
                                              vertical:
                                                  5,
                                            ),
                                            decoration:
                                                BoxDecoration(
                                              color: Colors.red.withOpacity(
                                                .12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                            child:
                                                const Text(
                                              'ATRASADA',
                                              style:
                                                  TextStyle(
                                                color:
                                                    Colors.red,
                                                fontWeight:
                                                    FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      order
                                          .description,
                                      style:
                                          const TextStyle(
                                        fontSize:
                                            16,
                                      ),
                                    ),
                                    Text(
                                      order.client,
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .end,
                                children: [
                                  const Text(
                                    'Fecha de entrega',
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    formatDate(
                                      order
                                          .originalDueDate,
                                    ),
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.w900,
                                      fontSize:
                                          16,
                                    ),
                                  ),
                                  if (order
                                          .revisedDueDate !=
                                      null) ...[
                                    const SizedBox(
                                      height:
                                          8,
                                    ),
                                    const Text(
                                      'Nueva fecha de entrega',
                                      style:
                                          TextStyle(
                                        color:
                                            Colors.red,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      formatDate(
                                        order
                                            .revisedDueDate!,
                                      ),
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.red,
                                        fontWeight:
                                            FontWeight.w900,
                                        fontSize:
                                            16,
                                      ),
                                    ),
                                  ],
                                  if (user
                                      .canChangeDeliveryDate) ...[
                                    const SizedBox(
                                      height:
                                          10,
                                    ),
                                    OutlinedButton
                                        .icon(
                                      onPressed:
                                          () {
                                        changeDate(
                                          context,
                                          order,
                                        );
                                      },
                                      icon:
                                          const Icon(
                                        Icons
                                            .edit_calendar,
                                      ),
                                      label:
                                          const Text(
                                        'Cambiar fecha',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 35,
                          ),

                          // =========================
                          // LOS 3 CÍRCULOS
                          // =========================

                          LayoutBuilder(
                            builder:
                                (context, constraints) {
                              final vertical =
                                  constraints.maxWidth <
                                      650;

                              final circles = [
                                ProgressCircle(
                                  title:
                                      'Avance total de la OT',
                                  percentage:
                                      order.totalProgress,
                                ),

                                ProgressCircle(
                                  title:
                                      'Maestranza / Soldadura',
                                  percentage:
                                      order.productionProgress,
                                  editable:
                                      user.canChangeProduction,
                                  onTap: user
                                          .canChangeProduction
                                      ? () {
                                          changeProduction(
                                            context,
                                            order,
                                          );
                                        }
                                      : null,
                                ),

                                ProgressCircle(
                                  title:
                                      'Material recibido',
                                  percentage:
                                      order.materialProgress,
                                  editable:
                                      user.canChangeMaterial,
                                  onTap: user
                                          .canChangeMaterial
                                      ? () {
                                          changeMaterial(
                                            context,
                                            order,
                                          );
                                        }
                                      : null,
                                ),
                              ];

                              if (vertical) {
                                return Column(
                                  children: [
                                    for (final circle
                                        in circles) ...[
                                      circle,
                                      const SizedBox(
                                        height:
                                            25,
                                      ),
                                    ],
                                  ],
                                );
                              }

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceEvenly,
                                children:
                                    circles,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    SectionCard(
                      title:
                          'Tareas realizadas',
                      action:
                          user.canManageTasks
                              ? FilledButton
                                  .icon(
                                  onPressed:
                                      () {
                                    showAddTaskDialog(
                                      context,
                                      order,
                                    );
                                  },
                                  icon:
                                      const Icon(
                                    Icons.add_task,
                                  ),
                                  label:
                                      const Text(
                                    'Agregar tarea',
                                  ),
                                )
                              : null,
                      child:
                          order.tasks.isEmpty
                              ? const Text(
                                  'No existen tareas.',
                                )
                              : Column(
                                  children:
                                      order.tasks.map(
                                    (task) {
                                      final assigned =
                                          state
                                                  .userByUsername(
                                                    task.assignedUsername,
                                                  )
                                                  ?.name ??
                                              task.assignedUsername;

                                      final editable =
                                          task.assignedUsername ==
                                                  user.username ||
                                              user.role ==
                                                  UserRole.admin;

                                      return TaskTile(
                                        task:
                                            task,
                                        assignedName:
                                            assigned,
                                        editable:
                                            editable,
                                        onTap: editable
                                            ? () {
                                                changeTaskProgress(
                                                  context,
                                                  order,
                                                  task,
                                                );
                                              }
                                            : null,
                                      );
                                    },
                                  ).toList(),
                                ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    SectionCard(
                      title: 'Archivos',
                      child: Column(
                        children: [
                          ListTile(
                            leading:
                                const Icon(
                              Icons
                                  .picture_as_pdf,
                            ),
                            title: Text(
                              order.pdfName ??
                                  'Sin PDF',
                            ),
                            subtitle:
                                const Text(
                              'Orden de trabajo',
                            ),
                          ),
                          ListTile(
                            leading:
                                const Icon(
                              Icons
                                  .architecture,
                            ),
                            title: Text(
                              order.dxfName ??
                                  'Sin DXF',
                            ),
                            subtitle:
                                const Text(
                              'Archivo DXF',
                            ),
                            trailing:
                                OutlinedButton.icon(
                              onPressed:
                                  () {
                                pickDxf(
                                  context,
                                  order,
                                );
                              },
                              icon:
                                  const Icon(
                                Icons
                                    .upload_file,
                              ),
                              label:
                                  const Text(
                                'Seleccionar',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    SectionCard(
                      title: 'Historial',
                      child:
                          order.history.isEmpty
                              ? const Text(
                                  'Sin movimientos.',
                                )
                              : Column(
                                  children:
                                      order.history.map(
                                    (entry) {
                                      return ListTile(
                                        leading:
                                            const CircleAvatar(
                                          child:
                                              Icon(
                                            Icons.history,
                                          ),
                                        ),
                                        title:
                                            Text(
                                          entry.title,
                                        ),
                                        subtitle:
                                            Text(
                                          '${entry.detail}\n'
                                          'Usuario: ${entry.byUser}',
                                        ),
                                        trailing:
                                            Text(
                                          formatDateTime(
                                            entry.date,
                                          ),
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                10,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                    ),

                    if (user.canCloseOrder &&
                        order.canClose) ...[
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        width:
                            double.infinity,
                        height: 52,
                        child:
                            FilledButton.icon(
                          onPressed:
                              () async {
                            await state
                                .closeOrder(
                              order.id,
                            );
                          },
                          icon:
                              const Icon(
                            Icons.task_alt,
                          ),
                          label:
                              const Text(
                            'Cerrar OT al 100%',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> changeProduction(
    BuildContext context,
    WorkOrder order,
  ) async {
    final value =
        await showStepProgressDialog(
      context,
      title:
          'Maestranza / Soldadura',
      currentValue:
          order.productionProgress,
    );

    if (value == null) {
      return;
    }

    await AppState.instance
        .updateProductionProgress(
      orderId: order.id,
      value: value,
    );
  }

  Future<void> changeMaterial(
    BuildContext context,
    WorkOrder order,
  ) async {
    final value =
        await showStepProgressDialog(
      context,
      title: 'Material recibido',
      currentValue:
          order.materialProgress,
    );

    if (value == null) {
      return;
    }

    await AppState.instance
        .updateMaterialProgress(
      orderId: order.id,
      value: value,
    );
  }

  Future<void> changeTaskProgress(
    BuildContext context,
    WorkOrder order,
    WorkTask task,
  ) async {
    final value =
        await showStepProgressDialog(
      context,
      title:
          'Avance: ${task.title}',
      currentValue: task.progress,
    );

    if (value == null) {
      return;
    }

    await AppState.instance
        .updateTaskProgress(
      orderId: order.id,
      taskId: task.id,
      value: value,
    );
  }

  Future<void> changeDate(
    BuildContext context,
    WorkOrder order,
  ) async {
    final selected =
        await showDatePicker(
      context: context,
      initialDate:
          order.activeDueDate,
      firstDate:
          DateTime(2024),
      lastDate:
          DateTime(2035),
    );

    if (selected == null) {
      return;
    }

    await AppState.instance
        .changeDeliveryDate(
      orderId: order.id,
      newDate: selected,
    );
  }

  Future<void> pickDxf(
    BuildContext context,
    WorkOrder order,
  ) async {
    final result =
        await FilePicker.platform
            .pickFiles(
      type: FileType.custom,
      allowedExtensions: const [
        'dxf',
      ],
    );

    if (result == null ||
        result.files.isEmpty) {
      return;
    }

    final file =
        result.files.single;

    await AppState.instance
        .attachDxf(
      orderId: order.id,
      fileName: file.name,
      filePath: file.path,
    );
  }

  Future<void> showAddTaskDialog(
    BuildContext context,
    WorkOrder order,
  ) async {
    final state =
        AppState.instance;

    final titleController =
        TextEditingController();

    final descriptionController =
        TextEditingController();

    final assignable =
        state.users
            .where(
              (user) =>
                  user.active,
            )
            .toList();

    if (assignable.isEmpty) {
      return;
    }

    String selectedUsername =
        assignable.first.username;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              title:
                  const Text(
                'Agregar tarea',
              ),
              content: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                          titleController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Título',
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller:
                          descriptionController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Descripción',
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    DropdownButtonFormField<
                        String>(
                      value:
                          selectedUsername,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Responsable',
                      ),
                      items:
                          assignable.map(
                        (user) {
                          return DropdownMenuItem<
                              String>(
                            value:
                                user.username,
                            child:
                                Text(
                              '${user.name} · ${user.role.label}',
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
                              selectedUsername =
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
                    if (titleController
                        .text
                        .trim()
                        .isEmpty) {
                      return;
                    }

                    await state
                        .addTask(
                      orderId:
                          order.id,
                      title:
                          titleController
                              .text
                              .trim(),
                      description:
                          descriptionController
                              .text
                              .trim(),
                      assignedUsername:
                          selectedUsername,
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
                    'Agregar',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class SectionCard
    extends StatelessWidget {
  final String title;

  final Widget child;

  final Widget? action;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),
      decoration:
          cardDecoration(),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style:
                      const TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
              if (action != null)
                action!,
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}