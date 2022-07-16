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

  final String? id;
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? picture;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        picture,
        id,
        title,
      ];
}
