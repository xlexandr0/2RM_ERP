enum UserRole {
  admin,
  almacen,
  logistica,
  contabilidad,
  jefatura,
  supervisor,
  cotizaciones,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.almacen:
        return 'Almacén';
      case UserRole.logistica:
        return 'Logística';
      case UserRole.contabilidad:
        return 'Contabilidad';
      case UserRole.jefatura:
        return 'Jefatura';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.cotizaciones:
        return 'Cotizaciones';
    }
  }
}

enum TaskStatus {
  pending,
  inProgress,
  completed,
  blocked,
}

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En proceso';
      case TaskStatus.completed:
        return 'Completada';
      case TaskStatus.blocked:
        return 'Bloqueada';
    }
  }
}

class AppUser {
  final int id;

  String name;
  String username;
  String password;

  UserRole role;

  bool active;

  AppUser({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.role,
    this.active = true,
  });

  bool get canChangeDeliveryDate {
    return username == 'jefatura1' ||
        username == 'jefatura2';
  }

  bool get canCloseOrder {
    return username == 'jefatura1' ||
        username == 'jefatura2';
  }

  bool get canChangeProduction {
    return role == UserRole.supervisor;
  }

  bool get canChangeMaterial {
    return role == UserRole.almacen;
  }

  bool get canCreateOrder {
    return role == UserRole.admin ||
        role == UserRole.jefatura;
  }

  bool get canManageTasks {
    return role == UserRole.admin ||
        role == UserRole.jefatura;
  }

  bool get canManageUsers {
    return role == UserRole.admin;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'role': role.name,
      'active': active,
    };
  }

  factory AppUser.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.cotizaciones,
      ),
      active: json['active'] ?? true,
    );
  }
}

class HistoryEntry {
  final String title;
  final String detail;
  final DateTime date;
  final String byUser;

  HistoryEntry({
    required this.title,
    required this.detail,
    required this.date,
    required this.byUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'detail': detail,
      'date': date.toIso8601String(),
      'byUser': byUser,
    };
  }

  factory HistoryEntry.fromJson(
    Map<String, dynamic> json,
  ) {
    return HistoryEntry(
      title: json['title'],
      detail: json['detail'],
      date: DateTime.parse(json['date']),
      byUser: json['byUser'] ?? '-',
    );
  }
}

class WorkTask {
  final int id;

  String title;
  String description;

  String assignedUsername;

  int progress;

  TaskStatus status;

  WorkTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedUsername,
    this.progress = 0,
    this.status = TaskStatus.pending,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedUsername': assignedUsername,
      'progress': progress,
      'status': status.name,
    };
  }

  factory WorkTask.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkTask(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      assignedUsername: json['assignedUsername'],
      progress: json['progress'] ?? 0,
      status: TaskStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
    );
  }
}

class WorkOrder {
  final int id;

  String code;
  String client;
  String description;

  final DateTime originalDueDate;

  DateTime? revisedDueDate;

  int productionProgress;
  int materialProgress;

  String? pdfName;
  String? pdfPath;

  String? dxfName;
  String? dxfPath;

  bool closed;

  final List<WorkTask> tasks;

  final List<HistoryEntry> history;

  WorkOrder({
    required this.id,
    required this.code,
    required this.client,
    required this.description,
    required this.originalDueDate,
    this.revisedDueDate,
    this.productionProgress = 0,
    this.materialProgress = 0,
    this.pdfName,
    this.pdfPath,
    this.dxfName,
    this.dxfPath,
    this.closed = false,
    List<WorkTask>? tasks,
    List<HistoryEntry>? history,
  })  : tasks = tasks ?? [],
        history = history ?? [];

  DateTime get activeDueDate {
    return revisedDueDate ?? originalDueDate;
  }

  int get tasksProgress {
    if (tasks.isEmpty) {
      return 0;
    }

    int total = 0;

    for (final task in tasks) {
      total += task.progress;
    }

    return (total / tasks.length).round();
  }

  /// Cálculo:
  /// tareas = 40%
  /// producción = 40%
  /// material = 20%
  int get totalProgress {
    if (closed) {
      return 100;
    }

    final result =
        (tasksProgress * 0.40) +
        (productionProgress * 0.40) +
        (materialProgress * 0.20);

    return result.round().clamp(0, 100);
  }

  bool get isOverdue {
    if (closed) {
      return false;
    }

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final due = DateTime(
      activeDueDate.year,
      activeDueDate.month,
      activeDueDate.day,
    );

    return today.isAfter(due);
  }

  bool get canClose {
    return !closed &&
        tasksProgress == 100 &&
        productionProgress == 100 &&
        materialProgress == 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'client': client,
      'description': description,
      'originalDueDate':
          originalDueDate.toIso8601String(),
      'revisedDueDate':
          revisedDueDate?.toIso8601String(),
      'productionProgress': productionProgress,
      'materialProgress': materialProgress,
      'pdfName': pdfName,
      'pdfPath': pdfPath,
      'dxfName': dxfName,
      'dxfPath': dxfPath,
      'closed': closed,
      'tasks':
          tasks.map((task) => task.toJson()).toList(),
      'history':
          history.map((item) => item.toJson()).toList(),
    };
  }

  factory WorkOrder.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkOrder(
      id: json['id'],
      code: json['code'],
      client: json['client'],
      description: json['description'],
      originalDueDate:
          DateTime.parse(json['originalDueDate']),
      revisedDueDate:
          json['revisedDueDate'] == null
              ? null
              : DateTime.parse(
                  json['revisedDueDate'],
                ),
      productionProgress:
          json['productionProgress'] ?? 0,
      materialProgress:
          json['materialProgress'] ?? 0,
      pdfName: json['pdfName'],
      pdfPath: json['pdfPath'],
      dxfName: json['dxfName'],
      dxfPath: json['dxfPath'],
      closed: json['closed'] ?? false,
      tasks: ((json['tasks'] as List?) ?? [])
          .map(
            (item) => WorkTask.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      history:
          ((json['history'] as List?) ?? [])
              .map(
                (item) =>
                    HistoryEntry.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
    );
  }
}