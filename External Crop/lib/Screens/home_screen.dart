import 'package:flutter/material.dart';
import 'package:external_crop/Widget/dash_board_card_table_page.dart';
import 'package:external_crop/Widget/dash_board_page_title.dart';
import 'package:external_crop/Widget/dash_board_background_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
        body: Stack(
        children: [
          BackgroundScreen(),
          _HomeBody(),
        ],
      ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      children: [
        PageTitle(),
        CardTablePage(),
      ],
    ),
  );
}