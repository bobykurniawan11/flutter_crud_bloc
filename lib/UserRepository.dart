import 'dart:convert';

import 'package:http/http.dart' as http;

import 'User.dart';
import 'server_response.dart';

class UserRepository {
  ServerResponse serverResponse;

  Future<ServerResponse> create(
      {String email, String name}) async {
    final value = await http.post('http://10.0.2.2/web_api/Api/addUser', body: {
      'email': email,
      'nama': name,
    });

    var jsonData = json.decode(value.body);
    serverResponse = ServerResponse(jsonData);
    return serverResponse;
  }

  Future<List<User>> read() async {
    final value = await http.post('http://10.0.2.2/web_api/Api/readUser');
    final List<User> user = [];
    List<dynamic> responseData = json.decode(value.body);
    responseData.forEach((json) {
      user.add(
        User(
          id: json['id'],
          nama: json['nama'],
          email: json['email'],
        ),
      );
    });
    return user;
  }

  Future<ServerResponse> update(
    {String email, String name, String id}) async {
    final value = await http.post('http://10.0.2.2/web_api/Api/updateUser', body: {
      'email': email,
      'nama': name,
      'id':id
    });
    var jsonData = json.decode(value.body);
    serverResponse = ServerResponse(jsonData);
    return serverResponse;
  }

  Future<ServerResponse> delete(
      {String id}) async {
    final value = await http.post('http://10.0.2.2/web_api/Api/delete', body: {
      'id':id
    });
    var jsonData = json.decode(value.body);
    serverResponse = ServerResponse(jsonData);
    return serverResponse;
  }

}
