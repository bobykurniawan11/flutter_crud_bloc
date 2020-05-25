class User {
  String id;
  String nama;
  String email;

  User({this.id, this.nama, this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], nama: json['nama'], email: json['email']);
}
