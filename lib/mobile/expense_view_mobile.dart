import 'package:budget_app_starting/components.dart';
import 'package:budget_app_starting/view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

bool isLoading = true;

class ExpenseViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    double deviceWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      viewModelProvider.expensesStream();
      viewModelProvider.incomeStream();
      isLoading = false;
    }

    return SafeArea(
      child: Scaffold(
        drawer: DrawerExpense(),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30.0,
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Poppins(
            text: "Dashboard",
            size: 20.0,
            color: Colors.white,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                viewModelProvider.reset();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 40.0,
            ),
            Column(
              children: [
                Container(
                  height: 240.0,
                  width: deviceWidth / 1.5,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  child: TotalCalculation(14.0),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AddExpense(),
                    SizedBox(
                      width: 10.0,
                    ),
                    AddIncome(),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expense list
                      Column(
                        children: [
                          OpenSans(
                            text: "Expenses",
                            size: 15.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(7.0),
                            height: 210.0,
                            width: 170.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              border: Border.all(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            child: ListView.builder(
                              itemCount:
                                  viewModelProvider.expensesAmount.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Poppins(
                                        text: viewModelProvider
                                            .expensesName[index],
                                        size: 12.0),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Poppins(
                                        text: viewModelProvider
                                            .expensesAmount[index],
                                        size: 12.0,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // income list
                      Column(
                        children: [
                          OpenSans(
                            text: "Incomes",
                            size: 15.0,
                            color: Colors.black,
                          ),
                          Container(
                            padding: EdgeInsets.all(7.0),
                            height: 210.0,
                            width: 170.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  15.0,
                                ),
                              ),
                            ),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Poppins(
                                        text: viewModelProvider
                                            .incomesName[index],
                                        size: 12.0),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Poppins(
                                        text: viewModelProvider
                                            .incomesAmount[index],
                                        size: 12.0,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: viewModelProvider.incomesAmount.length,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
