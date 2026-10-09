class StrategyModel {
  final String id;
  final String name;
  final String instrument;
  final String timeframe;
  final Map<String, dynamic> parameters;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  StrategyModel({
    required this.id,
    required this.name,
    required this.instrument,
    required this.timeframe,
    required this.parameters,
    required this.createdAt,
    required this.updatedAt,
  });
  
  StrategyModel copyWith({
    String? id,
    String? name,
    String? instrument,
    String? timeframe,
    Map<String, dynamic>? parameters,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StrategyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      instrument: instrument ?? this.instrument,
      timeframe: timeframe ?? this.timeframe,
      parameters: parameters ?? this.parameters,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
