import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
class News {
  String title;
  String description;
  String image;
  String? author;
  DateTime pubDate;
  String prettyDate;

  News.fromJson(Map<String, dynamic> json)
      : title = json['title'].toString(),
        description = json['description'].toString(),
        image = json['imgLink'].toString(),
        author = json['author'].toString(),
        prettyDate=timeago.format(DateTime.now(),locale: "ru",allowFromNow: true),
        pubDate = DateFormat("MMM d, yyyy, hh:mm:ss aa").parse(json['pubDate'].toString()){
    prettyDate=timeago.format(pubDate,locale: "ru",allowFromNow: true);
  }

  News.empty()
      : title = "",
        description = "N/A",
        prettyDate="",
        pubDate=DateTime.now(),
        image=""
  ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is News &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          image == other.image &&
          author == other.author &&
          pubDate == other.pubDate;

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      image.hashCode ^
      author.hashCode ^
      pubDate.hashCode;

  @override
  String toString() {
    return 'News{title: $title, description: $description, imgLink: $image, author: $author, pubDate: $pubDate}';
  }
}
