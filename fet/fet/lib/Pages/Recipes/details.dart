import '../../app.dart';

class RecipeDetails extends StatelessWidget {
  final Map<String, dynamic> recipe;
  const RecipeDetails({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    var appBar = SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height / 3.5,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          recipe["name"],
        ),
        background: CachedNetworkImage(
          imageUrl: recipe["image"],
          fit: BoxFit.cover,
        ),
      ),
    );

    var body = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Ingredients",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            recipe["ingredients"].length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const CircleAvatar(radius: 6),
                  const SizedBox(width: 10),
                  Text(recipe["ingredients"][index]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Instructions",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            recipe["instructions"].length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 8,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(recipe["instructions"][index]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          appBar,
          SliverToBoxAdapter(
            child: body,
          )
        ],
      ),
    );
  }
}
