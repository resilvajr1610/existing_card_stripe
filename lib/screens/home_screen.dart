import 'package:existing_card_stripe/services/payment-service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  onItemPress(BuildContext context, int index) async {
      switch(index){
        case 0:
          var response = await StripeService.payWithNewCard(currency: 'BRL',amount:'150');
          print(response.message);
          break;
        case 1:
          Navigator.popAndPushNamed(context, '/existing_cards');
          break;
      }
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Stripe'),),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
          itemCount: 2,
          separatorBuilder: (context,index)=> Divider(),
          itemBuilder: (context,index){
              Icon? icon;
              Text? text;
              switch(index){
                case 0:
                  icon = Icon(Icons.add_circle,color: theme.primaryColor);
                  text = Text('Pay new card');
                  break;
                case 1:
                  icon = Icon(Icons.credit_card,color: theme.primaryColor);
                  text = Text('Pay via existing card');
                  break;
              }
              return InkWell(
                child: ListTile(
                  title: text,
                  leading: icon,
                  onTap: (){
                    onItemPress(context,index);
                  },
                ),
              );
          },
        ),
      ),
    );
  }
}
