import 'package:equatable/equatable.dart';

class Data extends Equatable {
  Data({
    required this.firstName,
    required this.lastName,
    required this.picture,
    required this.id,
    required this.title,
  });

  Data.watchlist({
    required this.firstName,
    required this.lastName,
    required this.picture,
    required this.id,
    required this.title,
  });

  String? id;
  String? title;
  String? firstName;
  String? lastName;
  String? picture;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        picture,
        id,
        title,
      ];
}
