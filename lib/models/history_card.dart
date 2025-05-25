// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../provider/history_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

import '../provider/score.dart';

class HistoryCard extends StatefulWidget {
  final HistoryItem item;
  // ignore: use_key_in_widget_constructors
  const HistoryCard(this.item);

  @override
  // ignore: library_private_types_in_public_api
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  var dropDown = false;

  Color chooseColorFn(String name) {
    switch (name) {
      case 'Siddhu':
        return Colors.orange.shade400;
      case 'Mom':
        return Colors.pink.shade400;
      case 'Hrishi':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryData>(context);
    return widget.item.tie
        ? Dismissible(
            key: ValueKey(widget.item.id),
            background: Container(
              color: Colors.red,
              child: ListTile(
                trailing: IconButton(
                    icon: const Icon(Icons.delete), onPressed: () {}),
              ),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text(
                            'Do you want to delete this history data?',
                            style: TextStyle(color: Colors.redAccent)),
                        //content: Text('Are you sure?',
                        //                      style: TextStyle(color: Colors.redAccent)),
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
                      ));
            },
            onDismissed: (direction) {
              history.delete(widget.item.id);
            },
            child: const Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Tie',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(
                  thickness: 2,
                )
              ],
            ),
          )
        : Dismissible(
            key: ValueKey(widget.item.id),
            background: Container(
              color: Colors.red,
              child: ListTile(
                trailing: IconButton(
                    icon: const Icon(Icons.delete), onPressed: () {}),
              ),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text(
                            'Do you want to delete this history data?',
                            style: TextStyle(color: Colors.redAccent)),
                        //content: Text('Are you sure?',
                        //                      style: TextStyle(color: Colors.redAccent)),
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
                      ));
            },
            onDismissed: (direction) {
              history.delete(widget.item.id);
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Winner : ${widget.item.names[0]}'),
                  subtitle: Text(
                    DateFormat('dd/MM/yy hh:mm').format(widget.item.dateTime),
                  ),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: chooseColorFn(widget.item.names[0]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          widget.item.points[0].toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.item.isMaxScoreGame ? 'Max' : 'Min',
                            style: TextStyle(
                                color: widget.item.isMaxScoreGame
                                    ? Colors.orange
                                    : Colors.green)),
                        IconButton(
                            icon: Icon(dropDown
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down_circle),
                            onPressed: () {
                              setState(() {
                                dropDown = !dropDown;
                              });
                            }),
                      ],
                    ),
                  ),
                ),
                if (dropDown)
                  Container(
                    height: 175,
                    padding: const EdgeInsets.all(8),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.amber, width: 2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: ListView.builder(
                                padding: const EdgeInsets.all(7),
                                itemCount: widget.item.names.length,
                                itemBuilder: (ctx, i) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: FittedBox(
                                          child: Text(
                                            (i + 1).toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      widget.item.names[i],
                                      style: const TextStyle(
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Text(
                                        'Points : ${widget.item.points[i].toString()}',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                const Divider(
                  thickness: 2,
                )
              ],
            ),
          );
  }
}
