
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


//names and points in sorted order
class HistoryItem {
  final String id;
  final List<String> names;
  final DateTime dateTime;
  final List<int> points;
  final bool tie;
  final bool isMaxScoreGame;
  HistoryItem(
      {required this.id,
      required this.names,
      required this.dateTime,
      required this.points,
      required this.tie,
      required this.isMaxScoreGame});
}

class HistoryData with ChangeNotifier {
  final List<HistoryItem> _list = [];

  Future<void> addItem(HistoryItem item) async {
    var url = Uri.parse('https://scoreboard-382c4.firebaseio.com/mem-cards-general.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'names': item.names,
            'points': item.points,
            'date': item.dateTime.toIso8601String(),
            'draw': item.tie,
            'isMaxScoreGame' : item.isMaxScoreGame,
          }));
      final prod = HistoryItem(
          id: json.decode(response.body)['name'],
          names: item.names,
          dateTime: item.dateTime,
          points: item.points,
          tie: item.tie,
          isMaxScoreGame: item.isMaxScoreGame);
      _list.insert(0, prod);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    notifyListeners();
  }

  Future<void> delete(String id) async {
    var url = Uri.parse('https://scoreboard-382c4.firebaseio.com/mem-cards-general/$id.json');
    http.delete(url);
    _list.removeWhere((prod){return prod.id==id;});
    notifyListeners();
  }
  Future<void> getList2() async { 
 
  }
  Future<void> getList() async {
    _list.clear();
    var url = Uri.parse('https://scoreboard-382c4.firebaseio.com/mem-cards-general.json');
    try{
      final response = await http.get(url);
  
    
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((key, value) {
    // List<HistoryItem> _list2 = [];
    // print('my ' + value['point1'].toString());
    _list.insert(
        0,
        HistoryItem(
            id: key,
            names: List<String>.from(value['names']),
            dateTime: DateTime.parse(value['date']),
            points: List<int>.from(value['points']),
            isMaxScoreGame: value['isMaxScoreGame'],
            tie: value['draw']));
  });
    }catch(error){
      if (kDebugMode) {
        print('my error ');
        print(error);
      }
    
    }
    notifyListeners();
  }

  List<HistoryItem> get listgetter {
    return _list;
  }


}
