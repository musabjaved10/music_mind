import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/controller/profile_controller/subscriptions_price/subscriptions_price_controller.dart';
import 'package:music_mind_client/view/widgets/my_app_bar.dart';
import 'package:music_mind_client/view/widgets/my_button.dart';
import 'package:music_mind_client/view/widgets/my_text.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class OrderSummary extends StatefulWidget {
  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  var _isLoading = true;
  final SubscriptionsPriceController controller = Get.put(SubscriptionsPriceController());
  final AuthController _authController = Get.find<AuthController>();
  final id = Get.arguments;
  var sub;

  @override
  void initState() {
    // Create anonymous function:
        () async {
      sub = await controller.getSubById(id[0]);
      print(sub);
      _isLoading = false;
      if(mounted){
        setState(() {
          // Update your UI with the desired changes.
          return;
        });
      }
    } ();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final trial_dialog = ProgressDialog(context: context,);
    final userData = _authController.userData;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order Summary',
      ),
      body: _isLoading
        ?const Center(child: CircularProgressIndicator(color: Colors.white),)
        :sub == null ? const Center(child: Text('Failed to load data. Please try later', style: TextStyle(color: Colors.white, fontSize: 18)),)
        :ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          ListTile(
            title: MyText(
              text: 'Detail Order',
              size: 16,
              weight: FontWeight.w700,
            ),
          ),
          ListTile(
            title: MyText(
              text: 'Plan',
              size: 14,
              color: KSecondaryColor,
              weight: FontWeight.w500,
            ),
            trailing: MyText(
              text: '${sub['subscription']['title']}',
              size: 14,
              color: KGrey2Color,
            ),
          ),
          ListTile(
            title: MyText(
              text: 'Duration',
              size: 14,
              color: KSecondaryColor,
              weight: FontWeight.w500,
            ),
            trailing: MyText(
              text: 'Until Canceled',
              size: 14,
              color: KGrey2Color,
            ),
          ),
          ListTile(
            title: MyText(
              text: 'Free Trial',
              size: 14,
              color: KSecondaryColor,
              weight: FontWeight.w500,
            ),
            trailing: MyText(
              text: '7 days',
              size: 14,
              color: KGrey2Color,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(
            color: KSecondaryColor,
            indent: 15,
            endIndent: 15,
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            title: MyText(
              text: 'Sub total',
              size: 14,
              color: KSecondaryColor,
              weight: FontWeight.w500,
            ),
            trailing: MyText(
              text: '${sub['subscription']['currency']['symbol']}${sub['subscription']['price']}',
              size: 14,
              color: KGrey2Color,
            ),
          ),
          ListTile(
            title: MyText(
              text: 'Sales Tax (9%)',
              size: 14,
              color: KSecondaryColor,
              weight: FontWeight.w500,
            ),
            trailing: MyText(
              text: '\$0.22',
              size: 14,
              color: KGrey2Color,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: MyText(
              text: 'Billed monthly',
              size: 18,
              color: KSecondaryColor,
              weight: FontWeight.w700,
            ),
            trailing: MyText(
              text: '${sub['subscription']['currency']['symbol']}${sub['subscription']['total_price']}',
              size: 18,
              weight: FontWeight.w700,
              color: KSecondaryColor,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isLoading == false ? BottomAppBar(
        elevation: 0,
        color: KPrimaryColor,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               userData['is_trial_taken'] == false && userData['is_trial_end'] == false ? MyButton(
                onPressed: () async{
                  trial_dialog.show(
                    max: 1,
                    msg: 'Activating free trial',
                    progressBgColor: Colors.transparent,
                  );
                  final tRes = await controller.activateTrial(id[0]);
                  if(tRes == 200){
                    trial_dialog.close();
                    Get.back();
                    Get.snackbar('Trial activated Successfully', 'Enjoy your free trial',
                        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
                  }else{
                    trial_dialog.close();
                    Get.snackbar('Error', 'Unable to activate your trial',
                        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
                  }
                },
                text: 'Activate Free Trial',
                btnBgColor: KSecondaryColor,
              ):userData['is_fee_paid'] == true ?
               MyButton(
                 onPressed: (){},
                 text: 'Fee has been paid.',
                 btnBgColor: KSecondaryColor,
               ):
               userData['is_trial_end'] == true ? MyButton(
                onPressed: () async{
                  final pay_res = await controller.makePayment(id[0], context);
                },
                text: 'Pay now',
                btnBgColor: KSecondaryColor,
              ):
               MyButton(
                 onPressed: (){},
                 text: 'You\'re currently having free trial',
                 btnBgColor: KSecondaryColor,
               ),
            ],
          ),
        ),
      ): null,
    );
  }
}
