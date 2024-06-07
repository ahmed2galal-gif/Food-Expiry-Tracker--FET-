import 'dart:async';

import 'package:provider/provider.dart';

import '../app.dart';

class FoodCell extends StatefulWidget {
  final Function()? afterDelete;
  final FoodModel foodModel;
  final bool? isSelected;

  const FoodCell({
    super.key,
    required this.foodModel,
    this.isSelected,
    this.afterDelete,
  });

  @override
  State<FoodCell> createState() => _FoodCellState();
}

class _FoodCellState extends State<FoodCell> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = widget.foodModel.calculateDifference;
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FoodModel>.value(
      value: widget.foodModel,
      builder: (context, child) =>
          Consumer<FoodModel>(builder: (context, foodModel, child) {
        var clear = (!foodModel.isExpired)
            ? const SizedBox()
            : Bounce(
                duration: const Duration(milliseconds: 150),
                onPressed: () async {
                  startLoading(context);

                  await foodModel.reference!.delete();

                  endLoading(context);

                  widget.afterDelete?.call();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Clear",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent.withOpacity(0.9)),
                    ),
                    const SizedBox(width: 5),
                    Icon(FontAwesomeIcons.trash,
                        size: 17, color: Colors.redAccent.withOpacity(0.9)),
                  ],
                ),
              );

        var circle = (foodModel.addedAt == null)
            ? const SizedBox()
            : (foodModel.isExpired)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Expired At : ${foodModel.expirationDate.toFormatedDate}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      clear,
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.grey[300],
                        value: foodModel.value,
                      ),
                      Text(
                        foodModel.timeLeft,
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  );

        var recipes = Bounce(
          duration: const Duration(milliseconds: 150),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Recipes(food: foodModel))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Recipes",
                style: TextStyle(
                    color: Colors.red[800],
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
              const SizedBox(width: 5),
              Icon(
                FontAwesomeIcons.bowlRice,
                size: 17,
                color: Colors.red[900],
              ),
            ],
          ),
        );

        var donate = Bounce(
          duration: const Duration(milliseconds: 150),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Donations())),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Donate",
                style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
              const SizedBox(width: 8),
              Icon(
                FontAwesomeIcons.handshakeAngle,
                size: 17,
                color: Colors.orange[900],
              ),
            ],
          ),
        );

        var consumed = Bounce(
          duration: const Duration(milliseconds: 150),
          onPressed: () async {
            startLoading(context);
            await foodModel.cancelNotifications;

            await foodModel.reference!.delete();

            endLoading(context);
            await showAdaptiveDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: Text("Bon Appetit"),
                content: Text("This item will be removed from inventory."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Okay"),
                  )
                ],
              ),
            );

            widget.afterDelete?.call();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Consumed",
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.green[700]),
              ),
              const SizedBox(width: 5),
              Icon(FontAwesomeIcons.check, size: 17, color: Colors.green[900]),
            ],
          ),
        );

        var status = Material(
          color: foodModel.statusColor,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              foodModel.status,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        );

        var date = (foodModel.addedAt == null)
            ? const SizedBox()
            : Text(
                "${foodModel.addedAt!.toFormatedTime}, ${foodModel.addedAt!.toFormatedDate}",
                style: const TextStyle(
                  fontSize: 12,
                ),
              );

        var row = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            status,
            const Expanded(child: SizedBox()),
            date,
          ],
        );

        var image = CachedNetworkImage(
          imageUrl: foodModel.image,
          width: 40,
          height: 40,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: const Color.fromARGB(255, 247, 247, 247),
            elevation: 2,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (foodModel.addedAt != null) ...[
                    row,
                    const SizedBox(height: 15),
                  ],
                  Row(
                    children: [
                      image,
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              foodModel.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Expires after ${foodModel.days} days, ${foodModel.hours} hours",
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.isSelected != null)
                        Icon(
                          (widget.isSelected!)
                              ? FontAwesomeIcons.solidCircleCheck
                              : FontAwesomeIcons.circleCheck,
                          color:
                              (widget.isSelected!) ? primaryColor : Colors.grey,
                          size: 20,
                        ),
                      circle,
                    ],
                  ),
                  if (foodModel.addedAt != null && !foodModel.isExpired) ...[
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        recipes,
                        const SizedBox(width: 20),
                        donate,
                        const Expanded(child: SizedBox(width: 20)),
                        consumed,
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
