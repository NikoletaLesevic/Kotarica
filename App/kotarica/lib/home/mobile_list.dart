import 'package:flutter/material.dart';
import 'package:kotarica/model/AdModel.dart';

import 'KratakPrikazOglasa.dart';

class MobileList extends StatefulWidget {
  AdListModel listModel;
  List listOfAdd;
  ScrollController _scrollController = new ScrollController();
  Set<String> myWishList;

  MobileList(AdListModel listModel, List listOfAdd, Set<String> myWishList) {
    print("PRIMILI SMO OGLASE " + listOfAdd.length.toString());
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
  _MobileListState createState() => _MobileListState();
}

class _MobileListState extends State<MobileList> {
  @override
  Widget build(BuildContext context) {
    if (widget.listOfAdd.length == 0) {
      return Container();
    }
    return GridView.builder(
        padding: EdgeInsets.all(8),
        controller: widget._scrollController,
        itemCount: widget.listOfAdd.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 2,
            mainAxisExtent: 310),
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
