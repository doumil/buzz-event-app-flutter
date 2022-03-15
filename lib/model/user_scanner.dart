class Userscan {
  String firstname;
  String lastname;
  String company;
  String email;
  String phone;
  String adresse;
  String evolution;
  String action;
  String notes;


  Userscan(this.firstname, this.lastname,this.company, this.email,this.phone,this.adresse,this.evolution,this.action,this.notes);
  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'company': company,
      'email': email,
      'phone': phone,
      'adresse': adresse,
      'evolution': evolution,
      'action': action,
      'notes': notes,
    };
  }
  @override
  String toString() {
    return 'firstname : $firstname,lastname : $lastname,company : $company,email : $email,phone : $phone,adresse : $adresse,evolution : $evolution,action : $action,notes : $notes';
  }
}
