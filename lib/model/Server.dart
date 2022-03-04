class Server {
  final String name;
  final String ip;

  Server({
    required this.name,
    required this.ip,
  });

  static const String NOT_FOUND = "not_found";

  factory Server.notFound() {
    return Server(
      name: NOT_FOUND,
      ip: '',
    );
  }
}
