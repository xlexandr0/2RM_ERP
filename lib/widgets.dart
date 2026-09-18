import 'package:flutter/material.dart';

import 'models.dart';

Color progressColor(int percentage) {
  final value =
      percentage.clamp(0, 100);

  if (value <= 50) {
    return Color.lerp(
      Colors.red,
      Colors.purple,
      value / 50,
    )!;
  }

  return Color.lerp(
    Colors.purple,
    Colors.blue,
    (value - 50) / 50,
  )!;
}

String formatDate(DateTime value) {
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/'
      '${value.year}';
}

String formatDateTime(DateTime value) {
  return '${formatDate(value)} '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

BoxDecoration cardDecoration({
  bool overdue = false,
}) {
  return BoxDecoration(
    color: overdue
        ? const Color(0xFFFFEEEE)
        : Colors.white,
    borderRadius:
        BorderRadius.circular(16),
    border: Border.all(
      color: overdue
          ? Colors.red.shade300
          : const Color(0xFFE4E8EE),
      width: overdue ? 1.7 : 1,
    ),
  );
}

class BrandLogo extends StatelessWidget {
  final double size;

  const BrandLogo({
    super.key,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFF8C32),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Text(
        '2RM',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: size * 0.28,
        ),
      ),
    );
  }
}

class ProgressCircle extends StatelessWidget {
  final String title;

  final int percentage;

  final double size;

  final bool editable;

  final VoidCallback? onTap;

  const ProgressCircle({
    super.key,
    required this.title,
    required this.percentage,
    this.size = 115,
    this.editable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        progressColor(percentage);

    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child:
                    CircularProgressIndicator(
                  value:
                      percentage / 100,
                  strokeWidth: 9,
                  backgroundColor:
                      Colors.grey.shade200,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(
                    color,
                  ),
                ),
              ),
              Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize:
                          size * 0.20,
                      fontWeight:
                          FontWeight.w900,
                      color: color,
                    ),
                  ),
                  if (editable)
                    Icon(
                      Icons.edit,
                      color: color,
                      size: 16,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: size + 50,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight:
                  FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );

    if (!editable ||
        onTap == null) {
      return child;
    }

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(100),
      child: Padding(
        padding:
            const EdgeInsets.all(5),
        child: child,
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  final WorkTask task;

  final String assignedName;

  final bool editable;

  final VoidCallback? onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.assignedName,
    this.editable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        progressColor(task.progress);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              const Color(0xFFE6EAF0),
        ),
      ),
      child: InkWell(
        onTap:
            editable ? onTap : null,
        borderRadius:
            BorderRadius.circular(14),
        child: Padding(
          padding:
              const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      task.title,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    if (task
                        .description
                        .isNotEmpty) ...[
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        task.description,
                        style:
                            const TextStyle(
                          color:
                              Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Responsable: '
                      '$assignedName',
                      style:
                          const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      task.status.label,
                      style: TextStyle(
                        color: color,
                        fontWeight:
                            FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ProgressCircle(
                title: editable
                    ? 'Editar'
                    : '',
                percentage:
                    task.progress,
                size: 60,
                editable: editable,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final WorkOrder order;

  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        progressColor(
      order.totalProgress,
    );

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      decoration: cardDecoration(
        overdue: order.isOverdue,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(16),
        child: Padding(
          padding:
              const EdgeInsets.all(19),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Wrap(
                      spacing: 9,
                      runSpacing: 6,
                      children: [
                        Text(
                          order.code,
                          style:
                              const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight
                                    .w900,
                          ),
                        ),
                        if (order
                            .isOverdue)
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors
                                  .red
                                  .withOpacity(
                                      .13),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          20),
                            ),
                            child:
                                const Text(
                              'ATRASADA',
                              style:
                                  TextStyle(
                                color:
                                    Colors.red,
                                fontWeight:
                                    FontWeight
                                        .w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      order.description,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    Text(
                      order.client,
                      style:
                          const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child:
                              LinearProgressIndicator(
                            value: order
                                    .totalProgress /
                                100,
                            minHeight: 9,
                            backgroundColor:
                                Colors.grey
                                    .shade200,
                            valueColor:
                                AlwaysStoppedAnimation<
                                    Color>(
                              color,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(20),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${order.totalProgress}%',
                          style: TextStyle(
                            color: color,
                            fontWeight:
                                FontWeight
                                    .w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              SizedBox(
                width: 190,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Fecha de entrega',
                      style:
                          TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
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
                            FontWeight.w800,
                      ),
                    ),
                    if (order
                            .revisedDueDate !=
                        null) ...[
                      const SizedBox(
                        height: 7,
                      ),
                      const Text(
                        'Nueva fecha de entrega',
                        textAlign:
                            TextAlign.right,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight:
                              FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        formatDate(
                          order
                              .revisedDueDate!,
                        ),
                        style:
                            const TextStyle(
                          color: Colors.red,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<int?> showStepProgressDialog(
  BuildContext context, {
  required String title,
  required int currentValue,
}) {
  int selected = currentValue;

  return showDialog<int>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (
          context,
          setState,
        ) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                0,
                25,
                50,
                75,
                100,
              ].map((value) {
                return RadioListTile<int>(
                  value: value,
                  groupValue: selected,
                  title:
                      Text('$value%'),
                  secondary: Icon(
                    Icons.circle,
                    color:
                        progressColor(
                      value,
                    ),
                  ),
                  onChanged:
                      (newValue) {
                    if (newValue ==
                        null) {
                      return;
                    }

                    setState(() {
                      selected =
                          newValue;
                    });
                  },
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(
                  dialogContext,
                ),
                child:
                    const Text(
                  'Cancelar',
                ),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.pop(
                  dialogContext,
                  selected,
                ),
                child:
                    const Text(
                  'Guardar',
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class PageHeader extends StatelessWidget {
  final String title;

  final String subtitle;

  final Widget? action;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 14,
      alignment:
          WrapAlignment.spaceBetween,
      crossAxisAlignment:
          WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 600,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                subtitle,
                style:
                    const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (action != null)
          action!,
      ],
    );
  }
}