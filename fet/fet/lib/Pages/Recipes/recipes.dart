import '../../app.dart';

class Recipes extends StatefulWidget {
  final FoodModel? food;
  // final String
  const Recipes({super.key, this.food});

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  bool isLoading = false;

  List<Map<String, dynamic>> recipes = [];

  Future getData([bool isRefresh = false]) async {
    if (!isRefresh) {
      setState(() => isLoading = true);
    }

    recipes.clear();

    var query = FirebaseFirestore.instance.collection("recipes");

    var result = (widget.food == null)
        ? await query.get()
        : await query
            .where("ingredients", arrayContains: widget.food!.name)
            .get();

    for (var document in result.docs) {
      recipes.add(document.data());
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
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                var data = recipes[index];
                return RecipeCell(recipe: data);
              },
            ),
          );

    return Scaffold(
      appBar: (widget.food == null)
          ? null
          : AppBar(
              title: Text(widget.food!.name),
            ),
      body: list,
    );
  }
}
