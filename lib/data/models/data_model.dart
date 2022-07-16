// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

DataModel welcomeFromJson(String str) => DataModel.fromJson(json.decode(str));

String welcomeToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  DataModel({
    required this.data,
    required this.total,
    required  this.page,
    required  this.limit,
  });

  List<DataItem> data;
  int total;
  int page;
  int limit;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    data: List<DataItem>.from(json["data"].map((x) => DataItem.fromJson(x))),
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total": total,
    "page": page,
    "limit": limit,
  };
}

class DataItem extends Equatable{
  DataItem({
    required  this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.picture,
  });

  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String picture;

  factory DataItem.fromEntity(DataItem movie) => DataItem(
    id: movie.id,
    title: movie.title,
    firstName: movie.firstName,
    lastName: movie.lastName,
    picture: movie.picture,
  );

  factory DataItem.fromJson(Map<String, dynamic> json) => DataItem(
    id: json["id"],
    title: json["title"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "firstName": firstName,
    "lastName": lastName,
    "picture": picture,
  };

  DataItem toEntity() {
    return DataItem(
      firstName: this.firstName,
      lastName: this.lastName,
      picture: this.picture,
      id: this.id,
      title: this.title,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    firstName,
    lastName,
    picture,
    id,
    title,
  ];
}
