class Post {
  String id;
  String text;
  DateTime createdAt;
  DateTime? updatedAt; //空OKという意味

  Post({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });
}//これをつくることで、一気に４つの値を一つの単位として管理可能になる