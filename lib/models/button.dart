// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import '../provider/history_provider.dart';
import '../provider/score.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  List<String> names = [];
  bool draw = false;
  List<int> scores=[];

  Button({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryData>(context);
    final score = Provider.of<Score>(context,listen: false);

    names = score.getPlayerNames();
    scores = score.getResult(); 
    //final score = Provider.of<ListProvider>(context);
    return TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text('Finish this Game',
                        style: TextStyle(color: Colors.red)),
                    content: const Text('Are you sure?',
                        style: TextStyle(color: Colors.redAccent)),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('NO',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 19))),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('YES',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 19)))
                    ],
                  )).then((val) {
            if (val == true) {
              if(score.getIsMaxScoreGame()){
                for(int i=0;i<scores.length-1;i++){
                  for(int j=0;j<scores.length-i-1;j++){
                    if(scores[j]<scores[j+1]){
                      //swap
                      int temp = scores[j];
                      scores[j]=scores[j+1];
                      scores[j+1]=temp;

                      //swap names in parallel
                      String tempName = names[j];
                      names[j]=names[j+1];
                      names[j+1]=tempName;
                    }
                  }
                }
              }else{
                for(int i=0;i<scores.length-1;i++){
                  for(int j=0;j<scores.length-i-1;j++){
                    if(scores[j]>scores[j+1]){
                      //swap
                      int temp = scores[j];
                      scores[j]=scores[j+1];
                      scores[j+1]=temp;

                      //swap names in parallel
                      String tempName = names[j];
                      names[j]=names[j+1];
                      names[j+1]=tempName;
                    }
                  }
                }
              }
              
              history.addItem(HistoryItem(
                  names: names,
                  dateTime: DateTime.now(),
                  points: scores,
                  id: DateTime.now().toString(),
                  isMaxScoreGame: score.getIsMaxScoreGame(),
                  tie: scores[0]==scores[1])).then((value){score.reset();});
              
            }
          });
        },
        child: const Text(
          'Finish',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.pink, fontSize: 24),
        ));
  }
}
