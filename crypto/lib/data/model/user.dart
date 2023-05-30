class user {
  int id;
  String name;
  String username;
  String city;
  String phone;
  user(this.id, this.name, this.username, this.city, this.phone);
  factory user.fromMapJson(Map<String, dynamic> jsonObject) {
    return user(
      jsonObject['id'],
      jsonObject['name'],
      jsonObject['username'],
      jsonObject['address']['city'],
      jsonObject['phone'],
    );
  }
}
