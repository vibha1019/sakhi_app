import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/transaction.dart';

class IncomeExpenseChart extends StatelessWidget {
  final List<Transaction> transactions;

  const IncomeExpenseChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final Map<int, double> incomeByDay = {};
    final Map<int, double> expenseByDay = {};

    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      incomeByDay[i] = 0;
      expenseByDay[i] = 0;
    }

    for (var transaction in transactions) {
      final diff = now.difference(transaction.date).inDays;
      if (diff < 7) {
        final index = 6 - diff;
        if (transaction.type == TransactionType.income) {
          incomeByDay[index] = (incomeByDay[index] ?? 0) + transaction.amount;
        } else {
          expenseByDay[index] =
              (expenseByDay[index] ?? 0) + transaction.amount;
        }
      }
    }

    final maxY = _getMaxY(incomeByDay, expenseByDay);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last 7 Days',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < 7) {
                            final day =
                                now.subtract(Duration(days: 6 - index));
                            const dayNames = [
                              'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
                            ];
                            return Text(
                              dayNames[(day.weekday - 1) % 7],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    // ✅ safe interval — never 0
                    horizontalInterval: maxY > 0 ? maxY / 4 : 25,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: incomeByDay[index] ?? 0,
                          color: const Color(0xFF06D6A0),
                          width: 12,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: expenseByDay[index] ?? 0,
                          color: const Color(0xFFE63946),
                          width: 12,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ChartLegend(color: const Color(0xFF06D6A0), label: 'Income'),
                const SizedBox(width: 24),
                _ChartLegend(
                    color: const Color(0xFFE63946), label: 'Expense'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxY(Map<int, double> income, Map<int, double> expense) {
    double max = 0;
    income.forEach((_, value) {
      if (value > max) max = value;
    });
    expense.forEach((_, value) {
      if (value > max) max = value;
    });
    return max > 0 ? max * 1.2 : 100;
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}