class UserModel {
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
  });

  // Convert a User to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'created_at': DateTime.now(),
    };
  }

  // Create a User from Firestore snapshot
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      role: map['role'],
    );
  }
}
