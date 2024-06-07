import 'package:url_launcher/url_launcher.dart';

import '../app.dart';

class OrganizationCell extends StatelessWidget {
  final Map<String, dynamic> organization;
  const OrganizationCell({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    var image = Bounce(
      duration: const Duration(milliseconds: 150),
      onPressed: () => launchUrl(Uri.parse(organization["website"])),
      child: CachedNetworkImage(
        imageUrl: organization["image"],
        fit: BoxFit.cover,
      ),
    );

    var name = Text(
      organization["name"],
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black.withOpacity(0.9),
      ),
    );

    var address = (organization["address"] == null)
        ? const SizedBox()
        : Row(
            children: [
              const Icon(
                FontAwesomeIcons.locationArrow,
                size: 15,
                color: primaryColor,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  organization["address"],
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          );

    var phone = (organization["phone"] == null)
        ? const SizedBox()
        : Bounce(
            duration: const Duration(milliseconds: 150),
            onPressed: () =>
                launchUrl(Uri.parse("tel:${organization["phone"]}")),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.phone,
                  size: 15,
                  color: primaryColor,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    organization["phone"],
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          );

    var email = (organization["email"] == null)
        ? const SizedBox()
        : Bounce(
            duration: const Duration(milliseconds: 150),
            onPressed: () =>
                launchUrl(Uri.parse("mailto:${organization["email"]}")),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  FontAwesomeIcons.envelope,
                  size: 15,
                  color: primaryColor,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    organization["email"],
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          );

    var holder = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          name,
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: phone),
              Expanded(child: email),
            ],
          ),
          const SizedBox(height: 10),
          address,
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: const Color.fromARGB(255, 247, 247, 247),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: image),
              holder,
            ],
          ),
        ),
      ),
    );
  }
}
