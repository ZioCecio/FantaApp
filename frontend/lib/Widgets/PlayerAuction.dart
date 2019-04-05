import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fanta/SocketAction.dart';

class PlayerAuction extends StatefulWidget {
  var player;

  PlayerAuction(this.player);

  _PlayerAuctionState createState() => _PlayerAuctionState(player);
}

class _PlayerAuctionState extends State<PlayerAuction> {
  var player;

  final formKey = GlobalKey<FormState>();
  final offerController = TextEditingController();

  int lastUser, lastOffer;

  _PlayerAuctionState(this.player);

  @override
  void initState() {
    SocketAction.subscribe('onOffer', (data) {
      final values = json.decode(data);

      setState(() {
        this.lastUser = values['user'];
        this.lastOffer = values['offer'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: Text(player['name']),
          ),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: offerController,
                ),
                RaisedButton(
                  onPressed: () {
                    SocketAction.doOffer(
                        offerController.text, player['id_player']);
                  },
                ),
                Text('Offerta di ${this.lastUser} da ${this.lastOffer}')
              ],
            ),
          )
        ],
      ),
    );
  }
}
