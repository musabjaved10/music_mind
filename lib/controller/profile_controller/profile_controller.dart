import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  late TextEditingController emailController_p,
      firstNameController_p,
      lastNameController_p,
      phoneController_p,
      aboutController_p,
      displayNameController_p;

  final AuthController _authController = Get.find<AuthController>();
  Map<dynamic, dynamic> userData = {};

  @override
  void onInit() {
    if(_authController.user !=null){
      getProfileData();
    }
    emailController_p = TextEditingController();
    firstNameController_p = TextEditingController();
    lastNameController_p = TextEditingController();
    phoneController_p = TextEditingController();
    aboutController_p = TextEditingController();
    displayNameController_p = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController_p.dispose();
    firstNameController_p.dispose();
    lastNameController_p.dispose();
    aboutController_p.dispose();
    displayNameController_p.dispose();
    phoneController_p.dispose();
  }

  Future getProfileData() async {
    try {
      final userId = _authController.getUserId();
      final url = Uri.parse('${dotenv.env['db_url']}/user/$userId');
      final res = await http.get(url,
          headers: {"api-key": "${dotenv.env['api_key']}", "uid": "$userId"});
      final resData = jsonDecode(res.body);
      if (resData['response'] == 200) {
        userData = {...resData['success']['data']['user']};
        emailController_p.text = userData['email'];
        firstNameController_p.text = userData['first_name'];
        lastNameController_p.text = userData['last_name'];
        phoneController_p.text = userData['phone'];
        aboutController_p.text = userData['about'];
        displayNameController_p.text = userData['display_name'];
      }
    } catch (e) {
      print('error in fetching one userrrrrr $e');
    }
  }
  Future updateProfile() async{
    final updatedUser = {
      "display_name": displayNameController_p.text,
      "first_name": firstNameController_p.text,
      "last_name": lastNameController_p.text,
      "email": emailController_p.text,
      "phone": phoneController_p.text,
      "about": aboutController_p.text,
    };
    final userId = _authController.getUserId();
    final url = Uri.parse('${dotenv.env['db_url']}/user/$userId/update');
    try{
      final res = await http.patch(url,
          headers: {"api-key": "${dotenv.env['api_key']}", "uid": "$userId", 'Content-Type': 'application/json'},
          body: jsonEncode(updatedUser)
          );
      final resData = jsonDecode(res.body);
      print(resData);
      if (resData['response'] == 200) {
        await getProfileData();
        await _authController.getUserData();
        Get.snackbar('Success','Your records has been updated.',snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
        return 200;
      }
      else if(resData['errors'] !=null){
        Get.snackbar('Error',resData['errors'].values.toList().first,snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
        return null;
      }
      else if(resData['warnings'] !=null){
        Get.snackbar('Warning',resData['warnings'].values.toList().first,snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
        return null;

      }
    } catch(e){
      Get.snackbar('Error','Update failed',snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
      print(e);
      return null;

    }
  }
  Future<bool> saveImageTOStorage(String value)async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString('${_authController.getUserId()}', value);
  }

   getImageFromStorage(String value) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final image =  preferences.getString('${_authController.getUserId()}');
    if(image == null) {
      return null;
    } else{
      return base64Decode(image);
    }
  }

  Future uploadImage () async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        Get.snackbar('','Image was not selected',snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white, duration: const Duration(seconds: 1));
        return null;
      }
      final imageTemporary = File(image.path);
      saveImageTOStorage(base64Encode(imageTemporary.readAsBytesSync()));
      return imageTemporary;
    }catch(e){
      print('Error in priting Image $e');
      return;
    }
  }




}
