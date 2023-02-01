import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool sucess;
  StripeTransactionResponse({required this.message,required this.sucess});
}

class StripeService{
  static String apiBase = 'https://api.stripe.com/v1';
  static String secret = '';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static Map<String,String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type' : 'application/x-www-form-urlencoded'
  };

  static init(){
    StripePayment.setOptions(
      StripeOptions(
          publishableKey: '',
          merchantId: "Test",
          androidPayMode: 'test'
      )
    );
  }
  static Future <StripeTransactionResponse> payViaExistingCard({required String amount,required String currency,required CreditCard card})async {

    try{
      print('parte 1');
      var paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card)
      );
      print('parte 2');
      var paymentItemt = await StripeService.createPaymentIntent(
          amount,
          currency
      );
      print('parte 3');
      print('paymentItemt');
      print(paymentItemt);
      print('paymentItemt![client_secret]');
      print(paymentItemt!['client_secret']);
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentItemt!['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      print('parte 4');
      if(response.status == 'succeeded'){
        print('parte 5');
        return new StripeTransactionResponse(
            message: 'sucessful',
            sucess: true
        );
      }else{
        print('parte 6');
        return new StripeTransactionResponse(
            message: 'failed',
            sucess: false
        );
      }
    }on PlatformException catch(e) {
      return StripeService.getPlatformExceptionErrorResult(e);
    }catch(e){
      return new StripeTransactionResponse(
          message: 'Failed : ${e.toString()}',
          sucess: true
      );
    }
  }
  static Future <StripeTransactionResponse> payWithNewCard({required String amount,required String currency}) async {

    try{
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );
      var paymentItemt = await StripeService.createPaymentIntent(
        amount,
        currency
      );
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentItemt!['client_secret'],
          paymentMethodId: paymentMethod.id
        )
      );

      if(response.status == 'succeeded'){
        return new StripeTransactionResponse(
            message: 'sucessful',
            sucess: true
        );
      }else{
        return new StripeTransactionResponse(
            message: 'failed',
            sucess: false
        );
      }
    }on PlatformException catch(e) {
      return StripeService.getPlatformExceptionErrorResult(e);
    }catch(e){
      return new StripeTransactionResponse(
          message: 'Failed : ${e.toString()}',
          sucess: true
      );
    }
  }

  static getPlatformExceptionErrorResult(e){
    String message = 'Something went wrong';
    if(e.code == 'cancelled'){
      message = 'Transação cancelada';
    }
    return new StripeTransactionResponse(
        message: message,
        sucess: false
    );
  }

  static Future <Map<String,dynamic>?> createPaymentIntent(String amount, String currency) async {
      try{
        Map<String,dynamic> body ={
          'amount':amount,
          'currency':currency,
          'payment_method_types[]':'card'
        };
        var response = await http.post(
          StripeService.paymentApiUrl,
          body:body,
          headers: StripeService.headers
        );
        return jsonDecode(response.body);
      }catch(e){
        print('erro charing ${e.toString()}');
      }
      return null;
  }
}