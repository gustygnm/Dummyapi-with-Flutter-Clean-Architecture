import '../../data/models/data_model.dart';
import '../../domain/entities/data.dart';
import 'package:equatable/equatable.dart';

class DataTable extends Equatable {
  final String? id;
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? picture;

  DataTable({
    required this.firstName,
    required this.lastName,
    required this.picture,
    required this.id,
    required this.title,
  });

  factory DataTable.fromEntity(DataItem movie) => DataTable(
        id: movie.id,
        title: movie.title,
        firstName: movie.firstName,
        lastName: movie.lastName,
        picture: movie.picture,
      );

  factory DataTable.fromMap(Map<String, dynamic> map) => DataTable(
        id: map['id'],
        title: map['title'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        picture: map['picture'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'firstName': firstName,
        'lastName': lastName,
        'picture': picture
      };

  Data toEntity() => Data.watchlist(
      id: id,
      title: title,
      firstName: firstName,
      lastName: lastName,
      picture: picture);

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
