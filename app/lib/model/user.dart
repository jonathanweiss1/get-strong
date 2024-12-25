/// A user in the Get Strong app.
class GSUser {
  final String? id;
  final String? email;
  final String? displayName;

  /// Initialize the id, email and display name for a new user
  GSUser({this.id, this.email, this.displayName});

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'displayName': displayName};
  }

  GSUser.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        email = map['id'],
        displayName = map['displayName'];
}
