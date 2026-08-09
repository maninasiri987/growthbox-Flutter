class User {
  final int id;
  final String email;
  final String name;
  final bool isVip;
  final String authMode; // "local", "google", "github"

  User({
    required this.id,
    required this.email,
    required this.name,
    this.isVip = false,
    this.authMode = 'local',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 1,
      email: json['email'] ?? 'local@growthbox.app',
      name: json['name'] ?? 'Local User',
      isVip: json['is_vip'] ?? json['isVip'] ?? true,
      authMode: json['auth_mode'] ?? 'local',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'is_vip': isVip,
      'auth_mode': authMode,
    };
  }

  static User get defaultLocalUser => User(
        id: 1,
        email: 'local@growthbox.app',
        name: 'Local User',
        isVip: true,
        authMode: 'local',
      );
}
