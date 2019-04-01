import 'package:flutter/material.dart';

class PlayerAuction extends StatefulWidget {
  var player;

  PlayerAuction(this.player);

  _PlayerAuctionState createState() => _PlayerAuctionState(player);
}

class _PlayerAuctionState extends State<PlayerAuction> {
  var player;

  _PlayerAuctionState(this.player);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(player['name']),
    ));
  }
}
