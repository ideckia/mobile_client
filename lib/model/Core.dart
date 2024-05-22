class Core {
  final String name;
  final String ip;

  Core({
    required this.name,
    required this.ip,
  });

  static const String NOT_FOUND = "not_found";

  factory Core.notFound() {
    return Core(
      name: NOT_FOUND,
      ip: '',
    );
  }
}
