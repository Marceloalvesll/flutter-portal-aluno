import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _nomeUsuario = '';

  String get nomeUsuario => _nomeUsuario;

  void setNomeUsuario(String nome) {
    _nomeUsuario = nome;
    notifyListeners();
  }
}
