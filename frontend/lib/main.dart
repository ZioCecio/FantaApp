import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(App());

class Prova extends StatefulWidget {
  @override
  _ProvaState createState() => _ProvaState();
}

class _ProvaState extends State<Prova> {
  List data, gk, def, cm, cam, st;

  var _selectedIndex = 'P';
  int _index = 0;
  
  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http.get(
      Uri.encodeFull('http://192.168.1.20:3000/players'),
      headers: {"Accept": "application/json"}
    );

    setState(() {
     var convertDataToJson = json.decode(response.body);
     data = convertDataToJson;
    });
  }

  double min (double a, double b) => a > b ? b : a;

  @override
  Widget build(BuildContext context) {
    this.getJsonData();

    List x = null;
    if(_selectedIndex == 'T')
      x = data.where((p) => p['playemaker'] == true).toList();
    else
      x = data.where((p) => p['position'] ==_selectedIndex).toList();

    final list = new ListView.builder(
          itemCount: x == null ? 0 : x.length,
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
                              backgroundImage: NetworkImage('https://i.pinimg.com/originals/04/7d/fc/047dfc2552d91ae45f5c5362e71f4e43.gif'),
                              radius: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) * 0.05,
                            ),
                          ),
                          Container(
                            child: Text(
                              x[index]['name'],
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                            padding: const EdgeInsets.all(20.0),
                            width: MediaQuery.of(context).size.width * 0.75,
                          ),
                          Container(
                            child: CircleAvatar(
                              backgroundColor: x[index]['position'] == 'A'
                              ? Colors.red
                              : x[index]['position'] == 'C'
                              ? Colors.blue
                              : x[index]['position'] == 'D'
                              ? Colors.green
                              : Colors.orange,
                              child: Text(
                                x[index]['position'],
                                style: TextStyle(
                                  color: Colors.white
                                  ),
                                ),
                              radius: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) * 0.05,
                            ),
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ),
            );
          },
        );

    return MaterialApp(
      title: 'Players',
      home: Scaffold(
        appBar: AppBar(
          title: Text('List of players'),
        ),
        body: list,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _index,
          fixedColor: Colors.blue,
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.adjust),
              title: Text('P'),
              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adjust),
              title: Text('D'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adjust),
              title: Text('C')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adjust),
              title: Text('T')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adjust),
              title: Text('A')
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
     switch (index) {
       case 0:
         _selectedIndex = 'P';
         break;
       case 1:
         _selectedIndex = 'D';
         break;
       case 2:
         _selectedIndex = 'C';
         break;
       case 3:
         _selectedIndex = 'T';
         break;
       case 4:
         _selectedIndex = 'A';
         break;
     }

     this._index = index; 
    });
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Players',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Players'),
        ),
        body: PlayerLists(),
      ),
    );
  }
}

class PlayerLists extends StatefulWidget {
  @override
  _PlayerListsState createState() =>_PlayerListsState();
}

class _PlayerListsState extends State<PlayerLists> {
  Map<String, List> players = Map();
  int _selectedIndex = 0;

  Future<String> _fetchData() async {

    var portieri = await http.get(
      Uri.encodeFull('http://192.168.1.20:3000/players?position=P'),
      headers: {"Accept": "application/json"}
    );

    var difensori = await http.get(
      Uri.encodeFull('http://192.168.1.20:3000/players?position=D'),
      headers: {"Accept": "application/json"}
    );

    var centrocampisti = await http.get(
      Uri.encodeFull('http://192.168.1.20:3000/players?position=C'),
      headers: {"Accept": "application/json"}
    );

    var attaccanti = await http.get(
      Uri.encodeFull('http://192.168.1.20:3000/players?position=A'),
      headers: {"Accept": "application/json"}
    );

    if(players.isNotEmpty)
      return null;

    setState(() {
      players['portieri'] = json.decode(portieri.body).toList();
      players['difensori'] = json.decode(difensori.body).toList();
      players['centrocampisti'] = json.decode(centrocampisti.body).toList();
      players['attaccanti'] = json.decode(attaccanti.body).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = 2;
    this._fetchData();
    String key = indexToKey(_selectedIndex);

    return ListView.builder(
      itemCount: players[key].length,
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
                          backgroundImage: NetworkImage('https://i.pinimg.com/originals/04/7d/fc/047dfc2552d91ae45f5c5362e71f4e43.gif'),
                          radius: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) * 0.05,
                        ),
                      ),
                      Container(
                        child: Text(
                          players[key][index]['name'],
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width * 0.75,
                      ),
                      Container(
                        child: CircleAvatar(
                          backgroundColor: players[key][index]['position'] == 'A'
                          ? Colors.red
                          : players[key][index]['position'] == 'C'
                          ? Colors.blue
                          : players[key][index]['position'] == 'D'
                          ? Colors.green
                          : Colors.orange,
                          child: Text(
                            players[key][index]['position'],
                            style: TextStyle(
                              color: Colors.white
                              ),
                            ),
                          radius: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) * 0.05,
                        ),
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
        );
      }
    );
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
        return "attaccanti";
        break;
    }
  }
}