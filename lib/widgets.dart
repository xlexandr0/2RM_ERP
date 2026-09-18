import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';

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

IconData iconForRole(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return Icons.admin_panel_settings_outlined;
    case UserRole.gerencia:
      return Icons.dashboard_outlined;
    case UserRole.cotizaciones:
      return Icons.shopping_cart_outlined;
    case UserRole.dibujante:
      return Icons.architecture_outlined;
    case UserRole.chofer:
      return Icons.local_shipping_outlined;
    case UserRole.supervisorSoldadura:
      return Icons.handyman_outlined;
    case UserRole.supervisorMaestranza:
      return Icons.precision_manufacturing_outlined;
  }
}

Color statusColor(WorkOrder order) {
  if (order.finished) return Colors.green;
  if (order.isLate) return Colors.red;
  return progressColor(order.progress);
}

class BrandLogo extends StatelessWidget {
  final double size;

  const BrandLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kOrange,
        borderRadius: BorderRadius.circular(size * .2),
      ),
      child: Text(
        '2RM',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * .28,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172B3A),
                ),
              ),
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const StatusChip({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final int progress;
  final double height;

  const ProgressBar({
    super.key,
    required this.progress,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final color = progressColor(progress);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress / 100),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, _) {
        return LinearProgressIndicator(
          value: value,
          minHeight: height,
          backgroundColor: const Color(0xFFE8ECF1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(20),
        );
      },
    );
  }
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? accent;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final color = accent ?? kPrimary;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(label, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final WorkOrder order;
  final VoidCallback onTap;
  final Widget? trailingAction;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    final color = statusColor(order);
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(21),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE6EAF0)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
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
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            order.description,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${order.client} · Entrega ${formatDate(order.dueDate)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (trailingAction != null) ...[
                      trailingAction!,
                      const SizedBox(width: 8),
                    ],
                    StatusChip(
                      text: order.isLate && !order.finished
                          ? 'Atrasada'
                          : order.status,
                      color: color,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: ProgressBar(progress: order.progress)),
                    const SizedBox(width: 14),
                    SizedBox(
                      width: 46,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
      decoration: cardDecoration(),
      child: Column(
        children: [
          Icon(icon, size: 58, color: Colors.grey.shade400),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
