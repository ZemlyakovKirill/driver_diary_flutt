import 'package:driver_diary/models/type_cost_model.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class TypeCostChart extends StatefulWidget {
  TypeCostChart({Key? key, required this.costs}) : super(key: key);
  List<TypeCost> costs;

  @override
  State<TypeCostChart> createState() => _TypeCostChartState();
}

class _TypeCostChartState extends State<TypeCostChart> {
  late Map<String, double> dataMap;

  @override
  void initState() {
    dataMap = Map.fromIterable(widget.costs,
        key: (e) => e.textType, value: (e) => e.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PieChart(
            animationDuration: Duration(milliseconds: 500),
            chartType: ChartType.ring,
            colorList: widget.costs.map((e) => e.typeColor).toList(),
            chartRadius: MediaQuery.of(context).size.width * 0.33,
            chartValuesOptions: ChartValuesOptions(
              showChartValues: false,
            ),
            legendOptions: LegendOptions(
                showLegends: false,
                legendPosition: LegendPosition.bottom,
                legendShape: BoxShape.circle,
                showLegendsInRow: true),
            dataMap: dataMap),
        Padding(
          padding: const EdgeInsets.only(top:10),
          child: Wrap(
            direction: Axis.horizontal,
              runSpacing: 5,
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: widget.costs
                  .map((e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: BoxDecoration(
                            color: e.typeColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e.textType,
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w600,
                                fontSize: 14
                            ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:10.0),
                              child: Text("${e.value} P",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList()),
        )
      ],
    );
  }
}
