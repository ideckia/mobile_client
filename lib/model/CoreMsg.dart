class CoreMsg {
  final String type;
  final dynamic data;
  const CoreMsg(this.type, this.data);

  factory CoreMsg.fromJson(Map<String, dynamic> json) {
    return CoreMsg(json['type'].toString(), json['data']);
  }
}
