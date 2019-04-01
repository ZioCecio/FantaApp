import 'dart:convert';

import 'package:flutter/material.dart';
import 'Widgets/PlayerLists.dart';

import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _pageNumber = 0;
  int _selectedIndex = 0;
  SocketIO socket;

  @override
  void initState() {
    socket = SocketIOManager().createSocketIO('http://192.168.1.20:3000', '/');
    socket.init();

    socket.subscribe('changePage', (page) {
      setState(() {
        int n = json.decode(page);
        this._pageNumber = n;
      });
    });

    socket.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Players',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Players'),
        ),
        body: _pageNumber == 0
            ? PlayerLists(this.getSelectedIndex, this.socket)
            : Text('ELSE'),
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
