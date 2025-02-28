import 'package:anitier2/src/features/create/presentation/widgets/dialogs.dart';
import 'package:anitier2/src/features/shared/models/tier.dart';
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () async {
                var newTierList = await showTierListCreationDialog(context);
                if (newTierList != null) {
                  final List<Tier> initialTiers = [
                    Tier(rank: 'S', color: Colors.green),
                    Tier(rank: 'A', color: Colors.greenAccent),
                    Tier(rank: 'B', color: Colors.yellow),
                    Tier(rank: 'C', color: Colors.orange),
                    Tier(rank: 'D', color: Colors.deepOrange),
                    Tier(rank: 'F', color: Colors.red)
                  ];
                  newTierList = newTierList.copyWith(tiers: () => initialTiers);
                  print(newTierList);
                }
              },
              child: Text("Create New"),
            ),
            SizedBox(
              height: 8,
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text("Edit Tier List"),
            ),
            SizedBox(
              height: 8,
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text("Create From Template"),
            ),
          ],
        ),
      ),
    );
  }
}
