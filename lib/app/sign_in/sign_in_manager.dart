import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timetracker/services/auth.dart';

// formerly signInBloc
class SignInManager{

  SignInManager({@required this.auth, this.isLoading});
  final AuthBase auth;
  // controls the loading state of the app (used with BLoC
 // final StreamController<bool> _isLoadingController = StreamController<bool>();
 // Stream<bool> get isLoadingStream => _isLoadingController.stream;
  final ValueNotifier<bool> isLoading;

//  void dispose(){
//    _isLoadingController.close();
//  }

 // void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  // takes in a function as an argument
  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
     // _setIsLoading(true);
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      //_setIsLoading(false);
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);



}