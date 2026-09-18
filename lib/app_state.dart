import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  static const _usersKey = 'erp_2rm_users_v2';
  static const _ordersKey = 'erp_2rm_orders_v2';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  final List<AppUser> users = <AppUser>[];
  final List<WorkOrder> orders = <WorkOrder>[];

  AppUser? currentUser;
  bool initialized = false;

  Future<void> initialize() async {
    await _load();
    initialized = true;
    notifyListeners();
  }

  Future<void> _load() async {
    final usersJson = await _prefs.getString(_usersKey);
    final ordersJson = await _prefs.getString(_ordersKey);

    if (usersJson == null || usersJson.isEmpty) {
      users
        ..clear()
        ..addAll(_seedUsers());
      await _saveUsers();
    } else {
      try {
        final decoded = jsonDecode(usersJson) as List<dynamic>;
        users
          ..clear()
          ..addAll(
            decoded.map(
              (item) => AppUser.fromJson(item as Map<String, dynamic>),
            ),
          );
      } catch (_) {
        users
          ..clear()
          ..addAll(_seedUsers());
        await _saveUsers();
      }
    }

    if (ordersJson == null || ordersJson.isEmpty) {
      orders
        ..clear()
        ..addAll(_seedOrders());
      await _saveOrders();
    } else {
      try {
        final decoded = jsonDecode(ordersJson) as List<dynamic>;
        orders
          ..clear()
          ..addAll(
            decoded.map(
              (item) => WorkOrder.fromJson(item as Map<String, dynamic>),
            ),
          );
      } catch (_) {
        orders
          ..clear()
          ..addAll(_seedOrders());
        await _saveOrders();
      }
    }
  }

  List<AppUser> _seedUsers() => <AppUser>[
        AppUser(
          id: 'user-admin',
          username: 'admin',
          password: '1234',
          fullName: 'Administrador 2RM',
          role: UserRole.admin,
        ),
        AppUser(
          id: 'user-gerencia',
          username: 'gerencia',
          password: '1234',
          fullName: 'Gerencia 2RM',
          role: UserRole.gerencia,
        ),
        AppUser(
          id: 'user-cotizaciones',
          username: 'cotizaciones',
          password: '1234',
          fullName: 'María López',
          role: UserRole.cotizaciones,
        ),
        AppUser(
          id: 'user-dibujante',
          username: 'dibujante',
          password: '1234',
          fullName: 'Pedro Díaz',
          role: UserRole.dibujante,
        ),
        AppUser(
          id: 'user-chofer',
          username: 'chofer',
          password: '1234',
          fullName: 'Luis Torres',
          role: UserRole.chofer,
        ),
        AppUser(
          id: 'user-soldadura',
          username: 'soldadura',
          password: '1234',
          fullName: 'Carlos Ramírez',
          role: UserRole.supervisorSoldadura,
        ),
        AppUser(
          id: 'user-maestranza',
          username: 'maestranza',
          password: '1234',
          fullName: 'José Mendoza',
          role: UserRole.supervisorMaestranza,
        ),
      ];

  List<WorkOrder> _seedOrders() => <WorkOrder>[
        WorkOrder(
          id: 'ot-148',
          code: 'OT-000148',
          client: 'Alicorp S.A.A.',
          description: 'Fabricación de estructura metálica',
          startDate: DateTime(2026, 9, 2),
          dueDate: DateTime(2026, 9, 25),
          approved: true,
          orderPlaced: true,
          dxfUploaded: true,
          received: true,
          weldingProgress: 80,
          machiningProgress: 55,
          orderPdfName: 'OT-000148.pdf',
          dxfFileName: 'estructura_v3.dxf',
          history: <ActivityLog>[
            ActivityLog(
              title: 'Pedido recibido',
              detail: 'El chofer confirmó la recepción del pedido.',
              actor: 'Luis Torres',
              timestamp: DateTime(2026, 9, 5, 9, 10),
            ),
            ActivityLog(
              title: 'DXF cargado',
              detail: 'Se adjuntó estructura_v3.dxf.',
              actor: 'Pedro Díaz',
              timestamp: DateTime(2026, 9, 4, 14, 42),
            ),
            ActivityLog(
              title: 'Pedido realizado',
              detail: 'Cotizaciones confirmó el pedido.',
              actor: 'María López',
              timestamp: DateTime(2026, 9, 3, 10, 15),
            ),
            ActivityLog(
              title: 'OT aprobada',
              detail: 'Orden registrada y aprobada.',
              actor: 'Administrador 2RM',
              timestamp: DateTime(2026, 9, 2, 8, 34),
            ),
          ],
        ),
        WorkOrder(
          id: 'ot-149',
          code: 'OT-000149',
          client: 'Industrias del Perú',
          description: 'Fabricación de base para motor industrial',
          startDate: DateTime(2026, 9, 5),
          dueDate: DateTime(2026, 9, 28),
          approved: true,
          orderPlaced: true,
          dxfUploaded: true,
          received: true,
          weldingProgress: 45,
          machiningProgress: 35,
        ),
        WorkOrder(
          id: 'ot-150',
          code: 'OT-000150',
          client: 'Corporación Andina',
          description: 'Fabricación de tanque inoxidable',
          startDate: DateTime(2026, 9, 8),
          dueDate: DateTime(2026, 10, 2),
          approved: true,
          orderPlaced: true,
          dxfUploaded: true,
          received: false,
        ),
        WorkOrder(
          id: 'ot-151',
          code: 'OT-000151',
          client: 'Minera del Sur',
          description: 'Plataforma para mantenimiento industrial',
          startDate: DateTime(2026, 9, 10),
          dueDate: DateTime(2026, 10, 10),
          approved: true,
          orderPlaced: false,
        ),
        WorkOrder(
          id: 'ot-147',
          code: 'OT-000147',
          client: 'Servicios Industriales SAC',
          description: 'Fabricación de soporte estructural',
          startDate: DateTime(2026, 8, 18),
          dueDate: DateTime(2026, 8, 30),
          approved: true,
          orderPlaced: true,
          dxfUploaded: true,
          received: true,
          weldingProgress: 100,
          machiningProgress: 100,
          finished: true,
        ),
      ];

  Future<void> _saveUsers() async {
    await _prefs.setString(
      _usersKey,
      jsonEncode(users.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> _saveOrders() async {
    await _prefs.setString(
      _ordersKey,
      jsonEncode(orders.map((item) => item.toJson()).toList()),
    );
  }

  String? login(String username, String password) {
    final normalized = username.trim().toLowerCase();
    AppUser? match;

    for (final user in users) {
      if (user.username.trim().toLowerCase() == normalized &&
          user.password == password) {
        match = user;
        break;
      }
    }

    if (match == null) return 'Usuario o contraseña incorrectos.';
    if (!match.active) return 'Este usuario está desactivado.';

    currentUser = match;
    notifyListeners();
    return null;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  WorkOrder findOrder(String id) => orders.firstWhere((item) => item.id == id);

  int get activeOrders => orders.where((item) => !item.finished).length;
  int get productionOrders =>
      orders.where((item) => item.status == 'En producción').length;
  int get lateOrders => orders.where((item) => item.isLate).length;
  int get finishedOrders => orders.where((item) => item.finished).length;
  int get activeUsers => users.where((item) => item.active).length;

  int get averageProgress {
    if (orders.isEmpty) return 0;
    final sum = orders.fold<int>(0, (value, item) => value + item.progress);
    return (sum / orders.length).round();
  }

  String nextOrderCode() {
    var maxNumber = 0;
    for (final order in orders) {
      final parts = order.code.split('-');
      if (parts.length < 2) continue;
      final value = int.tryParse(parts.last) ?? 0;
      if (value > maxNumber) maxNumber = value;
    }
    return 'OT-${(maxNumber + 1).toString().padLeft(6, '0')}';
  }

  String _newId(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  String _actorName() => currentUser?.fullName ?? 'Sistema';

  Future<void> addOrder({
    required String client,
    required String description,
    required DateTime dueDate,
    String? orderPdfName,
    String? orderPdfPath,
  }) async {
    final order = WorkOrder(
      id: _newId('ot'),
      code: nextOrderCode(),
      client: client.trim(),
      description: description.trim(),
      startDate: DateTime.now(),
      dueDate: dueDate,
      approved: true,
      orderPdfName: orderPdfName,
      orderPdfPath: orderPdfPath,
      history: <ActivityLog>[
        ActivityLog(
          title: 'OT aprobada',
          detail: orderPdfName == null
              ? 'La orden fue registrada y aprobada.'
              : 'La orden fue registrada con el archivo $orderPdfName.',
          actor: _actorName(),
          timestamp: DateTime.now(),
        ),
      ],
    );

    orders.insert(0, order);
    await _saveOrders();
    notifyListeners();
  }

  Future<void> updateOrder({
    required String id,
    required String client,
    required String description,
    required DateTime dueDate,
    String? orderPdfName,
    String? orderPdfPath,
  }) async {
    final order = findOrder(id);
    order.client = client.trim();
    order.description = description.trim();
    order.dueDate = dueDate;
    if (orderPdfName != null) {
      order.orderPdfName = orderPdfName;
      order.orderPdfPath = orderPdfPath;
    }
    order.history.insert(
      0,
      ActivityLog(
        title: 'OT actualizada',
        detail: 'Se actualizaron los datos generales de la orden.',
        actor: _actorName(),
        timestamp: DateTime.now(),
      ),
    );
    await _saveOrders();
    notifyListeners();
  }

  Future<void> deleteOrder(String id) async {
    orders.removeWhere((item) => item.id == id);
    await _saveOrders();
    notifyListeners();
  }

  Future<void> markOrderPlaced(String id) async {
    final order = findOrder(id);
    if (order.orderPlaced) return;
    order.orderPlaced = true;
    order.history.insert(
      0,
      ActivityLog(
        title: 'Pedido realizado',
        detail: 'Cotizaciones confirmó la realización del pedido.',
        actor: _actorName(),
        timestamp: DateTime.now(),
      ),
    );
    await _saveOrders();
    notifyListeners();
  }

  Future<void> attachDxf({
    required String id,
    required String fileName,
    String? filePath,
  }) async {
    final order = findOrder(id);
    order.dxfUploaded = true;
    order.dxfFileName = fileName;
    order.dxfFilePath = filePath;
    order.history.insert(
      0,
      ActivityLog(
        title: 'DXF cargado',
        detail: 'Se adjuntó el archivo $fileName.',
        actor: _actorName(),
        timestamp: DateTime.now(),
      ),
    );
    await _saveOrders();
    notifyListeners();
  }

  Future<void> markReceived(String id) async {
    final order = findOrder(id);
    if (order.received) return;
    order.received = true;
    order.history.insert(
      0,
      ActivityLog(
        title: 'Pedido recibido',
        detail: 'El pedido fue confirmado como recibido.',
        actor: _actorName(),
        timestamp: DateTime.now(),
      ),
    );
    await _saveOrders();
    notifyListeners();
  }

  Future<void> setWeldingProgress(String id, int value) async {
    final order = findOrder(id);
    order.weldingProgress = value.clamp(0, 100).toInt();
    order.history.insert(
      0,
      ActivityLog(
        title: 'Avance de Soldadura',
        detail: 'Soldadura actualizó su avance a ${order.weldingProgress}%.',
        actor: _actorName(),
        timestamp: DateTime.now(),
      ),
    );
    await _saveOrders();
    notifyListeners();
  }

  Future<void> setMachiningProgress(String id, int value) async {
    final order = findOrder(id);
    order.machiningProgress = value.clamp(0, 100).toInt();
    order.history.insert(
      0,
      ActivityLog(
        title: 'Avance de Maestranza',
        detail:
            'Maestranza actualizó su avance a ${order.machiningProgress}%.',
        actor: _actorName(),
        timestamp: DateTime.now(),
      ),
    );
    await _saveOrders();
    notifyListeners();
  }

  Future<void> finishOrder(String id) async {
    final order = findOrder(id);
    if (order.weldingProgress < 100 || order.machiningProgress < 100) {
      return;
    }
    order.finished = true;
    order.history.insert(
      0,
      ActivityLog(
        title: 'OT finalizada',
        detail: 'La orden de trabajo fue cerrada al 100%.',
        actor: _actorName(),
        timestamp: DateTime.now(),
      ),
    );
    await _saveOrders();
    notifyListeners();
  }

  Future<String?> createUser({
    required String username,
    required String password,
    required String fullName,
    required UserRole role,
    required bool active,
  }) async {
    final normalized = username.trim().toLowerCase();
    final duplicate = users.any(
      (item) => item.username.trim().toLowerCase() == normalized,
    );
    if (duplicate) return 'Ese nombre de usuario ya existe.';

    users.add(
      AppUser(
        id: _newId('user'),
        username: username.trim(),
        password: password,
        fullName: fullName.trim(),
        role: role,
        active: active,
      ),
    );
    await _saveUsers();
    notifyListeners();
    return null;
  }

  Future<String?> updateUser({
    required String id,
    required String username,
    required String fullName,
    required UserRole role,
    required bool active,
    String? newPassword,
  }) async {
    final normalized = username.trim().toLowerCase();
    final duplicate = users.any(
      (item) =>
          item.id != id && item.username.trim().toLowerCase() == normalized,
    );
    if (duplicate) return 'Ese nombre de usuario ya existe.';

    final user = users.firstWhere((item) => item.id == id);
    if (user.id == currentUser?.id && !active) {
      return 'No puedes desactivar tu propia sesión.';
    }

    user.username = username.trim();
    user.fullName = fullName.trim();
    user.role = role;
    user.active = active;
    if (newPassword != null && newPassword.isNotEmpty) {
      user.password = newPassword;
    }

    await _saveUsers();
    notifyListeners();
    return null;
  }

  Future<String?> deleteUser(String id) async {
    if (currentUser?.id == id) return 'No puedes eliminar tu propio usuario.';
    final user = users.firstWhere((item) => item.id == id);
    if (user.role == UserRole.admin &&
        users.where((item) => item.role == UserRole.admin).length <= 1) {
      return 'Debe existir al menos un administrador.';
    }
    users.removeWhere((item) => item.id == id);
    await _saveUsers();
    notifyListeners();
    return null;
  }

  Future<void> resetDemoData() async {
    users
      ..clear()
      ..addAll(_seedUsers());
    orders
      ..clear()
      ..addAll(_seedOrders());
    currentUser = users.first;
    await _saveUsers();
    await _saveOrders();
    notifyListeners();
  }
}
