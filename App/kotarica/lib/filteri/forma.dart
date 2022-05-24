

import 'package:flutter/material.dart';

class odabraniFilteri
{
    //String _kategorija;
    //String _Grad;
    RangeValues _okvirCena;
    bool _porudzbina;
    //bool _razmena;

    odabraniFilteri(//this._kategorija,
        // this._Grad,
        this._okvirCena,
      this._porudzbina, //this._razmena
     );
    //bool get razmena => _razmena;

  /*set razmena(bool value) {
    _razmena = value;
  }*/

  bool get porudzbina => _porudzbina;

  set porudzbina(bool value) {
    _porudzbina = value;
  }

  RangeValues get okvirCena => _okvirCena;

  set okvirCena(RangeValues value) {
    _okvirCena = value;
  }

  /*String get Grad => _Grad;

  set Grad(String value) {
    _Grad = value;
  }*/

  /*String get kategorija => _kategorija;

  set kategorija(String value) {
    _kategorija = value;
  }*/

    //@override
  /*String toString() {
    return 'odabraniFilteri{_kategorija: $_kategorija, _Grad: $_Grad, _okvirCena: $_okvirCena, _porudzbina: $_porudzbina, _razmena: $_razmena}';
  }*/
}










