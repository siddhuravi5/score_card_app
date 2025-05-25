import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/score.dart';

// ignore: must_be_immutable
class ScoreTextCard extends StatefulWidget {
  final int playerId;
  final int rowId;
  ScoreTextCard(this.playerId, this.rowId, {Key? key}) : super(key: key);
  int val=0;
   //Color col=Colors.limeAccent;

  @override
  // ignore: library_private_types_in_public_api
  _ScoreTextCardState createState() => _ScoreTextCardState();
}

class _ScoreTextCardState extends State<ScoreTextCard> {
  final textController = TextEditingController();
  
  final colorList=[Colors.limeAccent,const Color.fromARGB(255, 51, 160, 207),const Color.fromARGB(255, 239, 64, 122)];
  bool inputOrText= false; //input

  @override
  Widget build(BuildContext context) {
    
    final scoreProvider = Provider.of<Score>(context);
  //  final score = Provider.of<ListProvider>(context);

    return SizedBox(
      width: 100,
      height: 50,
      child: GestureDetector(
        onTap: (){
            setState(() {
              inputOrText = !inputOrText;
            });
        },
        onDoubleTap: (){
          setState(() {
            widget.val=-10;
            scoreProvider.add(widget.playerId,widget.rowId,widget.val);
          });
        },
        onLongPress: (){
          setState(() {
            widget.val=0;
            scoreProvider.add(widget.playerId,widget.rowId, widget.val);
            //widget.col=Colors.limeAccent;
          });
        },
        child: Card(
          color: (scoreProvider.getCellValue(widget.playerId,widget.rowId)==0)?colorList[0]:scoreProvider.getCellValue(widget.playerId,widget.rowId)>0?colorList[1]:colorList[2],
          elevation: 5,
          child: Align(
            alignment: Alignment.center,
            child: inputOrText? TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              controller: textController,
              onSubmitted: (text){
                textController.text ='';
                setState(() {
                  widget.val = text.isEmpty?scoreProvider.getCellValue(widget.playerId, widget.rowId):int.parse(text);
                  scoreProvider.add(widget.playerId,widget.rowId,widget.val);
                  inputOrText = false;
                });
              },
            )
            :Text(
              scoreProvider.getCellValue(widget.playerId,widget.rowId).toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18)
            ),
          ),
        ),
      ),
    );
  }
}
