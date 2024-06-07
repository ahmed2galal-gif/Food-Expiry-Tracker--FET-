import 'dart:async';

import 'package:flutter/scheduler.dart';

import '../app.dart';

class FoodModel extends ChangeNotifier {
  final String name, image;
  final int days, hours, minutes;
  final DateTime? addedAt;
  final DocumentSnapshot? document;
  late DocumentReference? reference;
  final String? userId;

  FoodModel({
    required this.name,
    required this.image,
    required this.days,
    required this.hours,
    required this.minutes,
    this.document,
    this.addedAt,
    this.userId,
  }) {
    if (document != null) {
      reference = document!.reference;

      if (addedAt != null && !isExpired) {
        scheduleNotification;
      }
    }
  }

  Duration? timeLeftDifference;

  Timer get calculateDifference => Timer.periodic(
        const Duration(seconds: 1),
        (ticker) {
          timeLeftDifference = DateTime.now().difference(addedAt!);

          if (isExpired) {
            ticker.cancel();
          }
          notifyListeners();
        },
      );

  Future get scheduleNotification async {
    var totalMinutes = (((days * 24) + hours) * 60) + minutes;
    var halfTimeId = "$name-$addedAt-${totalMinutes / 2}".hashCode;
    await notificationEngine.cancelNotification(halfTimeId);

    notificationEngine.showScheduledNotification(
      halfTimeId,
      addedAt!.add(Duration(minutes: totalMinutes ~/ 2)),
      "$name Reminder",
      "Click here to see recipes to enjoy your $name",
      {
        "id": document!.id,
        "name": name,
        "type": "recipes",
      },
    );

    var quarterId = "$name-$addedAt-${totalMinutes / 1.5}".hashCode;

    await notificationEngine.cancelNotification(quarterId);

    notificationEngine.showScheduledNotification(
      quarterId,
      addedAt!.add(Duration(minutes: totalMinutes ~/ 1.5)),
      "$name Reminder",
      "If you don't need your $name, click here to donate it",
      {
        "type": "donation",
      },
    );

    var expiredId = "$name-$addedAt-$totalMinutes".hashCode;

    await notificationEngine.cancelNotification(expiredId);

    notificationEngine.showScheduledNotification(
      expiredId,
      addedAt!.add(Duration(minutes: totalMinutes)),
      "$name Expired",
      "Sadly your $name expired.",
      {
        "type": "expired",
      },
    );
  }

  Future get cancelNotifications async {
    var totalMinutes = (((days * 24) + hours) * 60) + minutes;
    var halfTimeId = "$name-$addedAt-${totalMinutes / 2}".hashCode;
    var quarterId = "$name-$addedAt-${totalMinutes / 1.5}".hashCode;
    var expiredId = "$name-$addedAt-$totalMinutes".hashCode;
    await notificationEngine.cancelNotification(halfTimeId);
    await notificationEngine.cancelNotification(quarterId);
    await notificationEngine.cancelNotification(expiredId);
  }

  double get value {
    timeLeftDifference ??= DateTime.now().difference(addedAt!);

    var totalMinutes = (((days * 24) + hours) * 60) + minutes;

    int passedMinutes = timeLeftDifference!.inMinutes;

    return (passedMinutes > totalMinutes)
        ? days.toDouble()
        : passedMinutes / totalMinutes;
  }

  String get timeLeft {
    timeLeftDifference ??= DateTime.now().difference(addedAt!);
    if ((days - timeLeftDifference!.inDays) > 0) {
      return "${days - timeLeftDifference!.inDays}d";
    } else if ((hours - timeLeftDifference!.inHours) > 0) {
      return "${hours - timeLeftDifference!.inHours}h";
    } else {
      return "${minutes - timeLeftDifference!.inMinutes}m";
    }
  }

  Future get addToDatabase async {
    await FirebaseFirestore.instance.collection("inventory").add({
      "name": name,
      "addedAt": DateTime.now().toUtcMilliseconds,
      "userId": currentUser!.id,
    });
  }

  String get status => (isExpired) ? "Expired" : "Normal";

  bool get isExpired {
    if (addedAt == null) return false;
    var dateDifference = DateTime.now().difference(addedAt!);
    return (days - dateDifference.inDays) <= 0 &&
        (hours - dateDifference.inHours) <= 0 &&
        (days - dateDifference.inMinutes) <= 0 &&
        (minutes - dateDifference.inMinutes) <= 0;
  }

  DateTime get expirationDate =>
      addedAt!.add(Duration(days: days, hours: hours));

  Color get statusColor => (isExpired) ? Colors.redAccent : Colors.green;

  static FoodModel fromDocumentSnapshot(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;

    final foodModel = FoodModel.fromName(data["name"]);

    return FoodModel(
      name: data["name"],
      addedAt: DateTime.fromMillisecondsSinceEpoch(data["addedAt"], isUtc: true)
          .toLocal(),
      userId: data["userId"],
      document: document,
      days: foodModel!.days,
      hours: foodModel.hours,
      minutes: foodModel.minutes,
      image: foodModel.image,
    );
  }

  static FoodModel? fromName(String name) {
    var subList = foodList.where((element) => element.name == name);

    if (subList.isNotEmpty) {
      return subList.first;
    }

    return null;
  }
}
