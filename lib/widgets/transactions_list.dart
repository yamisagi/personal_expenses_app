import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    Key? key,
    required this.transactions, required this.deleteTransaction,
  }) : super(key: key);
  final List<Transaction> transactions;
  final Function deleteTransaction;

//* We are upgrading this Widget to ListView.
//* For now we dont know how many items we'll get in our transactions list.
//* Because of it we will use ListView.builder.
//* So ListView.builder cost less memory than ListView.
//* It's only rendering the items that are visible on the screen unlike ListView widget.

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      // *  We added logic if there is no transactions, then we will show a image else we will show the list.
      child: transactions.isEmpty
          ? Column(
              children: [
                Text(
                  'Looks Like Empty! Are you broke ?',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 50),
                SizedBox(
                    height: 200,
                    child: Image.asset(
                      'assets/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            )
          : ListView.builder(
              physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                //* UPDATE: 05/17/2022 -- Instead of using cardStyle we will use ListTile widget.
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.orange[100],
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                '\$${transactions[index].amount}',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          transactions[index].name,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        subtitle: Text(
                            DateFormat('y, MMMM d - E')
                                .format(transactions[index].date),
                            style: Theme.of(context).textTheme.headline2),
                        trailing: IconButton(
                          onPressed: () {
                            //* In this method we are passing the index of the transaction id to the deleteTransaction method.
                            //* Otherwise it wont work.
                            //* So step by step: 
                            //? Our method accepts a parameter as ID.
                            //? And we are sending the current index of the transaction id to the method.
                            deleteTransaction(transactions[index].id);
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        )),
                  ),
                );
              }),
    );
  }
}

 //   @deprecated
    //  Column(
    //     children: transactions
    //         .map(
    //           //* We will upgrade this to Our Styled Transaction Card.
    //           (transaction) => Card(
    //             child: CardStyle(
    //               id: transaction.id,
    //               name: transaction.name,
    //               amount: transaction.amount,
    //               //* Later on we will use intl: ^0.17.0 package to format human readable date.
    //               //? We formatted date using intl package.
    //               date:
    //                   DateFormat('y, MMMM d, HH:mm - E').format(transaction.date),
    //             ),
    //           ),
    //         )
    //         .toList());
    //*  .toList() is used to convert the map to list. Becuse map() method returns an Iterable. And Column() widget expects a list.
   
   
    // @deprecated
    // Column(
    //               children: [
    //                 Card(
    //                   child: CardStyle(
    //                     //* We are passing the transaction objects indexes to CardStyle.
    //                     //* To know which transaction object we are passing.
    //                     id: transactions[index].id,
    //                     name: transactions[index].name,
    //                     amount: transactions[index].amount,
    //                     //* Later on we will use intl: ^0.17.0 package to format human readable date.
    //                     //? We formatted date using intl package.
    //                     date: DateFormat('y, MMMM d, HH:mm - E')
    //                         .format(transactions[index].date),
    //                   ),
    //                 ),
    //               ],
    //             );