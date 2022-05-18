import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/widgets/chart_bars.dart';

///* We will build Chart for our app.

class Charts extends StatelessWidget {
  //* And we will store our recent activities in this list.
  final List<Transaction> recentTransactions;
  const Charts({Key? key, required this.recentTransactions}) : super(key: key);

  //? We will set getter to crate generator for weekday labels.

  List<Map<String, Object>> get transactionValues {
    //* With the help of this method we will create a list of weekdays.
    //? We added to our map a key 'day' and value 'amount'.
    //? So on the chart we will see the day and amount.
    //? And with the .substractDays(Duration(days:index)) we will substract [index] day from the current day.
    //? So basicly when list generating subtract method will pass index.
    //? And when it pass zero it means that we will get the current day.
    //? And when it pass one it means that we will get the day before current day so yesterday etc.

    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));

      //* We added variable 'totalAmount' to store the total amount of transactions for each day.

      double totalSum = 0.0;
      //* And here we will loop through our recent transactions.
      //* And we will check if the transaction date is equal to the weekday.
      //* And if it is equal we will add the transaction amount to the total amount.
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day':
            //? With this format we only get 3 letters of the day.
            DateFormat.E().format(weekday).substring(0, 3),
        // .substrings is a method that returns a substring of the given string.
        'amount': totalSum,
      };
    });
  }

  double get totalSpending {
    //* We will loop through our recent transactions.
    //* In this getter we are using fold method. That is similar to reduce method.
    //* But it will return a single value.
    //* We passing starting point as 0.0 and we are passing a function that will add the amount of the transaction to the total amount.
    return transactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    // IT WAS FOR DEBUG
    // print(transactionValues);
    return SizedBox(
      height: MediaQuery.of(context).size.height /4.5,
      child: Card(
        color: Colors.orange[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: transactionValues
              .map(
                // We are passing our ChartBar widget to the map function.
                (obj) => Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                      day: obj['day'] as String,
                      spendingAmount: obj['amount'] as double,
                      //* When we get the total spending we are dividing it by the total spending.
                      //* If we don't control the total spending we will get a division by zero error.
                      percentageOfTotal: totalSpending == 0.0
                          ? 0.0
                          : (obj['amount'] as double) / totalSpending),
                ),
              )
              .toList().reversed.toList(),
        ),
      ),
    );
  }
}
