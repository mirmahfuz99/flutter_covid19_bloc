import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:pie_chart/pie_chart.dart';

class Utils {
  static NumberFormat _numberFormatter;
  static DateFormat _dateFormatter;

  static NumberFormat get numberFormatter {
    if (_numberFormatter != null) {
      return _numberFormatter;
    }
    _numberFormatter = NumberFormat();
    return _numberFormatter;
  }

  static DateFormat get dateFormatter {
    if (_dateFormatter != null) {
      return _dateFormatter;
    }
    _dateFormatter = DateFormat('d MMM, HH:mm');

    return _dateFormatter;
  }


  getChart(var data, var color, context) {
    return PieChart(
      dataMap: data,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32.0,
      chartRadius: MediaQuery.of(context).size.width / 2.5,
      showChartValuesInPercentage: false,
      showChartValues: true,
      showChartValuesOutside: false,
      chartValueBackgroundColor: Colors.transparent,
      colorList: color,
      showLegends: true,
      legendPosition: LegendPosition.right,
      decimalPlaces: 0,
      showChartValueLabel: true,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
          color:Colors.white
      ),
    );
  }
}
