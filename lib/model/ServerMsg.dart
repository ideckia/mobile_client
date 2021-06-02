
class ServerMsg {
  final String type;
  final dynamic data;
  const ServerMsg(this.type, this.data);

  factory ServerMsg.fromJson(Map<String, dynamic> json) {
    return ServerMsg(
      json['type'].toString(),
      json['data']
    );
  }
}