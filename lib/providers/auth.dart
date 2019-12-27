import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/exception.dart';

class Auth with ChangeNotifier{

  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _logoutTime;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if(_expireDate != null && _expireDate.isAfter(DateTime.now()) && _token != null)
      {
        return _token;
      }
    return null;
  }

  Future<void> authentication(String email, String password, String authSegment) async {
    var url = 'https://identitytoolkit.googleapis.com/v1/accounts:$authSegment?key=AIzaSyDJmNB8mtiT2dYifu3BWbCTNJxiOUpXqro';
    try {
      final response = await http.post(url, body: json.encode({
        'email' : email,
        'password': password,
        'returnSecureToken' : true,
      }));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null)
      {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(
          Duration(
              seconds: int.parse(
                  responseData['expiresIn'],
              ),
          ),
      );
      _autoLogout();
      print(responseData);
      notifyListeners();
    } catch(error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async{
    return authentication(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return authentication(email, password, 'signInWithPassword');
  }

  void logOut() {
    _token = null;
    _expireDate = null;
    _userId = null;
    if(_logoutTime != null) {
      _logoutTime.cancel();
      _logoutTime = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if(_logoutTime != null) {
      _logoutTime.cancel();
    }
    final expireTime = _expireDate.difference(DateTime.now()).inSeconds;
    _logoutTime = Timer(Duration(seconds: expireTime),logOut);
  }
}