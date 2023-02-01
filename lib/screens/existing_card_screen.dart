import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '../services/payment-service.dart';

class ExistingCardScreen extends StatefulWidget {
  const ExistingCardScreen({Key? key}) : super(key: key);

  @override
  State<ExistingCardScreen> createState() => _ExistingCardScreenState();
}

class _ExistingCardScreenState extends State<ExistingCardScreen> {

  List cards = [
    {
     'cardNumber': '5502098032580140',
     'expiryDate': '10/2027',
     'cardHolderName': 'Reginaldo Junior',
     'cvvCode': '391',
     'showBackView': false
    },
    {
      'cardNumber': '5555555555554444',
      'expiryDate': '04/2023',
      'cardHolderName': 'Tracer',
      'cvvCode': '123',
      'showBackView': false
    },
  ];

  payViaExistingCard(BuildContext context, card)async{
    var expiryArr = card['expiryDate'].split('/');
    CreditCard strippedCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );

    var response = await StripeService.payViaExistingCard(currency: 'BRL',amount:'130',card: strippedCard);
    if(response.sucess == true){
      print(response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha cartão existente'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (BuildContext context, int index){
              var card = cards[index];
              return InkWell(
                onTap: ()=>payViaExistingCard(context, card),
                child: CreditCardWidget(
                  onCreditCardWidgetChange: (value){},
                  cardNumber: card['cardNumber'],
                  expiryDate: card['expiryDate'],
                  cardHolderName: card['cardHolderName'],
                  cvvCode: card['cvvCode'],
                  showBackView: false,
                ),
              );
            }
        ),
      ),
    );
  }
}
