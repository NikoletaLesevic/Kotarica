import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotarica/shared/Footer.dart';
import 'package:kotarica/shared/Header.dart';

import 'oglas_content.dart';

class Oglas extends StatelessWidget {
  final String name;
  final String price;
  final String owner;
  final String image;
  final String description;
  final String category;
  final bool smeDaKomentarise;

  const Oglas({
    this.name,
    this.price,
    this.owner,
    this.image,
    this.description,
    this.category,
    this.smeDaKomentarise
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: Header(),
      body: OglasContent(name: name, price: price, owner: owner, image: image, description: description,category: category,smeDaKomentarise: smeDaKomentarise,),
      bottomNavigationBar: Footer(),
    );
  }
}


