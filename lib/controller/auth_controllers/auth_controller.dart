import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:music_mind_client/view/user/login.dart';

class AuthController extends GetxController{
 final FirebaseAuth _auth = FirebaseAuth.instance;
 Rxn<User> _firebaseUser = Rxn<User>();

 String? get user => _firebaseUser.value?.email;

 @override
 void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    print(" Auth Change :   ${_auth.currentUser}");
  }

  //Function to Register User
  void registerUser(String email, String password, String firstName, String lastName) async {
   CollectionReference usersReference = FirebaseFirestore.instance.collection('Users');
   Map<String, String> userData = {
    'first_name': firstName,
    'last_name' : lastName,
    'email': email
   };

   await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
    usersReference.add(userData).then((value) {
     //add user to SQL DATABASE
    });
   }).catchError((onError) {
    Get.snackbar('Error', onError.message, snackPosition: SnackPosition.BOTTOM);
   });

  }

 //Function to Login User
  void login(String email, String password,) async {
  await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
   Get.offAll(BottomNavBar());
  }).catchError((onError) {
   Get.snackbar('Error', onError.message, snackPosition: SnackPosition.BOTTOM);
  });
  }

 void signOut() async{
   await _auth.signOut().then((value) => Get.offAll(Login()));
 }
}