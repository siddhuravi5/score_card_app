import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/score.dart';

class NameCard extends StatefulWidget {
  final int playerIndex;

  // ignore: use_key_in_widget_constructors
  const NameCard(this.playerIndex);

  @override
  State<NameCard> createState() => _NameCardState();
}

class _NameCardState extends State<NameCard> {
  TextEditingController textController = TextEditingController();
  bool inputOrText = true;
  bool editPlayerName = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textController = TextEditingController(
        text: Provider.of<Score>(context).getPlayerName(widget.playerIndex));
  }

  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<Score>(context);
    var playerName = scoreProvider.playerNames[widget.playerIndex];
    if ((widget.playerIndex < 3 && scoreProvider.getIsFamilygame()) ||
        (!playerName.isEmpty && !editPlayerName)) {
      inputOrText = false;
    }
    return SizedBox(
      width: 100,
      child: Card(
          elevation: 5,
          color: Colors.orange,
          child: GestureDetector(
              onTap: () {
                setState(() {
                  inputOrText = true;
                  editPlayerName = true;
                  scoreProvider.setFamilygameToFalse();
                });
              },
              child: Align(
                  alignment: Alignment.center,
                  child: inputOrText
                      ? TextField(
                          autofocus: true,
                          keyboardType: TextInputType.name,
                          controller: textController,
                          onSubmitted: (text) {
                            playerName = text.isEmpty
                                ? scoreProvider.playerNames[widget.playerIndex]
                                : text[0].toUpperCase() + text.substring(1);
                            scoreProvider.setPlayerName(
                                widget.playerIndex, playerName);
                            setState(() {
                              inputOrText = false;
                              editPlayerName = false;
                            });
                          })
                      : Text(playerName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          textAlign: TextAlign.center)))),
    );
  }
}
