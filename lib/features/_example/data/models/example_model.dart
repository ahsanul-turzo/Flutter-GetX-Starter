import '../../domain/entities/example_entity.dart';

class ExampleModel extends ExampleEntity {
  const ExampleModel({required super.id, required super.name, super.description});

  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, if (description != null) 'description': description};
  }

  ExampleEntity toEntity() => ExampleEntity(id: id, name: name, description: description);

  static ExampleModel fromEntity(ExampleEntity entity) =>
      ExampleModel(id: entity.id, name: entity.name, description: entity.description);
}
