import 'package:flutter/material.dart';

void main() {
  runApp(const Erp2RMApp());
}

class Erp2RMApp extends StatelessWidget {
  const Erp2RMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2RM ERP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F4E79),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8F0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF1F4E79),
              width: 2,
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

/* ============================================================
   MODELO DE ORDEN DE TRABAJO
   ============================================================ */

class WorkOrder {
  final String codigo;
  final String cliente;
  final String descripcion;
  final String estado;
  final int progreso;
  final int soldadura;
  final int maestranza;
  final String fechaInicio;
  final String fechaEntrega;
  final String supervisorSoldadura;
  final String supervisorMaestranza;

  const WorkOrder({
    required this.codigo,
    required this.cliente,
    required this.descripcion,
    required this.estado,
    required this.progreso,
    required this.soldadura,
    required this.maestranza,
    required this.fechaInicio,
    required this.fechaEntrega,
    required this.supervisorSoldadura,
    required this.supervisorMaestranza,
  });
}

/* ============================================================
   DATOS SIMULADOS
   ============================================================ */

const List<WorkOrder> workOrders = [
  WorkOrder(
    codigo: 'OT-000148',
    cliente: 'Alicorp S.A.A.',
    descripcion: 'Fabricación de estructura metálica',
    estado: 'En producción',
    progreso: 76,
    soldadura: 85,
    maestranza: 57,
    fechaInicio: '28/08/2026',
    fechaEntrega: '05/09/2026',
    supervisorSoldadura: 'Carlos Ramírez',
    supervisorMaestranza: 'José Mendoza',
  ),
  WorkOrder(
    codigo: 'OT-000149',
    cliente: 'Industrias del Perú',
    descripcion: 'Fabricación de base para motor industrial',
    estado: 'En maestranza',
    progreso: 51,
    soldadura: 70,
    maestranza: 42,
    fechaInicio: '27/08/2026',
    fechaEntrega: '03/09/2026',
    supervisorSoldadura: 'Carlos Ramírez',
    supervisorMaestranza: 'José Mendoza',
  ),
  WorkOrder(
    codigo: 'OT-000150',
    cliente: 'Corporación Andina',
    descripcion: 'Fabricación de tanque inoxidable',
    estado: 'Esperando material',
    progreso: 32,
    soldadura: 0,
    maestranza: 0,
    fechaInicio: '28/08/2026',
    fechaEntrega: '08/09/2026',
    supervisorSoldadura: 'Luis Torres',
    supervisorMaestranza: 'José Mendoza',
  ),
  WorkOrder(
    codigo: 'OT-000147',
    cliente: 'Minera del Sur',
    descripcion: 'Fabricación de plataforma industrial',
    estado: 'Completada',
    progreso: 100,
    soldadura: 100,
    maestranza: 100,
    fechaInicio: '18/08/2026',
    fechaEntrega: '27/08/2026',
    supervisorSoldadura: 'Carlos Ramírez',
    supervisorMaestranza: 'José Mendoza',
  ),
];

/* ============================================================
   LOGIN
   ============================================================ */

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();

  bool ocultarPassword = true;

  void iniciarSesion() {
    if (usuarioController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingrese su usuario y contraseña',
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 900)
            Expanded(
              child: Container(
                color: const Color(0xFF172B3A),
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8C32),
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            '2RM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Gestión inteligente\nde producción',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Seguimiento de órdenes de trabajo, '
                        'producción y procesos internos de 2RM.',
                        style: TextStyle(
                          color:
                              Colors.white.withValues(alpha: 0.70),
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      if (MediaQuery.of(context).size.width < 900)
                        Container(
                          width: 65,
                          height: 65,
                          margin:
                              const EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8C32),
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              '2RM',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                          color: Color(0xFF172B3A),
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ingrese sus credenciales para acceder al ERP.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Usuario',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: usuarioController,
                        decoration: const InputDecoration(
                          hintText: 'Ingrese su usuario',
                          prefixIcon:
                              Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Contraseña',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        obscureText: ocultarPassword,
                        onSubmitted: (_) => iniciarSesion(),
                        decoration: InputDecoration(
                          hintText: 'Ingrese su contraseña',
                          prefixIcon:
                              const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                ocultarPassword =
                                    !ocultarPassword;
                              });
                            },
                            icon: Icon(
                              ocultarPassword
                                  ? Icons.visibility_outlined
                                  : Icons
                                      .visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: iniciarSesion,
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF1F4E79),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Iniciar sesión',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Center(
                        child: Text(
                          'ERP 2RM · Gestión de Producción',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   ESTRUCTURA PRINCIPAL
   ============================================================ */

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  final pages = const [
    DashboardHome(),
    WorkOrdersPage(),
    PlaceholderPage(
      icon: Icons.people_alt_outlined,
      title: 'Usuarios',
      description:
          'Aquí administraremos los usuarios y sus roles.',
    ),
    PlaceholderPage(
      icon: Icons.bar_chart_outlined,
      title: 'Reportes',
      description:
          'Aquí tendremos indicadores y reportes de producción.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.of(context).size.width >= 900;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            Sidebar(
              selectedIndex: selectedIndex,
              onChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            Expanded(
              child: pages[selectedIndex],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '2RM ERP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'OT',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Usuarios',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reportes',
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   SIDEBAR
   ============================================================ */

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF172B3A),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C32),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      '2RM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
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
                      'Producción',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 45),
          SidebarItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          SidebarItem(
            icon: Icons.assignment_outlined,
            title: 'Órdenes de trabajo',
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
          SidebarItem(
            icon: Icons.people_outline,
            title: 'Usuarios',
            selected: selectedIndex == 2,
            onTap: () => onChanged(2),
          ),
          SidebarItem(
            icon: Icons.bar_chart_outlined,
            title: 'Reportes',
            selected: selectedIndex == 3,
            onTap: () => onChanged(3),
          ),
          const Spacer(),
          const Divider(color: Colors.white12),
          SidebarItem(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            selected: false,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected
                      ? Colors.white
                      : Colors.white60,
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.white60,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.normal,
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

/* ============================================================
   DASHBOARD
   ============================================================ */

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              color: Color(0xFF172B3A),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Resumen general de producción',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              int columns = 4;

              if (width < 600) {
                columns = 1;
              } else if (width < 1000) {
                columns = 2;
              }

              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio:
                    columns == 1 ? 3.5 : 1.8,
                children: const [
                  MetricCard(
                    title: 'OT Activas',
                    value: '17',
                    icon: Icons.precision_manufacturing,
                  ),
                  MetricCard(
                    title: 'En producción',
                    value: '12',
                    icon: Icons.build_outlined,
                  ),
                  MetricCard(
                    title: 'Atrasadas',
                    value: '4',
                    icon: Icons.warning_amber,
                  ),
                  MetricCard(
                    title: 'Completadas',
                    value: '9',
                    icon: Icons.check_circle_outline,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Órdenes en seguimiento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Ver todas'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...workOrders
              .take(3)
              .map(
                (ot) => WorkOrderCard(
                  workOrder: ot,
                ),
              ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8ECF1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF1F4E79).withValues(alpha: .10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1F4E79),
            ),
          ),
          const SizedBox(width: 18),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
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

/* ============================================================
   LISTADO DE OT
   ============================================================ */

class WorkOrdersPage extends StatelessWidget {
  const WorkOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Órdenes de trabajo',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B3A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Seguimiento y control de todas las OT.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText:
                        'Buscar por OT, cliente o descripción...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Nueva OT'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 19,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ...workOrders.map(
            (ot) => WorkOrderCard(
              workOrder: ot,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkOrderCard extends StatelessWidget {
  final WorkOrder workOrder;

  const WorkOrderCard({
    super.key,
    required this.workOrder,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = const Color(0xFF1F4E79);

    if (workOrder.progreso == 100) {
      statusColor = Colors.green;
    }

    if (workOrder.estado == 'Esperando material') {
      statusColor = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkOrderDetailScreen(
                  workOrder: workOrder,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            workOrder.codigo,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            workOrder.descripcion,
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            workOrder.cliente,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor
                            .withValues(alpha: .10),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        workOrder.estado,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value:
                              workOrder.progreso / 100,
                          minHeight: 9,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '${workOrder.progreso}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
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

/* ============================================================
   DETALLE DE OT
   ============================================================ */

class WorkOrderDetailScreen extends StatelessWidget {
  final WorkOrder workOrder;

  const WorkOrderDetailScreen({
    super.key,
    required this.workOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workOrder.codigo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            workOrder.codigo,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            workOrder.descripcion,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${workOrder.progreso}%',
                      style: const TextStyle(
                        color: Color(0xFF1F4E79),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: workOrder.progreso / 100,
                  minHeight: 13,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                const SizedBox(height: 35),
                DetailCard(
                  title: 'Información general',
                  child: Wrap(
                    spacing: 60,
                    runSpacing: 25,
                    children: [
                      InfoItem(
                        title: 'Cliente',
                        value: workOrder.cliente,
                      ),
                      InfoItem(
                        title: 'Estado',
                        value: workOrder.estado,
                      ),
                      InfoItem(
                        title: 'Fecha inicio',
                        value: workOrder.fechaInicio,
                      ),
                      InfoItem(
                        title: 'Fecha entrega',
                        value: workOrder.fechaEntrega,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const DetailCard(
                  title: 'Etapas de la OT',
                  child: Column(
                    children: [
                      ProcessStep(
                        title: 'OT aprobada',
                        subtitle:
                            'Orden registrada y aprobada',
                        completed: true,
                      ),
                      ProcessStep(
                        title:
                            'Pedido realizado',
                        subtitle:
                            'Cotizaciones realizó el pedido',
                        completed: true,
                      ),
                      ProcessStep(
                        title: 'Plano DXF',
                        subtitle:
                            'Archivo DXF cargado',
                        completed: true,
                      ),
                      ProcessStep(
                        title:
                            'Material recibido',
                        subtitle:
                            'Recepción confirmada',
                        completed: true,
                      ),
                      ProcessStep(
                        title: 'Producción',
                        subtitle:
                            'Trabajo actualmente en proceso',
                        completed: false,
                        active: true,
                      ),
                      ProcessStep(
                        title: 'OT finalizada',
                        subtitle:
                            'Pendiente de completar',
                        completed: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DetailCard(
                  title: 'Producción',
                  child: Column(
                    children: [
                      AreaProgress(
                        area: 'Soldadura',
                        supervisor:
                            workOrder.supervisorSoldadura,
                        progress:
                            workOrder.soldadura,
                      ),
                      const SizedBox(height: 25),
                      AreaProgress(
                        area: 'Maestranza',
                        supervisor:
                            workOrder.supervisorMaestranza,
                        progress:
                            workOrder.maestranza,
                      ),
                    ],
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

class DetailCard extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE7EBEF),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const InfoItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ProcessStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final bool active;

  const ProcessStep({
    super.key,
    required this.title,
    required this.subtitle,
    this.completed = false,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;

    if (completed) {
      color = Colors.green;
    } else if (active) {
      color = const Color(0xFF1F4E79);
    } else {
      color = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                color.withValues(alpha: .12),
            child: Icon(
              completed
                  ? Icons.check
                  : active
                      ? Icons.precision_manufacturing
                      : Icons.circle_outlined,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
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

class AreaProgress extends StatelessWidget {
  final String area;
  final String supervisor;
  final int progress;

  const AreaProgress({
    super.key,
    required this.area,
    required this.supervisor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    area,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Supervisor: $supervisor',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$progress%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress / 100,
          minHeight: 9,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}

/* ============================================================
   PLACEHOLDERS
   ============================================================ */

class PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PlaceholderPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}