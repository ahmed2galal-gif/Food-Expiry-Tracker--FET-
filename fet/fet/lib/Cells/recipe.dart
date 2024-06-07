import '../app.dart';

class RecipeCell extends StatelessWidget {
  final Map<String, dynamic> recipe;
  const RecipeCell({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    var image = CachedNetworkImage(
      imageUrl: recipe["image"],
      fit: BoxFit.cover,
    );

    var name = Text(
      recipe["name"],
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.9),
      ),
    );

    String ingradientsList(List ingredients) {
      String value = "";
      for (var data in ingredients) {
        value += data;

        if (ingredients.last != data) {
          value += ", ";
        }
      }

      return value;
    }

    var ingredients = Text(
      ingradientsList(recipe["ingredients"]),
      maxLines: 1,
      style: TextStyle(
        fontSize: 10,
        color: Colors.white.withOpacity(0.8),
      ),
    );

    var holder = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: Colors.black.withOpacity(0.6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            name,
            ingredients,
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Bounce(
        duration: const Duration(milliseconds: 150),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => RecipeDetails(recipe: recipe)),
        ),
        child: Material(
          color: const Color.fromARGB(255, 247, 247, 247),
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                image,
                holder,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
