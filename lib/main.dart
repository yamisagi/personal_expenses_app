import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/charts.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import './widgets/transactions_list.dart';
import 'models/transaction.dart';

void main() => runApp(const PersonalExpenses());

//* IMPORTANT: We are using two classes here.
//* PersonalExpenses is the main class.
//* HomeScreen is the secondary class that holds our data.
//* If we don't pass context to the constructor of PersonalExpenses class,
//* It will throw an error about MediaQuery not found * There is no Scaffold, or CupeApp etc..
//* Because we used in _startAddNewTransaction showModalSheet method and it has its own context.
//* And when we use showModalSheet method, it will create a new context for us.
//* So after we use showModalSheet method, we get a new context and Flutter lost its Scaffold context data and throws error.

class PersonalExpenses extends StatelessWidget {
  const PersonalExpenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.orange[100],
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 16, fontFamily: 'Pacifico', color: Colors.black),
          headline2: TextStyle(fontSize: 14, fontFamily: 'JetBrainsMono'),
          headline3: TextStyle(
              fontSize: 18,
              fontFamily: 'Pacifico',
              fontWeight: FontWeight.w600,
              color: Colors.black),
          headline4: TextStyle(
              fontSize: 35,
              fontFamily: 'Righteous',
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
              color: Color.fromARGB(255, 144, 4, 4)),
          headline5: TextStyle(
              fontSize: 20,
              fontFamily: 'Pacifico',
              fontWeight: FontWeight.bold),
          headline6: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Righteous',
              letterSpacing: 1.5,
              color: Colors.black),
        ),
        primarySwatch: Colors.orange,
        secondaryHeaderColor: Colors.orange[700],
        cardTheme: CardTheme(
          color: Colors.orange[200],
        ),
      ),
      home: const Scaffold(body: HomeScreen()),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transaction> _transactions = [
    // Transaction(id: '000001', name: 'Shoes', amount: 9, date: DateTime.now()),
    // Transaction(
    //     id: '000002',
    //     name: 'New Headphones',
    //     amount: 250,
    //     date: DateTime.now()),
    // Transaction(
    //     id: '00003', name: 'Bills', amount: 99.99, date: DateTime.now()),
  ];

  //* 05/17/2022 - We added new parameter as date.
  /// Thats because this date passing from  [_submitData] in [NewTransaction] class.
  void _addNewTransaction(String txTitle, double txAmount, DateTime date) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      name: txTitle,
      amount: txAmount,
      date: date,
    );
    _transactions.add(newTx);
    setState(() {
      _transactions;
    });
  }

  void _startTransaction(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: ctx,
        //* In builder we pass its own context.
        //* Its not the same context in main context.
        builder: (_) {
          return GestureDetector(
              onTap: (() {}),
              behavior: HitTestBehavior.opaque,
              child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  child: NewTransaction(addTransaction: _addNewTransaction)));
        });
  }

  //? We have create a list of transactions.
  //? 05/14/2022 WE HAVE MASSICE CHANGES.
  //? WE MOVED THE userTransactions WIDGET TO main.dart.
  //? Because there is no way to access it from here.
  //? And we need setState to update the UI.

  //*  05/17/2022 - We added deleteTransaction method.
  //* Basicly we are passing the id of the transaction to delete.
  //* With removeWhere method we are looping through the list and,
  //* If the id of the transaction is equal to the id we are passing,
  //* We are removing that transaction from the list.
  void _deleteTrasaction(String id) {
    setState(() {
      _transactions.removeWhere((transactionId) => transactionId.id == id);
    });
  }

  //****************************************** *//

  //? Logic here is we are filtering the list of transactions with where method.
  //? Basicly where method is filtering recent transactions from now to seven days past.
  //? And core method is isAfter method that returns true if the date is after the given date.

  List<Transaction> get _recentTransactions => _transactions
      .where((transaction) => transaction.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7))))
      .toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _startTransaction(context);
        },
      ),
      appBar: AppBar(
        elevation: 3,
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(45))),
        centerTitle: true,
        scrolledUnderElevation: 5,
        title: Text(
          'Expenses App',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),

      ///* TIME: 05/11/2022
      ///* We now have structure about our app tree.
      ///* We have a scaffold, which is a widget that provides a
      ///* Column widget as its body.
      ///* And two widgets those hold our Chart and List of expenses.
      ///* Later we will seperate them into files.

      //? 05/13/2022
      //? We updated Body of our app with a SingleChildScrollView widget.
      //? To prevent Rendering Error [At least for now] the app from scrolling when the keyboard is open.
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //? 05/17/2022: We have added a Chart widget.

            Charts(recentTransactions: _recentTransactions),
            //* 05/12/2022 -- We will add list of transactions.
            //? Instead using Hardcoded list of transactions as Card(), we will use transactions list .map() method.
            //? Because when we do this 'dynamic' we don't know how many transactions will be added.
            //? So we will use map() method to iterate over the list of transactions.
            //* WE MOVED OUR LIST TO [transactions_list.dart]
            TransactionList(
                transactions: _transactions,
                deleteTransaction: _deleteTrasaction),
          ],
        ),
      ),
    );
  }
}
