import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Players',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Players'),
        ),
        body: PlayerLists(this.getSelectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.adjust), title: Text('P')),
            BottomNavigationBarItem(icon: Icon(Icons.adjust), title: Text('D')),
            BottomNavigationBarItem(icon: Icon(Icons.adjust), title: Text('C')),
            BottomNavigationBarItem(icon: Icon(Icons.adjust), title: Text('T')),
            BottomNavigationBarItem(icon: Icon(Icons.adjust), title: Text('A')),
          ],
          onTap: _onTap,
        ),
      ),
    );
  }

  _onTap(int index) {
    setState(() {
      this._selectedIndex = index;
    });
  }

  int getSelectedIndex() => this._selectedIndex;
}

class PlayerLists extends StatefulWidget {
  var _selectedIndex;

  PlayerLists(this._selectedIndex);

  @override
  _PlayerListsState createState() => _PlayerListsState(_selectedIndex);
}

class _PlayerListsState extends State<PlayerLists> {
  Map<String, List> players = Map();
  var _selectedIndex;

  _PlayerListsState(this._selectedIndex);

  Future<String> _fetchData() async {
    var portieri = await http.get(
        Uri.encodeFull('http://192.168.1.20:3000/players?position=P'),
        headers: {"Accept": "application/json"});

    var difensori = await http.get(
        Uri.encodeFull('http://192.168.1.20:3000/players?position=D'),
        headers: {"Accept": "application/json"});

    var centrocampisti = await http.get(
        Uri.encodeFull('http://192.168.1.20:3000/players?position=C'),
        headers: {"Accept": "application/json"});

    var attaccanti = await http.get(
        Uri.encodeFull('http://192.168.1.20:3000/players?position=A'),
        headers: {"Accept": "application/json"});

    if (players.isNotEmpty) return null;

    setState(() {
      players['portieri'] = json.decode(portieri.body).toList();
      players['difensori'] = json.decode(difensori.body).toList();
      players['centrocampisti'] = json.decode(centrocampisti.body).toList();
      players['attaccanti'] = json.decode(attaccanti.body).toList();

      players['trequartisti'] = List();

      players['trequartisti'].addAll(players['centrocampisti']);
      players['trequartisti'].addAll(players['attaccanti']);

      players['trequartisti'] =
          players['trequartisti'].where((p) => p['playmaker'] == 1).toList();

      players['trequartisti']
          .sort((a, b) => b['quotation'].compareTo(a['quotation']));
    });
  }

  @override
  Widget build(BuildContext context) {
    this._fetchData();
    String key = indexToKey(this._selectedIndex());

    return ListView.builder(
        itemCount: players.isEmpty ? 0 : players[key].length,
        key: Key(key),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                      child: Row(
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/originals/04/7d/fc/047dfc2552d91ae45f5c5362e71f4e43.gif'),
                          radius: min(MediaQuery.of(context).size.height,
                                  MediaQuery.of(context).size.width) *
                              0.05,
                        ),
                      ),
                      Container(
                        child: Text(
                          players[key][index]['name'],
                          style: TextStyle(fontSize: 20),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width * 0.75,
                      ),
                      Container(
                        child: CircleAvatar(
                          backgroundColor:
                              players[key][index]['position'] == 'A'
                                  ? Colors.red
                                  : players[key][index]['position'] == 'C'
                                      ? Colors.blue
                                      : players[key][index]['position'] == 'D'
                                          ? Colors.green
                                          : Colors.orange,
                          child: Text(
                            players[key][index]['position'],
                            style: TextStyle(color: Colors.white),
                          ),
                          radius: min(MediaQuery.of(context).size.height,
                                  MediaQuery.of(context).size.width) *
                              0.05,
                        ),
                      )
                    ],
                  )),
                ],
              ),
            ),
          );
        });
  }

  double min(double a, double b) => a > b ? b : a;

  String indexToKey(int index) {
    switch (index) {
      case 0:
        return "portieri";
        break;
      case 1:
        return "difensori";
        break;
      case 2:
        return "centrocampisti";
        break;
      case 3:
        return "trequartisti";
        break;
      case 4:
        return "attaccanti";
        break;
    }
  }
}
