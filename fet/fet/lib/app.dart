library app;

export 'package:flutter/material.dart';
export 'package:iconsax/iconsax.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:flutter_bounce/flutter_bounce.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cached_network_image/cached_network_image.dart';

export 'Defaults/date.dart';
export 'Defaults/notifications.dart';
export 'Cells/food.dart';
export 'Cells/recipe.dart';
export 'Cells/organization.dart';
export 'Pages/Add/add.dart';
export 'Pages/Home/home.dart';
export 'Pages/Setup/login.dart';
export 'Models/food.dart';
export 'Models/user.dart';
export 'Pages/Recipes/recipes.dart';
export 'Pages/Recipes/details.dart';
export 'Pages/Organizations/organizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Models/food.dart';

const String appName = "Food Expiry Tracker";

const Color primaryColor = Color.fromRGBO(142, 36, 58, 1);
const Color accentColor = Color.fromRGBO(230, 147, 54, 1);
List<FoodModel> foodList = [
  FoodModel(
    name: "Apple",
    image: "https://www.iconpacks.net/icons/2/free-apple-icon-3155-thumb.png",
    days: 3,
    hours: 9,
    minutes: 0,
  ),
  FoodModel(
    name: "Banana",
    image: "https://cdn-icons-png.freepik.com/512/5779/5779223.png",
    days: 5,
    hours: 6,
    minutes: 0,
  ),
  FoodModel(
    name: "Cucumber",
    image: "https://cdn-icons-png.flaticon.com/512/5582/5582651.png",
    days: 7,
    hours: 5,
    minutes: 0,
  ),
  FoodModel(
    name: "Eggs",
    image: "https://cdn-icons-png.freepik.com/512/4771/4771348.png",
    days: 10,
    hours: 3,
    minutes: 0,
  ),
  FoodModel(
    name: "Grape",
    image: "https://cdn-icons-png.flaticon.com/512/2836/2836932.png",
    days: 0,
    hours: 0,
    minutes: 5,
  ),
  FoodModel(
    name: "Mango",
    image:
        "https://cdn.iconscout.com/icon/free/png-256/free-mango-fruit-vitamin-healthy-summer-food-31184.png",
    days: 10,
    hours: 3,
    minutes: 0,
  ),
  FoodModel(
    name: "Strawberry",
    image: "https://cdn-icons-png.flaticon.com/512/590/590685.png",
    days: 10,
    hours: 3,
    minutes: 0,
  ),
  FoodModel(
    name: "Tomato",
    image: "https://cdn-icons-png.flaticon.com/512/5194/5194802.png",
    days: 10,
    hours: 3,
    minutes: 0,
  ),
  FoodModel(
    name: "Carrot",
    image: "https://cdn-icons-png.flaticon.com/512/1514/1514935.png",
    days: 10,
    hours: 3,
    minutes: 0,
  ),
];

bool isLoaderShown = false;

void startLoading(BuildContext context) {
  isLoaderShown = true;

  showDialog(
    context: context,
    builder: (context) => const SpinKitDualRing(color: primaryColor),
    barrierDismissible: false,
  );
}

void endLoading(BuildContext context) {
  if (isLoaderShown) {
    isLoaderShown = false;

    Navigator.of(context).pop();
  }
}
