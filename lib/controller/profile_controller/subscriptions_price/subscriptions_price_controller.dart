import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/model/profile_model/subscriptions_price/subscriptions_price_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class SubscriptionsPriceController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  List<SubscriptionsPriceModel> plansData = [

  ];

  // List<SubscriptionsPriceModel> get getPlansData => plansData;
  Future<void> getPlans () async{
    List<SubscriptionsPriceModel> my_plans = [];
    final url = Uri.parse('${dotenv.env['db_url']}/subscriptions');
    try{
      final res = await http.get(url, headers: {
        "uid": "${_authController.getUserId()}",
        "api-key" : "${dotenv.env['api_key']}"
      });
      final resData = jsonDecode(res.body);
      if(resData['response'] == 200){
        final subs = resData['success']['data']['subscriptions'];
        if (subs.isEmpty) return;
        await subs.forEach((sub){
          my_plans.add(SubscriptionsPriceModel(
            subs_id: sub['subs_id'],
            planName: sub['title'],
            planTagLine: sub['subtitle'],
            price: sub['price'],
            duration: sub['freq'],
            haveBestValue: sub['is_best'] == true && true
          ));
        });
        plansData = my_plans;

      }else if ((resData['response'] != 200) &&
          (resData['errors'] != null)){
        Get.back();
        Get.snackbar('Error', resData['errors'].values.toList().first,
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
      }

    }catch(e){
      Get.back();
      Get.snackbar('Error', 'Something went wrong. Try later',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
      print('printing error for subscriptions $e');
    }
  }

  Future getSubById (id) async{
    final url = Uri.parse('${dotenv.env['db_url']}/subscription/$id');
    try{
      final res = await http.get(url, headers: {
        "uid": "${_authController.getUserId()}",
        "api-key" : "${dotenv.env['api_key']}"
      });
      final resData = jsonDecode(res.body);
      if(resData['response'] == 200){
        final sub = resData['success']['data'];
        if (sub.isEmpty) return;
        return sub;

      }else if ((resData['response'] != 200) &&
          (resData['errors'] != null)){
        Get.back();
        Get.snackbar('Error', resData['errors'].values.toList().first,
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
      }

    }catch(e){
      Get.back();
      Get.snackbar('Error', 'Something went wrong. Try later',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
      print('printing error for subscriptions $e');
    }
  }
  Future activateTrial (id) async{
    final url = Uri.parse('${dotenv.env['db_url']}/subscription/$id');
    try{
      final res = await http.post(url, headers: {
        "uid": "${_authController.getUserId()}",
        "api-key" : "${dotenv.env['api_key']}"
      });
      final resData = jsonDecode(res.body);
      if(resData['response'] == 200){
        return 200;

      }else if ((resData['response'] != 200) &&
          (resData['errors'] != null)){
        return 404;
      }

    }catch(e){
      print('printing error for subscriptions $e');
      return 404;
    }
  }

  Future makePayment (subId, context) async{
    final payment_dialog = ProgressDialog(context: context);
    var paymentIntentData;
    try{
      payment_dialog.show(
        max: 1,
        msg: 'Processing Payment',
        progressBgColor: Colors.transparent,
      );
      final url = Uri.parse('${dotenv.env['db_url']}/subscription/$subId/payment-info');
      final res = await http.get(url, headers: {
        "uid": "${_authController.getUserId()}",
        "api-key" : "${dotenv.env['api_key']}"
      });

      final resData =  jsonDecode(res.body);
      if(resData['response'] == 200) {
         paymentIntentData = resData['success']['data']['payment_sheet'];
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                applePay: false,
                googlePay: true,
                paymentIntentClientSecret: paymentIntentData['paymentIntent'],
                customerId: paymentIntentData['customer'],
                customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
                merchantDisplayName: 'Test merchant',
            )
        );
        payment_dialog.close();
        await Stripe.instance.presentPaymentSheet();
        payment_dialog.show(
          max: 1,
          msg: 'Confirming payment',
          progressBgColor: Colors.transparent,
        );
        final response = await http.post(Uri.parse('${dotenv.env['db_url']}/payment'), headers: {
          "uid": "${_authController.getUserId()}",
          "api-key" : "${dotenv.env['api_key']}",
          "Content-Type" : "application/json"
        }, body: json.encode({
          'paymentIntent': paymentIntentData['paymentIntent'],
          'ephemeralKey': paymentIntentData['ephemeralKey'],
          'status': "1",
        }));
        final feedback = jsonDecode(response.body);
        if(feedback['response'] == 200){
          payment_dialog.close();
          Get.snackbar('Success', 'Payment completed',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
        }
        payment_dialog.isOpen() ? payment_dialog.close() : null;

      }else if ((resData['response'] != 200) &&
          (resData['errors'] != null)){
        payment_dialog.close();
        Get.back();
        Get.snackbar('Error', resData['errors'].keys.toList().first,
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
      }
    }on StripeException catch(e){
      payment_dialog.isOpen() ? payment_dialog.close() : null;
      final failedResponse = await http.post(Uri.parse('${dotenv.env['db_url']}/payment'), headers: {
        "uid": "${_authController.getUserId()}",
        "api-key" : "${dotenv.env['api_key']}",
        "Content-Type" : "application/json"
      }, body: json.encode({
        'paymentIntent': paymentIntentData['paymentIntent'],
        'ephemeralKey': paymentIntentData['ephemeralKey'],
        'status': "-1",
      }));
      // // send api pending-0
      Get.snackbar('Error', '${e.error.message}',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    }catch (e){
      payment_dialog.isOpen() ? payment_dialog.close() : null;
      print('printing error for api $e');
      Get.snackbar('Error', 'Unable to process payment.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    }
  }

}
