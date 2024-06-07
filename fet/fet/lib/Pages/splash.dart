import 'package:fet/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future get initData async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    await Future.delayed(const Duration(seconds: 1));

    // await FirebaseAuth.instance.signOut();

    // for (var item in list) {
    //   await FirebaseFirestore.instance.collection("recipes").add(item);
    // }

    Widget page = const Login();

    if (FirebaseAuth.instance.currentUser != null) {
      currentUser =
          await UserModel.fromId(FirebaseAuth.instance.currentUser!.uid);

      if (currentUser != null) {
        page = const Home();
      } else {
        page = const Login();
      }
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page), (route) => false);
  }

  @override
  void initState() {
    super.initState();

    initData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          width: MediaQuery.of(context).size.width / 2,
        ),
      ),
    );
  }
}

var list = [
  {
    "name": "Cucumber and Tomato Salad",
    "ingredients": [
      "Cucumber",
      "Tomatoes",
      "Olive oil",
      "Lemon juice",
      "Salt",
      "Pepper",
      "Fresh herbs (optional: parsley, dill)"
    ],
    "instructions": [
      "Slice the cucumber and tomatoes.",
      "In a bowl, mix them with olive oil, lemon juice, salt, and pepper.",
      "Add fresh herbs if desired and mix well."
    ]
  },
  {
    "name": "Banana Pancakes",
    "ingredients": ["Banana", "Eggs"],
    "instructions": [
      "Mash one banana in a bowl.",
      "Beat two eggs and mix them with the mashed banana.",
      "Heat a non-stick skillet over medium heat.",
      "Pour small amounts of the batter to form pancakes.",
      "Cook until bubbles form on the surface, then flip and cook until golden brown."
    ]
  },
  {
    "name": "Apple and Carrot Smoothie",
    "ingredients": ["Apple", "Carrot", "Mango", "Water or yogurt"],
    "instructions": [
      "Peel and chop the apple, carrot, and mango.",
      "Blend them together with water or yogurt until smooth.",
      "Serve chilled."
    ]
  },
  {
    "name": "Grape and Strawberry Fruit Salad",
    "ingredients": ["Grape", "Strawberry", "Mango"],
    "instructions": [
      "Slice the strawberries and mango.",
      "Mix them with whole grapes in a bowl.",
      "Serve fresh as a snack or dessert."
    ]
  },
  {
    "name": "Potato and Egg Breakfast Skillet",
    "ingredients": [
      "Potatoes",
      "Eggs",
      "Tomatoes",
      "Olive oil",
      "Salt",
      "Pepper"
    ],
    "instructions": [
      "Dice the potatoes and tomatoes.",
      "Heat olive oil in a skillet over medium heat.",
      "Add the potatoes and cook until they start to soften.",
      "Add the tomatoes and cook until everything is tender.",
      "Crack eggs over the skillet and cook until the eggs are done to your liking.",
      "Season with salt and pepper."
    ]
  },
  {
    "name": "Mango Strawberry Smoothie",
    "ingredients": [
      "Mango",
      "Strawberry",
      "Banana",
      "Yogurt or milk",
      "Honey (optional)"
    ],
    "instructions": [
      "Peel and chop the mango and banana.",
      "Blend the mango, strawberry, and banana with yogurt or milk until smooth.",
      "Add honey if desired for extra sweetness.",
      "Serve chilled."
    ]
  },
  {
    "name": "Cucumber and Carrot Sticks with Hummus",
    "ingredients": ["Cucumber", "Carrots", "Hummus (store-bought or homemade)"],
    "instructions": [
      "Peel and cut the cucumber and carrots into sticks.",
      "Arrange them on a plate with a bowl of hummus.",
      "Serve as a healthy snack or appetizer."
    ]
  },
  {
    "name": "Tomato and Egg Scramble",
    "ingredients": [
      "Eggs",
      "Tomatoes",
      "Olive oil",
      "Salt",
      "Pepper",
      "Fresh herbs (optional: chives, parsley)"
    ],
    "instructions": [
      "Dice the tomatoes.",
      "Beat the eggs in a bowl.",
      "Heat olive oil in a skillet over medium heat.",
      "Add the tomatoes and cook until soft.",
      "Pour in the beaten eggs and scramble until cooked through.",
      "Season with salt, pepper, and fresh herbs if desired."
    ]
  },
  {
    "name": "Apple Grape Salad with Yogurt Dressing",
    "ingredients": ["Apple", "Grape", "Yogurt", "Honey", "Lemon juice"],
    "instructions": [
      "Dice the apple and halve the grapes.",
      "In a bowl, mix yogurt, honey, and a splash of lemon juice to make the dressing.",
      "Toss the apple and grapes in the dressing.",
      "Serve chilled."
    ]
  },
  {
    "name": "Carrot and Mango Slaw",
    "ingredients": [
      "Carrots",
      "Mango",
      "Lime juice",
      "Olive oil",
      "Salt",
      "Pepper",
      "Fresh cilantro (optional)"
    ],
    "instructions": [
      "Grate the carrots and peel and julienne the mango.",
      "In a bowl, mix lime juice, olive oil, salt, and pepper to make the dressing.",
      "Toss the carrots and mango in the dressing.",
      "Garnish with fresh cilantro if desired."
    ]
  },
  {
    "name": "Strawberry Banana Parfait",
    "ingredients": [
      "Strawberries",
      "Banana",
      "Yogurt",
      "Granola",
      "Honey (optional)"
    ],
    "instructions": [
      "Slice the strawberries and banana.",
      "In a glass or bowl, layer yogurt, granola, strawberries, and banana.",
      "Repeat layers and drizzle honey on top if desired.",
      "Serve immediately."
    ]
  },
  {
    "name": "Potato and Carrot Soup",
    "ingredients": [
      "Potatoes",
      "Carrots",
      "Onion (optional)",
      "Garlic (optional)",
      "Vegetable broth",
      "Olive oil",
      "Salt",
      "Pepper"
    ],
    "instructions": [
      "Peel and chop the potatoes and carrots (and onion and garlic if using).",
      "Heat olive oil in a pot over medium heat.",
      "Add the onion and garlic and cook until softened.",
      "Add the potatoes and carrots, then pour in enough vegetable broth to cover.",
      "Bring to a boil, then simmer until the vegetables are tender.",
      "Blend the soup until smooth and season with salt and pepper.",
      "Serve hot."
    ]
  },
  {
    "name": "Cucumber Mango Salsa",
    "ingredients": [
      "Cucumber",
      "Mango",
      "Red onion (optional)",
      "Lime juice",
      "Salt",
      "Fresh cilantro (optional)"
    ],
    "instructions": [
      "Dice the cucumber, mango, and red onion.",
      "In a bowl, mix them with lime juice, salt, and fresh cilantro if using.",
      "Serve as a dip with chips or as a topping for grilled meats."
    ]
  },
  {
    "name": "Strawberry Apple Smoothie",
    "ingredients": [
      "Strawberries",
      "Apple",
      "Banana",
      "Yogurt or milk",
      "Honey (optional)"
    ],
    "instructions": [
      "Peel and chop the apple and banana.",
      "Blend the strawberries, apple, and banana with yogurt or milk until smooth.",
      "Add honey if desired for extra sweetness.",
      "Serve chilled."
    ]
  },
  {
    "name": "Grape and Mango Salad",
    "ingredients": ["Grape", "Mango", "Lime juice", "Mint leaves (optional)"],
    "instructions": [
      "Halve the grapes and dice the mango.",
      "Toss them together in a bowl with lime juice.",
      "Garnish with mint leaves if desired.",
      "Serve as a fresh, light dessert or snack."
    ]
  }
];
