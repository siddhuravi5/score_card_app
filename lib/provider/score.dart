import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Score with ChangeNotifier {
  List<List<int>> score = List.generate(
      30, (i) => List.filled(2, 0, growable: true),
      growable: false);
  int playerCount = 2;
  List<int> result = [0, 0];
  List<String> playerNames = ['', ''];
  bool isFamilygame = false;
  bool isMaxScoreGame = false;
  bool autosave = false;

  void toogleAutoSave() {
    autosave = !autosave;
    notifyListeners();
  }

  Color getAutoSaveBtnColor() {
    if (autosave) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  void setPlayerName(index, name) {
    playerNames[index] = name;
  }

  String getPlayerName(index) {
    if (index < 0 || index >= playerNames.length) {
      return '';
    } else {
      return playerNames[index];
    }
  }

  List<String> getPlayerNames() {
    return playerNames;
  }

  void setFamilyNames() {
    playerCount = 3;
    playerNames = ['Mom', 'Hrishi', 'Siddhu'];
    result = [0, 0, 0];
    score = List.generate(30, (i) => List.filled(3, 0, growable: true),
        growable: false);
    print('family');
    isFamilygame = true;
    notifyListeners();
  }

  bool getIsFamilygame() {
    return isFamilygame;
  }

  void decreasePlayerCount() {
    playerCount = playerCount - 1;
    for (int i = 0; i < 30; i++) {
      score[i].removeLast();
    }
    result.removeLast();
    playerNames.removeLast();
    notifyListeners();
  }

  void incPlayerCount() {
    playerCount = playerCount + 1;
    for (int i = 0; i < 30; i++) {
      score[i].add(0);
    }
    result.add(0);
    playerNames.add('');
    notifyListeners();
  }

  int getPlayerCount() {
    return playerCount;
  }

  void reset() {
    for (int i = 0; i < 30; i++) {
      for (int j = 0; j < playerCount; j++) {
        score[i][j] = 0;
      }
    }
    for (int i = 0; i < playerCount; i++) {
      result[i] = 0;
    }
    notifyListeners();
  }

  Future<void> saveScore() async {
    var url = Uri.parse(
        'https://scoreboard-382c4.firebaseio.com/mem-cards-general-temp-data.json');
    try {
      await http.delete(url);
      await http.post(url,
          body: json.encode({
            'score': score,
            'players': getPlayerNames(),
            'playerCount': getPlayerCount(),
          }));
    } catch (err) {
      // ignore: avoid_print
      print(err);
    }
  }

  Future<void> loadScore() async {
    var url = Uri.parse(
        'https://scoreboard-382c4.firebaseio.com/mem-cards-general-temp-data.json');
    try {
      final response = await http.get(url);
      final extractedData1 = json.decode(response.body) as Map<String, dynamic>;
      extractedData1.forEach((key, extractedData) {
        int newPlayerCount = extractedData['playerCount'];
        print(newPlayerCount);

        if (newPlayerCount >= playerCount) {
          while (newPlayerCount != playerCount) {
            playerCount = playerCount + 1;
            for (int i = 0; i < 30; i++) {
              score[i].add(0);
            }
            result.add(0);
            playerNames.add('');
          }
        } else {
          while (newPlayerCount != playerCount) {
            playerCount = playerCount - 1;
            for (int i = 0; i < 30; i++) {
              score[i].removeLast();
            }
            result.removeLast();
            playerNames.removeLast();
          }
        }

        for (int i = 0; i < 30; i++) {
          for (int j = 0; j < playerCount; j++) {
            score[i][j] = extractedData['score'][i][j];
          }
        }

        playerNames = List<String>.from(extractedData['players']);
      });
      calcResult();
      notifyListeners();
    } catch (err) {
      // ignore: avoid_print
      print(err);
    }
  }

  void add(int playerIndex, int rowIndex, int points) {
    score[rowIndex][playerIndex] = points;
    calcResult();
    notifyListeners();
    if (autosave) {
      saveScore();
    }
  }

  int getCellValue(int playerId, int j) {
    return score[j][playerId];
  }

  void calcResult() {
    for (int i = 0; i < playerCount; i++) {
      result[i] = 0;
    }
    for (int i = 0; i < 30; i++) {
      for (int j = 0; j < playerCount; j++) {
        result[j] += score[i][j];
      }
    }
  }

  List<int> getResult() {
    return result;
  }

  void setFamilygameToFalse() {
    isFamilygame = false;
  }

  bool getIsMaxScoreGame() {
    return isMaxScoreGame;
  }

  void toggleIsMaxScoreGame() {
    isMaxScoreGame = !isMaxScoreGame;
    notifyListeners();
  }
}
