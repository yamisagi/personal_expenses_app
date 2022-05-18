import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String day;
  final double spendingAmount;
  final double percentageOfTotal;

  const ChartBar(
      {Key? key,
      required this.spendingAmount,
      required this.percentageOfTotal,
      required this.day})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(day, style: Theme.of(context).textTheme.headline1),
        const SizedBox(
          height: 10,
        ),          
        SizedBox(
          height: 60,
          width: 10,
          //* With stact we will use two widgets, one for the base and one for the spending amount.
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            //* This widget will show the percentage of spending.
            //* Fractionally sizing height with our percentageOfTotal.
            FractionallySizedBox(
              heightFactor: percentageOfTotal,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 10,),
        FittedBox(          
          child: Text(
            '\$${spendingAmount.toStringAsFixed(0)}',
            style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontWeight:
                    (spendingAmount < 100.0) ? FontWeight.w300 : FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
