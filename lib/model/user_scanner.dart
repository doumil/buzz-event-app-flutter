class Userscan {
  int id;
  String firstname;
  String lastname;
  String email;
  factory Userscan.fromJson(dynamic json) {
    return Userscan(json['id'] as int, json['firstname'] as String,
        json['lastname'] as String, json['email'] as String);
  }
  Userscan(this.id, this.firstname, this.lastname, this.email);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email
    };
  }
  @override
  String toString() {
    return 'firstname : $firstname,lastname : $lastname,email : $email';
  }
}
