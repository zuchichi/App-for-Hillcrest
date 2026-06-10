class UserModel {
  final String uid;
  final String username;
  final String email;
  final String fullName;
  final String selectedLanguage;
  final bool isAdmin;
  final List<Map<String, dynamic>> requestedRides;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.fullName,
    required this.selectedLanguage,
    required this.isAdmin,
    this.requestedRides = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'fullName': fullName,
      'selectedLanguage': selectedLanguage,
      'isAdmin': isAdmin,
      'requestedRides': requestedRides,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      selectedLanguage: map['selectedLanguage'] ?? 'English (US)',
      isAdmin: map['isAdmin'] ?? false,
      requestedRides: List<Map<String, dynamic>>.from(map['requestedRides'] ?? []),
    );
  }
}
