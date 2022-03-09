class User{

  String  firstname ;
  String  lastname ;
  String   email;
  int id;

  User(this.id,this.firstname ,this.lastname , this.email);

  User.map(dynamic obj){
    this.firstname = obj['firstname'];
    this.lastname = obj['lastname'];
    this.email = obj['email'];
    this.id = obj['id'];
  }

  String get _firstname => firstname;
  String get _lastname => lastname;
  String get _email => email;
  int get _id => id;

  Map<String , dynamic> toMap(){
    var map = new Map<String , dynamic>();
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['email'] = _email;
    if(id != null){
      map['id'] = _id;
    }
    return map;
  }

  User.fromMap(Map<String , dynamic>map){
    this.firstname = map['firstname'];
    this.lastname = map['lastname'];
    this.email = map['email'];
    this.id = map['id'];
  }

}