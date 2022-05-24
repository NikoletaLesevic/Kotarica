import 'package:flutter/material.dart';
import 'package:kotarica/model/AdModel.dart';
import 'package:kotarica/model/WishModel.dart';

import 'KratakPrikazOglasa.dart';

class DesktoGrid extends StatefulWidget {
  AdListModel listModel;
  List listOfAdd;
  ScrollController _scrollController = new ScrollController();
  Set<String> myWishList;

  DesktoGrid(AdListModel listModel, List listOfAdd, Set<String> myWishList) {
    this.listModel = listModel;
    // this.listOfAdd = listOfAdd.reversed.toList();
    this.listOfAdd = listOfAdd;
    this.myWishList = myWishList;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        listModel.getAdsFromIndex();
      }
    });
  }

  @override
  _DesktoGridState createState() => _DesktoGridState();
}

class _DesktoGridState extends State<DesktoGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.all(15),
        controller: widget._scrollController,
        itemCount: widget.listOfAdd.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 5,
            mainAxisExtent: 160),
        itemBuilder: (BuildContext context, int index) {
          // print(listModel.ads[index].name.toLowerCase());
          bool flag = widget.myWishList.contains(widget.listOfAdd[index].name);
          return kratakPrikazOglasa.fromHome(
              kategorija: widget.listOfAdd[index].category,
              kratakOpis: widget.listOfAdd[index].description,
              slika: widget.listOfAdd[index].picHash,
              imeProizvoda: widget.listOfAdd[index].name,
              cena: double.parse(widget.listOfAdd[index].price),
              vlasnik: widget.listOfAdd[index].user,
              daLiSamLajkovao: flag,
              smeDaKomentarise: false,);
        });
  }
}
