import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:water_alarm/domain/model/consumption_water.dart';
import 'package:water_alarm/domain/repository/person_repository.dart';
import 'package:water_alarm/resources/app_symbols.dart';

class PastConsumption extends StatefulWidget {
  const PastConsumption({super.key});

  @override
  State<PastConsumption> createState() => _PastConsumptionState();
}

class _PastConsumptionState extends State<PastConsumption> {
  final PersonRepository _personRepository = PersonRepository();
  List<Consumption>? consumptions;
  String? selectedDate;
  @override
  void initState() {
    getLastTodayConsumption();
    super.initState();
  }

  getLastTodayConsumption() async {
    setState(() {
      consumptions = null;
    });
    var resultSet = await _personRepository.getTodayConsumption();
    if (mounted) {
      setState(() {
        consumptions = convertQueryResultSet(resultSet);
      });
    }
  }

  getWeeklyConsumption() async {
    setState(() {
      consumptions = null;
    });
    var resultSet = await _personRepository.getWeeklyConsumption();
    if (mounted) {
      setState(() {
        consumptions = convertQueryResultSet(resultSet);
      });
    }
  }

  getMonthlyConsumption() async {
    setState(() {
      consumptions = null;
    });
    var resultSet = await _personRepository.getMonthlyConsumption();
    if (mounted) {
      setState(() {
        consumptions = convertQueryResultSet(resultSet);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            title: Text(selectedDate ?? "Past Consumption",
                style: Theme.of(context).textTheme.headline6),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black87,
                )),
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                              color: Theme.of(context).primaryColor,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      getLastTodayConsumption();
                                      setState(() {
                                        selectedDate = "Today";
                                      });
                                      Navigator.pop(context);
                                    },
                                    title: const Text(
                                      "Today",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      getWeeklyConsumption();
                                      setState(() {
                                        selectedDate = "Last Week";
                                      });
                                      Navigator.pop(context);
                                    },
                                    title: const Text(
                                      "Weekly",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      getMonthlyConsumption();
                                      setState(() {
                                        selectedDate = "Last Month";
                                      });
                                      Navigator.pop(context);
                                    },
                                    title: const Text(
                                      "Monthly",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                  },
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.black,
                  ))
            ]),
        body: (consumptions != null)
            ? Center(
                child: consumptions!.isNotEmpty
                    ? ListView.builder(
                        itemCount: consumptions?.length ?? 0,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "${index + 1}.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                                  Expanded(
                                    child: choseIcon(int.parse(
                                        consumptions![index]
                                            .amount
                                            .ceil()
                                            .toString())),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "${consumptions![index].amount} ml",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      DateFormat("dd-MM-yyyy hh:mm").format(
                                          DateTime.parse(
                                              consumptions![index].date)),
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: Text("There is no consumption yet..",
                            style: TextStyle(color: Colors.black54)),
                      ))
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget choseIcon(int amount) {
    switch (amount) {
      case 180:
        {
          return Icon(AppSymbols.coffee_cup,
              color: Theme.of(context).primaryColor);
        }
      case 250:
        {
          return Icon(AppSymbols.water_glass,
              color: Theme.of(context).primaryColor);
        }
      case 500:
        {
          return Icon(AppSymbols.water, color: Theme.of(context).primaryColor);
        }
      case 750:
        {
          return Icon(AppSymbols.jug, color: Theme.of(context).primaryColor);
        }
      default:
        {
          return Icon(Icons.arrow_upward,
              color: Theme.of(context).primaryColor);
        }
    }
  }
}
