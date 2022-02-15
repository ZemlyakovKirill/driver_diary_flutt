import 'package:intl/intl.dart';

class News {
  String title;
  String description;
  String? imgLink;
  String? author;
  DateTime? pubDate;

  News.fromJson(Map<String, dynamic> json)
      : title = json['title'].toString(),
        description = json['description'].toString(),
        imgLink = json['imgLink'].toString(),
        author = json['author'].toString(),
        pubDate = DateFormat("MMM d, yyyy hh:mm:ss aa").parse(json['pubDate'].toString());

  News.empty()
      : title = "",
        description = "N/A";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is News &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          imgLink == other.imgLink &&
          author == other.author &&
          pubDate == other.pubDate;

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      imgLink.hashCode ^
      author.hashCode ^
      pubDate.hashCode;

  @override
  String toString() {
    return 'News{title: $title, description: $description, imgLink: $imgLink, author: $author, pubDate: $pubDate}';
  }
}
