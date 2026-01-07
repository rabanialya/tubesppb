class UserModel {
  final int id;
  final String nama;
  final String email;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nama: json['nama'], // ✅ FIX
      email: json['email'],
    );
  }
}
