class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String password;
  final int age;
  final String parcours;
  final String code;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.password,
      required this.age,
      required this.parcours,
      required this.code,});
}
