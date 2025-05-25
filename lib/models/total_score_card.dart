import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import '../provider/score.dart';
class TotalScoreCard extends StatelessWidget {
  final int scoreId;
  // ignore: use_key_in_widget_constructors
  const TotalScoreCard(this.scoreId);
  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<Score>(context);
    List<int> res = scoreProvider.getResult();
    int score = res[scoreId];
    return SizedBox(
      width: 100,
      child: Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)),),
          color: score>=100?Colors.orange: const Color.fromARGB(255, 89, 218, 192),
            child: Align(
                alignment: Alignment.center,
                    child: Text(
                      score.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              ),
            ),
      ),
    );
  }
}
