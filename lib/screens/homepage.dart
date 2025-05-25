import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import '../models/namecard.dart';
import '../models/scoretextcard.dart';
import '../models/total_score_card.dart';
import '../models/button.dart';
import '../provider/score.dart';
import './history.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  static const routeName = "/home-page";
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //Future.delayed(const Duration(seconds: 0)).then((_){Provider.of<Score>(context,listen: false).init();});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<Score>(context);
    var phoneSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Board'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Load Score',
                              style: TextStyle(color: Colors.red)),
                          content: const Text('Confirm?',
                              style: TextStyle(color: Colors.redAccent)),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('NO',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 19))),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('YES',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 19)))
                          ],
                        )).then((val) {
                  if (val == true) {
                    Provider.of<Score>(context, listen: false).loadScore();
                  }
                });
              },
              icon: const Icon(Icons.arrow_downward_rounded)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Save Score',
                              style: TextStyle(color: Colors.red)),
                          content: const Text('Confirm?',
                              style: TextStyle(color: Colors.redAccent)),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('NO',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 19))),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('YES',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 19)))
                          ],
                        )).then((val) {
                  if (val == true) {
                    Provider.of<Score>(context, listen: false).saveScore();
                  }
                });
              },
              icon: const Icon(Icons.arrow_upward)),
          IconButton(
              onPressed: () {
                scoreProvider.toogleAutoSave();
              },
              icon: Icon(
                Icons.save,
                color: scoreProvider.getAutoSaveBtnColor(),
              )),
          IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.of(context).pushNamed(History.routeName);
              })
        ],
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: FloatingActionButton(
            heroTag: 'btn1',
            backgroundColor: Colors.green,
            onPressed: () {
              scoreProvider.decreasePlayerCount();
            },
            // isExtended: true,
            child: const Align(
                alignment: Alignment.center, child: Icon(Icons.remove)),
          ),
        ),
        FloatingActionButton(
          heroTag: 'btn2',
          backgroundColor: Colors.green,
          onPressed: () {
            scoreProvider.incPlayerCount();
          },
          // isExtended: true,
          child: Align(
              alignment: Alignment.center,
              child: Text(scoreProvider.getPlayerCount().toString())),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: phoneSize.height * 0.9,
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Text(scoreProvider.getIsMaxScoreGame() ? 'Max' : 'Min',
                            style: TextStyle(
                                color: scoreProvider.getIsMaxScoreGame()
                                    ? Colors.orange
                                    : Colors.green)),
                        IconButton(
                            onPressed: () {
                              scoreProvider.toggleIsMaxScoreGame();
                            },
                            icon: Icon(scoreProvider.getIsMaxScoreGame()
                                ? Icons.arrow_upward_outlined
                                : Icons.arrow_downward_outlined)),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        scoreProvider.setFamilyNames();
                      },
                      icon: const Icon(Icons.people)),
                ],
              ),
              SizedBox(
                height: phoneSize.height * 0.7,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(height: phoneSize.height * 0.02),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: phoneSize.height * 0.075,
                        child: Row(
                          children: [
                            for (int i = 0;
                                i < scoreProvider.getPlayerCount();
                                i++)
                              NameCard(i)
                          ],
                        ),
                      ),
                      const Divider(),

                      SizedBox(
                          height: phoneSize.height * 0.4,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(children: [
                                for (int i = 0; i < 30; i++)
                                  Row(
                                    children: [
                                      for (int j = 0;
                                          j < scoreProvider.getPlayerCount();
                                          j++)
                                        ScoreTextCard(j, i)
                                    ],
                                  )
                              ]))),

                      const Divider(),
                      SizedBox(
                        height: phoneSize.height * 0.02,
                      ),
                      SizedBox(
                          height: phoneSize.height * 0.075,
                          child: Row(
                            children: [
                              for (int i = 0;
                                  i < scoreProvider.getPlayerCount();
                                  i++)
                                TotalScoreCard(i)
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Button(),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
