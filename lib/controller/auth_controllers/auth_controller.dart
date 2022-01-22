import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:music_mind_client/view/user/login.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController{
 final FirebaseAuth _auth = FirebaseAuth.instance;
 Rxn<User> _firebaseUser = Rxn<User>();
 var isLoading = 'false'.obs;
 late TextEditingController emailController, passController, firstNameController, lastNameController;



 String? get user => _firebaseUser.value?.email;


 @override
 void onInit() {
  emailController = TextEditingController();
  passController = TextEditingController();
  firstNameController = TextEditingController();
  lastNameController = TextEditingController();
    _firebaseUser.bindStream(_auth.authStateChanges());

    print('printing _firebase user $_firebaseUser');
    print(" Auth Change :   ${_auth.currentUser}");
  }
 @override
 void onClose() {
  emailController.dispose();
  passController.dispose();
  firstNameController.dispose();
  lastNameController.dispose();
 }

  //Function to Register User
  void registerUser(String email, String password, String firstName, String lastName) async {
     isLoading.value = 'true';
     update();

  print('register User function called with $email $password $firstName');
   CollectionReference usersReference = FirebaseFirestore.instance.collection('Users');
   Map<String, String> userData = {
    'first_name': firstName,
    'last_name' : lastName,
    'email': email
   };

   await _auth.createUserWithEmailAndPassword(email: email, password: password).then((usr) {
    print('createUserWithEmailAndPassword with value: ${usr.user!.email}');
    usersReference.add(userData).then((value) {
        final response = http.post(url, body: json.encode({
          'uid' : usr.user!.uid,
          'first_name': firstName,
          'last_name' : lastName,
          'email': email
        }));
        isLoading.value = 'false';
        update();

     //add user to SQL DATABASE

     Get.offAll(() => BottomNavBar());
    });
   }).catchError((onError) {
       isLoading.value = 'false';
       update();

    Get.snackbar('Error', onError.message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.grey );
   });

  }

 //Function to Login User
  void login(String email, String password,) async {
      isLoading.value = 'true';
      update();

  await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
   print('signInWithEmailAndPassword with value: $value');
      isLoading.value = 'false';
   update();

   Get.offAll(()=>BottomNavBar());
  }).catchError((onError) {
   Get.snackbar('Error', onError.message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.grey);
      isLoading.value = 'false';
   update();
    
  });
  }

 void signOut() async{
   await _auth.signOut().then((value) => Get.offAll(()=> Login()));
 }
}