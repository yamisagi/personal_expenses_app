// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//* We have changed this class to StatefulWidget.
//* Becasuse in Stateful Widget data won't lost when we change the screen.

class NewTransaction extends StatefulWidget {
  ///? We created properties for title and amount to save values.
  ///? We will use these in TextFields.
  ///? When we create a new transaction, we will be passed these values from the _addNewTransaction() method in [user_transactions].

  final Function addTransaction;

  const NewTransaction({required this.addTransaction});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  // Insted of using addTransaction function every time seperately, we can use this method everywhere we needed.
  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    String title = _titleController.text;
    double amount = double.parse(_amountController.text);

    //* We are controlling the data with if control.
    //* If title is not empty and amount is equal or bigger than zero we will add new transaction.

    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      //* 05/17/2022 - We added _selectedDate == null condition.
      //? With empty return ,
      //? Code below [addTransaction] will not be executed.
      //* Basicly it is a break.
      return;
    }
    //? Important case is tecnically when we have StatefulWidget we have two seperated classes.
    //? One is StatefulWidget and other is State.
    //? StatefulWidget is the class that is responsible for the UI.
    //? State is the class that is responsible for the logic.
    //? And above we have function that belows StatefulWidget class,
    //? Flutter gives us a way to pass data from StatefulWidget to State class.
    //? With [widget.*] we can pass data from StatefulWidget to State class.
    widget.addTransaction(
      title,
      amount,
      //* 05/17/2022 - We added _selectedDate to pass SelectedDate to main.dart.
      _selectedDate,
    );
    //? We are using [Navigator.of(context).pop()] to close the modal bottom sheet.
    Navigator.of(context).pop();
  }

  //* We will create DatePicker method.
  //? This method is calling showDatePicker() method,
  //? It has parameters that we set:  context, initial date as now and first date as current and last date as current time.
  //? And with .then() method we are passing a function that will be called when the user select a date.
  //! It is Future Method.
  //? And then we are calling setState method to assign 'date' and to update our UI.
  void _datePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        _selectedDate = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        // color: Colors.transparent,
        width: 300,
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              onSubmitted: (_) => _submitData,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  //* This floatingLabelBehavior is used to make the label empty when the TextField is focused.
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.all(5),
                  label: Center(
                    child: Text(
                      'Title',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
              //* We are controlling our titleController.
              //* It is holding value of title.
              controller: _titleController,
            ),
            TextField(
              onSubmitted: (_) => _submitData,
              //? We are currently just accepting numbers.
              //? So we are using keyboardType: TextInputType.number.
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none,
                  label: Center(
                    child: Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  )),
              //* We are controlling our amountController.
              //* It is holding value of amount.
              controller: _amountController,
            ),
            // This Row Widget For DatePicker.

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //? We are using [Text] widget to display the date.
                //? And we set the logic of date to _datePicker() method.
                //? And used ternary to control if _selectedDate is null displaying error but if not we are using package to show date in human readable format.
                Text(
                  _selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Day is : ${DateFormat.yMd().format(_selectedDate!)}',
                  style: Theme.of(context).textTheme.headline3,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange[200])),
                    onPressed: () {
                      _datePicker();
                    },
                    child: const Text('Choose Date',
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
              ],
            )
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      //? We wrap our button and GestureDetector items here.
      //? And added some styling to the button.
      //?
      Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  blurRadius: 20,
                  blurStyle: BlurStyle.outer,
                  color: Colors.black,
                  offset: Offset(0, 1))
            ],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: IconButton(
              enableFeedback: false,
              color: Colors.white,
              splashColor: Colors.redAccent,
              onPressed: _submitData,
              //* We are calling the [submitData] here to pass our controlled data to main.dart file.
              //* And there our data passing through [addTransaction] function.
              //? We have to prevent any empty data.
              //* And returnin new [Transaction] object to list of transactions.
              icon: const Icon(
                Icons.add,
              )),
        ),
      )
    ]);
  }
}
