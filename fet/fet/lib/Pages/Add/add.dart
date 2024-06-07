import '../../app.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  List<FoodModel> list = [];

  List<FoodModel> selectedItems = [];

  @override
  void initState() {
    list.addAll(foodList);
    super.initState();
  }

  Future get save async {
    startLoading(context);

    for (var model in selectedItems) {
      await model.addToDatabase;
    }

    endLoading(context);

    Navigator.of(context).pop();
  }

  void search(String text) async {
    list.clear();
    if (text.isNotEmpty) {
      list = foodList
          .where((element) =>
              element.name.toLowerCase().contains(text.trim().toLowerCase()))
          .toList();
    } else {
      list.addAll(foodList);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var body = ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        FoodModel foodModel = list[index];

        return Bounce(
          duration: const Duration(milliseconds: 150),
          onPressed: () {
            if (selectedItems.contains(foodModel)) {
              selectedItems.remove(foodModel);
            } else {
              selectedItems.add(foodModel);
            }

            setState(() {});
          },
          child: FoodCell(
            foodModel: foodModel,
            isSelected: selectedItems.contains(foodModel),
          ),
        );
      },
    );

    var saveButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: MaterialButton(
        color: (selectedItems.isEmpty) ? Colors.blueGrey : primaryColor,
        onPressed: (selectedItems.isEmpty) ? () {} : () => save,
        child: const Text("Save", style: TextStyle(color: Colors.white)),
      ),
    );

    var searchWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        onTapOutside: (details) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: (text) => search(text),
        decoration: InputDecoration(
          hintText: "Search",
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          fillColor: accentColor.withOpacity(0.3),
          filled: true,
          prefixIcon: Icon(Iconsax.search_normal),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Food"),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40), child: searchWidget),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: body),
            saveButton,
          ],
        ),
      ),
    );
  }
}
