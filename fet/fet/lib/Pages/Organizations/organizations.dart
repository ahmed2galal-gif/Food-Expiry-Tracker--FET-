import '../../app.dart';

class Donations extends StatefulWidget {
  const Donations({super.key});

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  bool isLoading = false;

  List<Map<String, dynamic>> organizations = [];

  Future getData([bool isRefresh = false]) async {
    if (!isRefresh) {
      setState(() => isLoading = true);
    }

    organizations.clear();
    var result = await FirebaseFirestore.instance.collection("donations").get();

    for (var document in result.docs) {
      organizations.add(document.data());
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var list = (isLoading)
        ? const Center(
            child: SpinKitDualRing(
              color: primaryColor,
            ),
          )
        : RefreshIndicator(
            onRefresh: () async => await getData(true),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 60),
              itemCount: organizations.length,
              itemBuilder: (context, index) {
                var data = organizations[index];
                return OrganizationCell(organization: data);
              },
            ),
          );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Donations"),
      ),
      body: list,
    );
  }
}
