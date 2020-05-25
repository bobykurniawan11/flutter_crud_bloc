class ServerResponse {
  int status;
  String message;

  ServerResponse(Map<String, dynamic> data) {
    status = data['status'];
    message = data['message'];
  }
}
