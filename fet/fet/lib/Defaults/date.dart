// ignore_for_file: unnecessary_this
import 'package:date_format/date_format.dart';

extension Date on DateTime {
  static DateTime fromUtcMilliseconds(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch,
            isUtc: true)
        .toLocal();
  }

  int get toUtcMilliseconds => this.toUtc().millisecondsSinceEpoch;

  // String get timeAgo {
  //   String text = "";
  //   var difference = DateTime.now().difference(this);

  //   if ((difference.inDays / 30) > 1) {
  //     text = "${difference.inDays ~/ 30} ${local.get("shortMonth")}";
  //   } else if (difference.inDays > 0) {
  //     text = "${difference.inDays} ${local.get("shortDay")}";
  //   } else if (difference.inHours > 0) {
  //     text = "${difference.inHours} ${local.get("shortHour")}";
  //   } else if (difference.inMinutes > 0) {
  //     text = "${difference.inMinutes} ${local.get("shortMinute")}";
  //   } else if (difference.inSeconds > 0) {
  //     text = "${difference.inSeconds} ${local.get("shortSecond")}";
  //   }

  //   return text;
  // }

  String get toFormatedTime => formatDate(this, [hh, ":", nn, " ", am]);
  String get toBirthDate => formatDate(this, [dd, "-", mm, "-", yyyy]);

  String get toCalendarDate => formatDate(this, [DD, " - ", MM, " ", dd]);

  String get toYearFormattedDate {
    var now = DateTime.now().toDateOnly;
    var date = this.toDateOnly;
    var difference = date.difference(now);
    if (difference.inDays == 0) return "Today";
    if (difference.inDays == 1) return "Tomorrow";

    return formatDate(this, [dd, "-", mm, "-", yyyy]);
  }

  String get toFormatedDate {
    var now = DateTime.now().toDateOnly;
    var date = this.toDateOnly;
    var tomorrow = now.add(const Duration(days: 1));

    if (date.isAtSameMomentAs(now)) return "Today";
    if (date.isAtSameMomentAs(tomorrow)) return "Tomorrow";

    // print(difference.inDays);

    return (now.year == date.year)
        ? formatDate(this, [dd, " ", MM])
        : formatDate(this, [dd, " ", MM, ", ", yyyy]);
  }

  DateTime get toDateOnly => DateTime(this.year, this.month, this.day);

  // String get toTimeAgo => timeAgo.format(this, locale: "en_short");
}
