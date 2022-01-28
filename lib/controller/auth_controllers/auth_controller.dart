import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/utils/root.dart';
import 'package:music_mind_client/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:music_mind_client/view/user/login.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController{
 final FirebaseAuth _auth = FirebaseAuth.instance;
 Rxn<User> _firebaseUser = Rxn<User>();
 // FirebaseFirestore _firestore = FirebaseFirestore.instance;
 late TextEditingController emailController, passController, firstNameController, lastNameController;
 var userData = {};



 String? get user => _firebaseUser.value?.email;


 @override
 void onInit() {
   if(_auth.currentUser != null){
      getUserData();
   }
  emailController = TextEditingController();
  passController = TextEditingController();
  firstNameController = TextEditingController();
  lastNameController = TextEditingController();

    _firebaseUser.bindStream(_auth.authStateChanges());
    print(" Auth Changed");
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
  // print('register User function called with $email $password $firstName');
    // Getting reference for user collection
    // DocumentReference usersReference = FirebaseFirestore.instance.collection('Users').doc();


     //step-1 first create user in firebase for auth
     Get.snackbar('Please Wait','Signing up...',
         icon: Icon(Icons.person_add, color: Colors.blueAccent),snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white, duration: Duration(seconds: 4));
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
      final res = await http.post(url,headers: {'api-key': '${dotenv.env['api_key']}'}, body: userDataForApi);
      final resData = jsonDecode(res.body);
      print('**************************');
      print(resData['response']);
      print(resData['response'].runtimeType);
      if(resData['response'] == 200){
        Get.back(closeOverlays: true);
        await Future.delayed(Duration(milliseconds: 300));
        await getUserData();
        Get.offAll(() => BottomNavBar());
      }else if((resData['response'] !=200) && (resData['errors'] != null)){
        Get.back(closeOverlays: true);
        // print('oops');

        Get.snackbar('Error',resData['errors'], snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white );
        FirebaseAuth.instance.currentUser!.delete();
      }

    }catch(e){
      Get.back(closeOverlays: true);
      print('Im in catches $e');
      FirebaseAuth.instance.currentUser!.delete();
      Get.snackbar('Error', 'Error', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white );

    }

   }).catchError((onError) {

    Get.snackbar('Error', onError.message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white );
   });

  }

 //Function to Login User
  void login(String email, String password,) async {
    Get.snackbar('Please Wait','Logging In',
        icon: Icon(Icons.person_add, color: Colors.blueAccent),snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
  await _auth.signInWithEmailAndPassword(email: email, password: password).then((value)async {
   print('signInWithEmailAndPassword with value: $value');
   // Get.back(closeOverlays: true);
   await getUserData();
   Get.offAll(()=>BottomNavBar());
  }).catchError((onError) {
   Get.snackbar('Error', onError.message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
   Get.offAll(()=>Login());
  });
  }

 void signOut() async{
   Get.snackbar('Goodbye', 'See you again', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
   await _auth.signOut().then((value) => Get.offAll(()=> Login()));
 }

 getUserId(){
   return _auth.currentUser?.uid;
 }

 getUserData() async{
   try{
     final userId = _auth.currentUser?.uid;
     final url = Uri.parse('${dotenv.env['db_url']}/user/$userId');
     final res = await http.get(url, headers: {"api-key": "${dotenv.env['api_key']}","uid": "$userId"});
     final Data = jsonDecode(res.body);
     userData = Data['success']['data']['user'];
     return;
   }catch(e){
     print('error in fetching one user $e');
   }
 }

 Future playMission(missionId) async{
   try{
     var mission = {};
     final user_id = _auth.currentUser?.uid;
     final url = Uri.parse('${dotenv.env['db_url']}/mission/$missionId');
     final res = await http.get(url, headers: {"uid": "${user_id}", "api-key": "${dotenv.env['api_key']}"});
     final resData = jsonDecode(res.body);
     print(resData);
     if(resData['response'] == 200 ) {
        mission = {...resData['success']['data']['mission']};
        return mission;
     }else if((resData['response'] !=200) && (resData['errors'] != null)){
       Get.back();
       Get.snackbar('Error', resData['errors'].values.toList().first,
           snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white, duration: const Duration(milliseconds: 900));
       return null;
     }
     else{
       Get.back();
       Get.snackbar('Error', 'Video could not be played or does not exist.',
           snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
       return null;
     }
   }catch(e){
     Get.back();
     Get.snackbar('Error', 'Something went wrong', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
     print('error in playing mission $e');
   }
 }
}