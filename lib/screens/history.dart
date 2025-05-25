

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import '../provider/history_provider.dart';
import '../models/history_card.dart';


class History extends StatefulWidget {

  static const routeName = '/history';

  const History({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool spinner=true;
  bool _isInit = true;
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies (){
    if(_isInit){
      Provider.of<HistoryData>(context).getList().then((value) {
        spinner=false;
      },);
    }
    _isInit =false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    List<HistoryItem> list = Provider.of<HistoryData>(context).listgetter;
    final mediaQuery=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Board'),
      ),
      body: spinner?Stack(children: [
              Center(
                  child: Image.asset(
                'assets/images/loading.jpg',
                width: mediaQuery.width,
                height: mediaQuery.height,
                fit: BoxFit.fill,
              )),
              const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 5,
              ))
            ]):list.isEmpty? const Center(
        child: Text(
          'No past games to show...',
          style: TextStyle(fontSize: 22, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ) : Container(padding: const EdgeInsets.all(8),
      child: ListView.builder(itemCount: list.length ,itemBuilder: (ctx,i){
        return HistoryCard(list[i]);
      }),) 
    );
  }
}
