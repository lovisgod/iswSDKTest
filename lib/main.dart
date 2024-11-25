import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:isw_mobile_sdk/isw_mobile_sdk.dart';
import 'package:isw_mobile_sdk/models/isw_mobile_sdk_payment_info.dart';
import 'package:isw_mobile_sdk/models/isw_mobile_sdk_sdk_config.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _amountString = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      // var credential = Config.devConfig;
      var config = IswSdkConfig(
          "IKIA3B827951EA3EC2E193C51DA1D22988F055FD27DE",
          "ajkdpGiF6PHVrwK",
          "MX21696",
          "4177785"
      );

      // initialize the sdk
      await IswMobileSdk.initialize(config, Environment.TEST);
      // intialize with environment, default is Environment.TEST
      // IswMobileSdk.initialize(config, Environment.SANDBOX);
    } on PlatformException {
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {});
  }

  Future<void> pay(BuildContext context) async {
    // save form
    _formKey.currentState?.save();

    String customerId = "rererdsdrwewds",
        customerName = "Ayooluwa Olosunde",
        customerEmail = "ayooluwa.olosunde@gmail.com",
        customerMobile = "08165656988",
    // generate a unique random
    // reference for each transaction
        reference = "rererdsdrwewdsfk";

    int amount;
    // initialize amount
    if (_amountString.isEmpty) {
      amount = 2500 * 100;
    } else {
      amount = int.parse(_amountString) * 100;
    }

    // create payment info
    IswPaymentInfo iswPaymentInfo = IswPaymentInfo(
        customerId,
        customerName,
        customerEmail,
        customerMobile,
        reference,
        amount
    );

    print(iswPaymentInfo);

    // trigger payment
    var result = await IswMobileSdk.pay(iswPaymentInfo);

    var message;
    if (result.hasValue) {
      final paymentChannel = result.value?.channel.toString() ?? "Unknown";
      message = "You completed txn using: $paymentChannel";
    } else {
      message = "You cancelled the transaction pls try again";
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Charity Fortune'),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    onSaved: (String? val) => _amountString = val ?? "0",
                  ),
                  Builder(
                    builder: (ctx) => Container(
                      width: MediaQuery.of(ctx).size.width,
                      child: ElevatedButton(
                        onPressed: () => pay(ctx),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0,
                                vertical: 20.0
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            backgroundColor: Colors.black
                        ),
                        child: const Text(
                          "Pay",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}