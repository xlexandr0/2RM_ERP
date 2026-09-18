import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  static const String _storageKey =
      'erp_2rm_v4_data';

  SharedPreferences? _preferences;

  AppUser? currentUser;

  List<AppUser> users = [];

  List<WorkOrder> orders = [];

  final List<int> allowedProgress = const [
    0,
    25,
    50,
    75,
    100,
  ];

  int _nextUserId = 11;

  int _nextOrderId = 3;

  int _nextOrderNumber = 160;

  int _nextTaskId = 11;

  Future<void> init() async {
    _preferences =
        await SharedPreferences.getInstance();

    final saved =
        _preferences!.getString(_storageKey);

    if (saved == null) {
      _createDemoData();

      await save();

      return;
    }

    try {
      final data =
          jsonDecode(saved) as Map<String, dynamic>;

      users =
          ((data['users'] as List?) ?? [])
              .map(
                (item) => AppUser.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();

      orders =
          ((data['orders'] as List?) ?? [])
              .map(
                (item) => WorkOrder.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();

      _nextUserId =
          data['nextUserId'] ?? 11;

      _nextOrderId =
          data['nextOrderId'] ?? 3;

      _nextOrderNumber =
          data['nextOrderNumber'] ?? 160;

      _nextTaskId =
          data['nextTaskId'] ?? 11;

      if (users.isEmpty) {
        _createDemoData();

        await save();
      }
    } catch (e) {
      _createDemoData();

      await save();
    }
  }

  void _createDemoData() {
    users = [
      AppUser(
        id: 1,
        name: 'Administrador 2RM',
        username: 'admin',
        password: '1234',
        role: UserRole.admin,
      ),
      AppUser(
        id: 2,
        name: 'Almacén',
        username: 'almacen',
        password: '1234',
        role: UserRole.almacen,
      ),
      AppUser(
        id: 3,
        name: 'Logística',
        username: 'logistica',
        password: '1234',
        role: UserRole.logistica,
      ),
      AppUser(
        id: 4,
        name: 'Contabilidad',
        username: 'contabilidad',
        password: '1234',
        role: UserRole.contabilidad,
      ),
      AppUser(
        id: 5,
        name: 'Jefatura 1',
        username: 'jefatura1',
        password: '1234',
        role: UserRole.jefatura,
      ),
      AppUser(
        id: 6,
        name: 'Jefatura 2',
        username: 'jefatura2',
        password: '1234',
        role: UserRole.jefatura,
      ),
      AppUser(
        id: 7,
        name: 'Supervisor 1',
        username: 'supervisor1',
        password: '1234',
        role: UserRole.supervisor,
      ),
      AppUser(
        id: 8,
        name: 'Supervisor 2',
        username: 'supervisor2',
        password: '1234',
        role: UserRole.supervisor,
      ),
      AppUser(
        id: 9,
        name: 'Cotizaciones 1',
        username: 'cotizaciones1',
        password: '1234',
        role: UserRole.cotizaciones,
      ),
      AppUser(
        id: 10,
        name: 'Cotizaciones 2',
        username: 'cotizaciones2',
        password: '1234',
        role: UserRole.cotizaciones,
      ),
    ];

    final now = DateTime.now();

    orders = [
      WorkOrder(
        id: 1,
        code: 'OT-000158',
        client: 'Aceros del Perú',
        description:
            'Fabricación de estructura metálica',
        originalDueDate:
            now.add(const Duration(days: 5)),
        productionProgress: 75,
        materialProgress: 50,
        tasks: [
          WorkTask(
            id: 1,
            title: 'Cotizar material',
            description:
                'Realizar la cotización inicial.',
            assignedUsername: 'cotizaciones1',
            progress: 100,
            status: TaskStatus.completed,
          ),
          WorkTask(
            id: 2,
            title: 'Generar pedido',
            description:
                'Generar pedido de materiales.',
            assignedUsername: 'cotizaciones2',
            progress: 100,
            status: TaskStatus.completed,
          ),
          WorkTask(
            id: 3,
            title: 'Coordinar transporte',
            description:
                'Coordinar recojo y traslado.',
            assignedUsername: 'logistica',
            progress: 75,
            status: TaskStatus.inProgress,
          ),
          WorkTask(
            id: 4,
            title: 'Ingreso de material',
            description:
                'Registrar material recibido.',
            assignedUsername: 'almacen',
            progress: 50,
            status: TaskStatus.inProgress,
          ),
          WorkTask(
            id: 5,
            title: 'Fabricación',
            description:
                'Trabajo de producción.',
            assignedUsername: 'supervisor1',
            progress: 75,
            status: TaskStatus.inProgress,
          ),
          WorkTask(
            id: 6,
            title: 'Control dimensional',
            description:
                'Verificar medidas.',
            assignedUsername: 'supervisor2',
            progress: 25,
            status: TaskStatus.inProgress,
          ),
          WorkTask(
            id: 7,
            title: 'Validación contable',
            description:
                'Validar documentación.',
            assignedUsername: 'contabilidad',
            progress: 25,
            status: TaskStatus.inProgress,
          ),
        ],
      ),

      // Esta OT se crea vencida para probar
      // automáticamente el fondo rojo.
      WorkOrder(
        id: 2,
        code: 'OT-000159',
        client: 'Industrias del Perú',
        description:
            'Fabricación de soporte industrial',
        originalDueDate:
            now.subtract(const Duration(days: 1)),
        productionProgress: 25,
        materialProgress: 25,
        tasks: [
          WorkTask(
            id: 8,
            title: 'Cotización',
            description: 'Cotización inicial.',
            assignedUsername: 'cotizaciones1',
            progress: 100,
            status: TaskStatus.completed,
          ),
          WorkTask(
            id: 9,
            title: 'Recepción material',
            description:
                'Ingreso de material.',
            assignedUsername: 'almacen',
            progress: 25,
            status: TaskStatus.inProgress,
          ),
          WorkTask(
            id: 10,
            title: 'Maestranza',
            description:
                'Trabajo asignado.',
            assignedUsername: 'supervisor2',
            progress: 25,
            status: TaskStatus.inProgress,
          ),
        ],
      ),
    ];

    _nextUserId = 11;
    _nextOrderId = 3;
    _nextOrderNumber = 160;
    _nextTaskId = 11;
  }

  Future<void> save() async {
    final data = {
      'users':
          users.map((user) => user.toJson()).toList(),
      'orders':
          orders.map((order) => order.toJson()).toList(),
      'nextUserId': _nextUserId,
      'nextOrderId': _nextOrderId,
      'nextOrderNumber': _nextOrderNumber,
      'nextTaskId': _nextTaskId,
    };

    await _preferences?.setString(
      _storageKey,
      jsonEncode(data),
    );
  }

  AppUser? login(
    String username,
    String password,
  ) {
    final normalized =
        username.trim().toLowerCase();

    for (final user in users) {
      if (user.username.toLowerCase() ==
              normalized &&
          user.password == password &&
          user.active) {
        currentUser = user;

        notifyListeners();

        return user;
      }
    }

    return null;
  }

  void logout() {
    currentUser = null;

    notifyListeners();
  }

  WorkOrder orderById(int id) {
    return orders.firstWhere(
      (order) => order.id == id,
    );
  }

  AppUser? userByUsername(String username) {
    for (final user in users) {
      if (user.username == username) {
        return user;
      }
    }

    return null;
  }

  int get activeOrders =>
      orders.where((order) => !order.closed).length;

  int get overdueOrders =>
      orders.where((order) => order.isOverdue).length;

  int get closedOrders =>
      orders.where((order) => order.closed).length;

  int get activeUsers =>
      users.where((user) => user.active).length;

  Future<void> createOrder({
    required String client,
    required String description,
    required DateTime dueDate,
    String? pdfName,
    String? pdfPath,
  }) async {
    final user = currentUser;

    if (user == null ||
        !user.canCreateOrder) {
      return;
    }

    final code =
        'OT-${_nextOrderNumber.toString().padLeft(6, '0')}';

    final order = WorkOrder(
      id: _nextOrderId++,
      code: code,
      client: client,
      description: description,
      originalDueDate: dueDate,
      pdfName: pdfName,
      pdfPath: pdfPath,
      history: [
        HistoryEntry(
          title: 'OT creada',
          detail:
              'La orden de trabajo fue creada.',
          date: DateTime.now(),
          byUser: user.username,
        ),
      ],
    );

    _nextOrderNumber++;

    orders.insert(0, order);

    await save();

    notifyListeners();
  }

  Future<void> addTask({
    required int orderId,
    required String title,
    required String description,
    required String assignedUsername,
  }) async {
    final user = currentUser;

    if (user == null ||
        !user.canManageTasks) {
      return;
    }

    final order = orderById(orderId);

    order.tasks.add(
      WorkTask(
        id: _nextTaskId++,
        title: title,
        description: description,
        assignedUsername: assignedUsername,
      ),
    );

    order.history.insert(
      0,
      HistoryEntry(
        title: 'Tarea creada',
        detail:
            '$title asignada a $assignedUsername.',
        date: DateTime.now(),
        byUser: user.username,
      ),
    );

    await save();

    notifyListeners();
  }

  Future<void> updateTaskProgress({
    required int orderId,
    required int taskId,
    required int value,
  }) async {
    if (!allowedProgress.contains(value)) {
      return;
    }

    final user = currentUser;

    if (user == null) {
      return;
    }

    final order = orderById(orderId);

    final task = order.tasks.firstWhere(
      (task) => task.id == taskId,
    );

    final canEdit =
        task.assignedUsername == user.username ||
        user.role == UserRole.admin;

    if (!canEdit) {
      return;
    }

    final previous = task.progress;

    task.progress = value;

    if (value == 0) {
      task.status = TaskStatus.pending;
    } else if (value == 100) {
      task.status = TaskStatus.completed;
    } else {
      task.status = TaskStatus.inProgress;
    }

    order.history.insert(
      0,
      HistoryEntry(
        title: 'Avance de tarea',
        detail:
            '${task.title}: $previous% → $value%.',
        date: DateTime.now(),
        byUser: user.username,
      ),
    );

    await save();

    notifyListeners();
  }

  Future<void> updateProductionProgress({
    required int orderId,
    required int value,
  }) async {
    if (!allowedProgress.contains(value)) {
      return;
    }

    final user = currentUser;

    if (user == null ||
        !user.canChangeProduction) {
      return;
    }

    final order = orderById(orderId);

    final previous =
        order.productionProgress;

    order.productionProgress = value;

    order.history.insert(
      0,
      HistoryEntry(
        title: 'Avance de producción',
        detail:
            'Maestranza/Soldadura: '
            '$previous% → $value%.',
        date: DateTime.now(),
        byUser: user.username,
      ),
    );

    await save();

    notifyListeners();
  }

  Future<void> updateMaterialProgress({
    required int orderId,
    required int value,
  }) async {
    if (!allowedProgress.contains(value)) {
      return;
    }

    final user = currentUser;

    if (user == null ||
        !user.canChangeMaterial) {
      return;
    }

    final order = orderById(orderId);

    final previous =
        order.materialProgress;

    order.materialProgress = value;

    order.history.insert(
      0,
      HistoryEntry(
        title: 'Material recibido',
        detail:
            '$previous% → $value%.',
        date: DateTime.now(),
        byUser: user.username,
      ),
    );

    await save();

    notifyListeners();
  }

  Future<void> changeDeliveryDate({
    required int orderId,
    required DateTime newDate,
  }) async {
    final user = currentUser;

    // SOLO Jefatura 1 y Jefatura 2.
    if (user == null ||
        !user.canChangeDeliveryDate) {
      return;
    }

    final order = orderById(orderId);

    final previous =
        order.activeDueDate;

    order.revisedDueDate = newDate;

    order.history.insert(
      0,
      HistoryEntry(
        title: 'Nueva fecha de entrega',
        detail:
            '${_formatDate(previous)} → '
            '${_formatDate(newDate)}.',
        date: DateTime.now(),
        byUser: user.username,
      ),
    );

    await save();

    notifyListeners();
  }

  Future<void> attachDxf({
    required int orderId,
    required String fileName,
    required String? filePath,
  }) async {
    final user = currentUser;

    if (user == null) {
      return;
    }

    final order = orderById(orderId);

    order.dxfName = fileName;
    order.dxfPath = filePath;

    order.history.insert(
      0,
      HistoryEntry(
        title: 'DXF cargado',
        detail: fileName,
        date: DateTime.now(),
        byUser: user.username,
      ),
    );

    await save();

    notifyListeners();
  }

  Future<void> closeOrder(
    int orderId,
  ) async {
    final user = currentUser;

    if (user == null ||
        !user.canCloseOrder) {
      return;
    }

    final order = orderById(orderId);

    if (!order.canClose) {
      return;
    }

    order.closed = true;

    order.history.insert(
      0,
      HistoryEntry(
        title: 'OT finalizada',
        detail:
            'La OT fue cerrada al 100%.',
        date: DateTime.now(),
        byUser: user.username,
      ),
    );

    await save();

    notifyListeners();
  }

  Future<void> createUser({
    required String name,
    required String username,
    required String password,
    required UserRole role,
  }) async {
    final current = currentUser;

    if (current == null ||
        !current.canManageUsers) {
      return;
    }

    final normalized =
        username.trim().toLowerCase();

    final exists = users.any(
      (user) =>
          user.username.toLowerCase() ==
          normalized,
    );

    if (exists) {
      throw Exception(
        'Ese usuario ya existe.',
      );
    }

    users.add(
      AppUser(
        id: _nextUserId++,
        name: name.trim(),
        username: normalized,
        password: password,
        role: role,
      ),
    );

    await save();

    notifyListeners();
  }

  Future<void> toggleUser(
    int userId,
  ) async {
    final current = currentUser;

    if (current == null ||
        !current.canManageUsers) {
      return;
    }

    final user = users.firstWhere(
      (user) => user.id == userId,
    );

    if (user.username == 'admin') {
      return;
    }

    user.active = !user.active;

    await save();

    notifyListeners();
  }

  Future<void> resetDemo() async {
    currentUser = null;

    _createDemoData();

    await save();

    notifyListeners();
  }

  String _formatDate(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/'
        '${value.year}';
  }
}