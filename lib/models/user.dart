import 'package:equatable/equatable.dart';

class MyUser extends Equatable {

  final String name;
  final String image;
  final String email;

  const MyUser({
    required this.name,
    required this.email,
    required this.image,
});

  factory MyUser.initial() => const MyUser(
      name:  '',
      email: '',
      image: '',
      );

  MyUser copy({
    String? name,
    String? email,
    String? image,
  }) =>
      MyUser(
        name: name ?? this.name,
        email: email ?? this.email,
        image: image ?? this.image,
  );

  factory MyUser.fromJSON(Map<String, dynamic> json) => MyUser(
      name: json['name'],
      email: json['email'],
      image: json['image'],
    );

  Map<String, dynamic> toJSON() => {
    'name': name,
    'email': email,
    'image': image,
  };

  @override
  List<Object?> get props => [name, email, image];

}