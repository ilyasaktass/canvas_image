// lib/models/classes_response.dart

class Classes {
  final List<ClassItem> results;

  Classes({required this.results});

  factory Classes.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List;
    List<ClassItem> results = resultsList.map((i) => ClassItem.fromJson(i)).toList();
    return Classes(results: results);
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}
// lib/models/class_item.dart
class ClassItem {
  final String name;
  final int order;
  final int classOrder;
  final int userGroupId;
  final String? userGroup;
  final bool hasTimeTable;
  final String guid;
  final DateTime createdOn;
  final DateTime updatedOn;
  final bool isDeleted;
  final int id;

  ClassItem({
    required this.name,
    required this.order,
    required this.classOrder,
    required this.userGroupId,
    this.userGroup,
    required this.hasTimeTable,
    required this.guid,
    required this.createdOn,
    required this.updatedOn,
    required this.isDeleted,
    required this.id,
  });

  factory ClassItem.fromJson(Map<String, dynamic> json) {
    return ClassItem(
      name: json['Name'],
      order: json['Order'],
      classOrder: json['ClassOrder'],
      userGroupId: json['UserGroupId'],
      userGroup: json['UserGroup'],
      hasTimeTable: json['HasTimeTable'],
      guid: json['Guid'],
      createdOn: DateTime.parse(json['CreatedOn']),
      updatedOn: DateTime.parse(json['UpdatedOn']),
      isDeleted: json['IsDeleted'],
      id: json['Id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Order': order,
      'ClassOrder': classOrder,
      'UserGroupId': userGroupId,
      'UserGroup': userGroup,
      'HasTimeTable': hasTimeTable,
      'Guid': guid,
      'CreatedOn': createdOn.toIso8601String(),
      'UpdatedOn': updatedOn.toIso8601String(),
      'IsDeleted': isDeleted,
      'Id': id,
    };
  }
}
