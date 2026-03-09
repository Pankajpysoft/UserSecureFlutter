import 'dart:convert';

/// Base class for saved items
abstract class SavedItem {
  final String id;
  final int timestamp;
  final String type;

  SavedItem({
    required this.id,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toMap();
  String toJson() => json.encode(toMap());

  static SavedItem fromMap(Map<String, dynamic> map) {
    if (map['type'] == 'username') {
      return UsernameItem.fromMap(map);
    } else {
      return PasswordItem.fromMap(map);
    }
  }

  static SavedItem fromJson(String source) => fromMap(json.decode(source));
}

/// Represents a generated username
class UsernameItem extends SavedItem {
  final String username;
  final String style; // Cool, Funny, Professional, Manual

  UsernameItem({
    required String id,
    required int timestamp,
    required this.username,
    required this.style,
  }) : super(id: id, timestamp: timestamp, type: 'username');

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'type': type,
      'username': username,
      'style': style,
    };
  }

  factory UsernameItem.fromMap(Map<String, dynamic> map) {
    return UsernameItem(
      id: map['id'],
      timestamp: map['timestamp'],
      username: map['username'],
      style: map['style'] ?? 'Manual',
    );
  }
}

/// Represents a generated password
class PasswordItem extends SavedItem {
  final String password;
  final int length;
  final String strength;

  PasswordItem({
    required String id,
    required int timestamp,
    required this.password,
    required this.length,
    required this.strength,
  }) : super(id: id, timestamp: timestamp, type: 'password');

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'type': type,
      'password': password,
      'length': length,
      'strength': strength,
    };
  }

  factory PasswordItem.fromMap(Map<String, dynamic> map) {
    return PasswordItem(
      id: map['id'],
      timestamp: map['timestamp'],
      password: map['password'],
      length: map['length'] ?? map['password'].length,
      strength: map['strength'] ?? 'Unknown',
    );
  }
}
