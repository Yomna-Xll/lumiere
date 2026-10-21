class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? profilePicture;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['userId'] as String,
        email: json['email'] as String? ?? '',
        fullName: json['fullName'] as String? ?? '',
        profilePicture: json['profilePicture'] as String?,
      );

  String get initials {
    final parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}