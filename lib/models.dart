enum UserRole {
  admin,
  gerencia,
  cotizaciones,
  dibujante,
  chofer,
  supervisorSoldadura,
  supervisorMaestranza,
}

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.gerencia:
        return 'Gerencia';
      case UserRole.cotizaciones:
        return 'Cotizaciones';
      case UserRole.dibujante:
        return 'Dibujante';
      case UserRole.chofer:
        return 'Chofer';
      case UserRole.supervisorSoldadura:
        return 'Supervisor Soldadura';
      case UserRole.supervisorMaestranza:
        return 'Supervisor Maestranza';
    }
  }

  String get shortLabel {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.gerencia:
        return 'Gerencia';
      case UserRole.cotizaciones:
        return 'Cotizaciones';
      case UserRole.dibujante:
        return 'Dibujante';
      case UserRole.chofer:
        return 'Chofer';
      case UserRole.supervisorSoldadura:
        return 'Soldadura';
      case UserRole.supervisorMaestranza:
        return 'Maestranza';
    }
  }
}

class AppUser {
  final String id;
  String username;
  String password;
  String fullName;
  UserRole role;
  bool active;

  AppUser({
    required this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.role,
    this.active = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'fullName': fullName,
        'role': role.name,
        'active': active,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final roleName = json['role'] as String? ?? UserRole.gerencia.name;
    return AppUser(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String,
      role: UserRole.values.firstWhere(
        (item) => item.name == roleName,
        orElse: () => UserRole.gerencia,
      ),
      active: json['active'] as bool? ?? true,
    );
  }
}

class ActivityLog {
  final String title;
  final String detail;
  final String actor;
  final DateTime timestamp;

  ActivityLog({
    required this.title,
    required this.detail,
    required this.actor,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'detail': detail,
        'actor': actor,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ActivityLog.fromJson(Map<String, dynamic> json) => ActivityLog(
        title: json['title'] as String,
        detail: json['detail'] as String,
        actor: json['actor'] as String? ?? 'Sistema',
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class WorkOrder {
  final String id;
  String code;
  String client;
  String description;
  DateTime startDate;
  DateTime dueDate;

  bool approved;
  bool orderPlaced;
  bool dxfUploaded;
  bool received;
  int weldingProgress;
  int machiningProgress;
  bool finished;

  String? orderPdfName;
  String? orderPdfPath;
  String? dxfFileName;
  String? dxfFilePath;

  final List<ActivityLog> history;

  WorkOrder({
    required this.id,
    required this.code,
    required this.client,
    required this.description,
    required this.startDate,
    required this.dueDate,
    this.approved = true,
    this.orderPlaced = false,
    this.dxfUploaded = false,
    this.received = false,
    this.weldingProgress = 0,
    this.machiningProgress = 0,
    this.finished = false,
    this.orderPdfName,
    this.orderPdfPath,
    this.dxfFileName,
    this.dxfFilePath,
    List<ActivityLog>? history,
  }) : history = history ?? <ActivityLog>[];

  int get productionProgress =>
      ((weldingProgress + machiningProgress) / 2).round();

  int get progress {
    if (finished) return 100;

    double total = 0;
    if (approved) total += 5;
    if (orderPlaced) total += 10;
    if (dxfUploaded) total += 10;
    if (received) total += 10;

    if (received) {
      total += 60 * (productionProgress / 100);
    }

    return total.round().clamp(0, 95).toInt();
  }

  String get status {
    if (finished) return 'Finalizada';
    if (received && productionProgress > 0) return 'En producción';
    if (received) return 'Lista para producción';
    if (dxfUploaded) return 'Esperando recepción';
    if (orderPlaced) return 'Esperando DXF';
    if (approved) return 'Esperando pedido';
    return 'Pendiente';
  }

  bool get isLate => !finished && DateTime.now().isAfter(dueDate);

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'client': client,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'dueDate': dueDate.toIso8601String(),
        'approved': approved,
        'orderPlaced': orderPlaced,
        'dxfUploaded': dxfUploaded,
        'received': received,
        'weldingProgress': weldingProgress,
        'machiningProgress': machiningProgress,
        'finished': finished,
        'orderPdfName': orderPdfName,
        'orderPdfPath': orderPdfPath,
        'dxfFileName': dxfFileName,
        'dxfFilePath': dxfFilePath,
        'history': history.map((item) => item.toJson()).toList(),
      };

  factory WorkOrder.fromJson(Map<String, dynamic> json) => WorkOrder(
        id: json['id'] as String,
        code: json['code'] as String,
        client: json['client'] as String,
        description: json['description'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        dueDate: DateTime.parse(json['dueDate'] as String),
        approved: json['approved'] as bool? ?? true,
        orderPlaced: json['orderPlaced'] as bool? ?? false,
        dxfUploaded: json['dxfUploaded'] as bool? ?? false,
        received: json['received'] as bool? ?? false,
        weldingProgress: (json['weldingProgress'] as num? ?? 0).toInt(),
        machiningProgress: (json['machiningProgress'] as num? ?? 0).toInt(),
        finished: json['finished'] as bool? ?? false,
        orderPdfName: json['orderPdfName'] as String?,
        orderPdfPath: json['orderPdfPath'] as String?,
        dxfFileName: json['dxfFileName'] as String?,
        dxfFilePath: json['dxfFilePath'] as String?,
        history: (json['history'] as List<dynamic>? ?? <dynamic>[])
            .map((item) => ActivityLog.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
}
