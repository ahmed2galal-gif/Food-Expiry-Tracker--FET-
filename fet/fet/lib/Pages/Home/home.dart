import 'dart:async';
import 'dart:io';
import 'package:fet/Pages/Add/add.dart';
import 'package:fet/Pages/Home/selector.dart';
import 'package:fet/app.dart';

import '../../Cells/food.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import '../../Defaults/date.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool isLoading = true;
  int selectedIndex = 0;
  late final TabController controller;

  final Map<DateTime, List> inventory = {};

  Future getData([bool isRefresh = false]) async {
    if (!isRefresh) {
      setState(() => isLoading = true);
    }

    inventory.clear();
    await notificationEngine.cancelAllNotifications;

    var result = await FirebaseFirestore.instance
        .collection("inventory")
        .where("userId", isEqualTo: currentUser!.id)
        .orderBy("addedAt", descending: true)
        .get();

    for (var document in result.docs) {
      FoodModel model = FoodModel.fromDocumentSnapshot(document);

      if (inventory[model.addedAt!.toDateOnly] != null) {
        inventory[model.addedAt!.toDateOnly]!.add(model);
      } else {
        inventory[model.addedAt!.toDateOnly] = [model];
      }
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    notificationEngine = NotificationsEngine();
    controller = TabController(length: 2, vsync: this);

    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    Future.delayed(Duration.zero, () {
      notificationEngine.initNotifications(context);
      getData();
    });

    controller
        .addListener(() => setState(() => selectedIndex = controller.index));
  }

  Future pickimage(ImageSource source) async {
    var xfile = await ImagePicker.platform.getImageFromSource(source: source);
    if (xfile == null) return null;
    setState(() => isLoading = true);

    var image = File(xfile.path);

    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );

    var output = await Tflite.runModelOnImage(
          path: image.path,
          imageStd: 127.5,
          imageMean: 127.5,
          threshold: 0.5,
          numResults: 2,
        ) ??
        [];
    print(output);

    for (var item in output) {
      var name = item["label"].toString().substring(2);

      FoodModel? model = FoodModel.fromName(name);

      if (model != null) {
        await model.addToDatabase;
      }
    }

    setState(() => isLoading = false);
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
            child: (inventory.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.receipt,
                          size: MediaQuery.of(context).size.width / 3,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Nothing to show",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 20,
                          ),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 60),
                    itemCount: inventory.keys.length,
                    itemBuilder: (context, index) {
                      DateTime date = inventory.keys.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Material(
                                borderRadius: BorderRadius.circular(30),
                                color: accentColor.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Text(
                                    date.toFormatedDate,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            ...List.generate(
                                inventory.values.toList()[index].length,
                                (itemIndex) {
                              return FoodCell(
                                key: ValueKey(inventory.values.toList()[index]
                                    [itemIndex]),
                                foodModel: inventory.values.toList()[index]
                                    [itemIndex],
                                afterDelete: () => getData(),
                              );
                            })
                          ],
                        ),
                      );
                    },
                  ),
          );

    var tabview = TabBarView(
      controller: controller,
      children: [
        list,
        const Recipes(),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Expiry Tracker"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SelectionMethods? selectedMethod;
          await showModalBottomSheet(
            context: context,
            builder: (context) => SelectMethod(
              onSelect: (method) {
                Navigator.of(context).pop();
                selectedMethod = method;
              },
            ),
          );

          if (selectedMethod != null) {
            switch (selectedMethod) {
              case SelectionMethods.picker:
                await pickimage(ImageSource.gallery);

                break;

              case SelectionMethods.camera:
                await pickimage(ImageSource.camera);

                break;
              default:
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const Add()));
            }

            controller.animateTo(0);

            getData();
          }

          // await Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => const Add()));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => controller.animateTo(index),
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.receipt_item),
            label: "Recipes",
          ),
        ],
      ),
      body: tabview,
    );
  }
}
