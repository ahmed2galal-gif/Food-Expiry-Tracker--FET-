import '../app.dart';

UserModel? currentUser;

class UserModel extends ChangeNotifier {
  final String fullName, email;
  final DateTime createdAt;
  final DocumentSnapshot document;
  late DocumentReference reference;
  late String id;

  UserModel({
    required this.fullName,
    required this.email,
    required this.document,
    required this.createdAt,
  }) {
    reference = document.reference;
    id = document.id;
  }

  static UserModel fromDocumentSnapshot(DocumentSnapshot document) {
    var data = document.data() as Map<String, dynamic>;

    return UserModel(
      fullName: data["fullName"],
      email: data["email"],
      createdAt: DateTime.fromMicrosecondsSinceEpoch(data["createdAt"]),
      document: document,
    );
  }

  static Future<UserModel?> fromId(String id) async {
    final document =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    if (document.exists) {
      return fromDocumentSnapshot(document);
    }

    return null;
  }
}
