import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:music_mind_client/view/user/login.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController{
 final FirebaseAuth _auth = FirebaseAuth.instance;
 Rxn<User> _firebaseUser = Rxn<User>();
 var isLoading = 'false'.obs;
 FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    // Getting reference for user collection
    DocumentReference usersReference = FirebaseFirestore.instance.collection('Users').doc();

   //step-1 first create user in firebase for auth
   await _auth.createUserWithEmailAndPassword(email: email, password: password).then((usr) async {
     Map<String, String> userDataForApi = {
       'uid' : usr.user!.uid,
       'first_name': firstName,
       'last_name' : lastName,
       'email': email,
       'display_name': '$firstName $lastName',
     };

    // print('createUserWithEmailAndPassword with value: ${usr.user!.email}');


    try{
      final url = Uri.parse('${dotenv.env['db_url']}/user/${usr.user!.uid}/add');
      final res = await http.post(url, body: userDataForApi);
      print('printing response from api \n ${res.body}');
      final resData = jsonDecode(res.body);
      print('**************************');
      print(resData['response']);
      print(resData['response'].runtimeType);
      if(resData['response'] == 200){
        isLoading.value = 'false';
        update();
        Get.offAll(() => BottomNavBar());

      }else if((resData['response'] !=200) && (resData['errors'] != null)){
        print('oops');
        print(resData['errors'].keys.toList().first);
        FirebaseAuth.instance.currentUser!.delete();
      }

    }catch(e){
      print('Im in catch $e');
      FirebaseAuth.instance.currentUser!.delete();
      Get.snackbar('Error', 'Error', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.grey );
    }

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