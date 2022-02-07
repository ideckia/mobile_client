class Server {
  String name;
  final String ip;

  Server(this.name, this.ip);

  static const String NOT_FOUND = "not_found";

  factory Server.notFound() {
    return Server(
      NOT_FOUND,
      null,
    );
  }
}
