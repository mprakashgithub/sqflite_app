class TodoModel {
  final int id;
  final String title;
  final String createdAt;
  final String? updatedAt;

  TodoModel(
      {required this.id,
      required this.title,
      required this.createdAt,
      this.updatedAt});
}
