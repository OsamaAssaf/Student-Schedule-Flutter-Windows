import 'dart:ui';

class SubjectModel {
  String? name;
  Color? color;

  SubjectModel({
    this.name,
    this.color,
  });

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'color': color,
    };
  }

  factory SubjectModel.fromJSON(Map<String, dynamic> json) {
    return SubjectModel(
      name: json['name'] as String,
      color: json['color'] as Color,
    );
  }
}
