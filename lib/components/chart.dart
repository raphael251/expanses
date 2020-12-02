import 'package:flutter/material.dart';
import './chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (var i = 0; i < this.recentTransactions.length; i++) {
        bool sameDay = this.recentTransactions[i].date.day == weekDay.day;
        bool sameMonth = this.recentTransactions[i].date.month == weekDay.month;
        bool sameYear = this.recentTransactions[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += this.recentTransactions[i].value;
        }
      }

      print({
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      });

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) => sum + tr['value']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((transaction) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                day: transaction['day'],
                percentage: (transaction['value'] as double) / _weekTotalValue,
                value: transaction['value'],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
