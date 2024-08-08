import 'package:budget_app_starting/components.dart';
import 'package:flutter/material.dart';
import 'package:budget_app_starting/view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

bool isLoading = true;

class ExpenseViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      viewModelProvider.expensesStream();
      viewModelProvider.incomeStream();
      isLoading = false;
    }

    int totalExpense = 0;
    int totalIncome = 0;

    void calculate() {
      viewModelProvider.expensesAmount
          .forEach((item) => totalExpense += int.parse(item));
      viewModelProvider.incomesAmount
          .forEach((item) => totalIncome += int.parse(item));
    }

    calculate();
    int budgetLeft = totalIncome - totalExpense;

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrawerHeader(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 180.0,
                    backgroundColor: Colors.white,
                    child: Image(
                      image: AssetImage('logo.png'),
                      filterQuality: FilterQuality.high,
                      height: 100.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              MaterialButton(
                onPressed: () async {
                  await viewModelProvider.logout();
                },
                elevation: 20.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                ),
                height: 50.0,
                minWidth: 200.0,
                color: Colors.black,
                child: OpenSans(
                  text: "Logout",
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async =>
                        await launchUrlString('https://www.instagram.com/'),
                    icon: SvgPicture.asset(
                      'instagram.svg',
                      colorFilter:
                          ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      width: 35.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () async =>
                        await launchUrlString('https://www.twitter.com/'),
                    icon: SvgPicture.asset(
                      'twitter.svg',
                      colorFilter:
                          ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      width: 35.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 35.0,
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Poppins(
            text: "Dashboard",
            size: 30.0,
            color: Colors.white,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await viewModelProvider.reset();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 50.0,
            ),
            // image + addIncome + total calculation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'login_image.png',
                  width: deviceHeight / 1.6,
                ),
                // add income & expense
                SizedBox(
                  height: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Add expense
                      SizedBox(
                        height: 45.0,
                        width: 160.0,
                        child: MaterialButton(
                          onPressed: () async {
                            await viewModelProvider.addExpense(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              OpenSans(
                                text: "Add expense",
                                size: 17.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          splashColor: Colors.grey,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      // Add income
                      SizedBox(
                        height: 45.0,
                        width: 160.0,
                        child: MaterialButton(
                          onPressed: () async {
                            await viewModelProvider.addIncome(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              OpenSans(
                                text: "Add income",
                                size: 17.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          splashColor: Colors.grey,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 30.0,
                ),
                // Total calculation
                Container(
                  height: 300.0,
                  width: 280.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                            text: "Budget left",
                            size: 17.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: "Total expense",
                            size: 17.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: "Total income",
                            size: 17.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Divider(
                          indent: 40.0,
                          endIndent: 40.0,
                          color: Colors.grey,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                            text: budgetLeft.toString(),
                            size: 17.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: totalExpense.toString(),
                            size: 17.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: totalIncome.toString(),
                            size: 17.0,
                            color: Colors.white,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Divider(
              indent: deviceWidth / 4,
              endIndent: deviceWidth / 4,
              thickness: 3.0,
            ),
            SizedBox(
              height: 50.0,
            ),
            // Expense + Incomes List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Expense list
                Container(
                  height: 320.0,
                  width: 260.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Expense heading
                      Center(
                        child: Poppins(
                          text: "Expenses",
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      Divider(
                        indent: 30.0,
                        endIndent: 30.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 210.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          border: Border.all(
                            width: 1.0,
                            color: Colors.white,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: viewModelProvider.expensesAmount.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Poppins(
                                  text: viewModelProvider.expensesName[index],
                                  size: 15.0,
                                  color: Colors.white,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Poppins(
                                    text:
                                        viewModelProvider.expensesAmount[index],
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                // Income list
                Container(
                  height: 320.0,
                  width: 260.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Income heading
                      Center(
                        child: Poppins(
                          text: "Incomes",
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      Divider(
                        indent: 30.0,
                        endIndent: 30.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 210.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          border: Border.all(
                            width: 1.0,
                            color: Colors.white,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: viewModelProvider.incomesAmount.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Poppins(
                                  text: viewModelProvider.incomesName[index],
                                  size: 15.0,
                                  color: Colors.white,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Poppins(
                                    text:
                                        viewModelProvider.incomesAmount[index],
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
