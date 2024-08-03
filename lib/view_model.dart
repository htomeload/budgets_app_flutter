import 'package:budget_app_starting/components.dart';
import 'package:budget_app_starting/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  bool isSignedIn = false;
  bool isObscure = true;
  var logger = Logger();

  List expensesName = [];
  List expensesAmount = [];
  List incomesName = [];
  List incomesAmount = [];

  //Check if Signed In
  Future<void> isLoggedIn() async {
    await _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isSignedIn = false;
      } else {
        isSignedIn = true;
      }
    });
    notifyListeners();
  }

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        logger.d("Registration successful");
      },
    ).onError(
      (error, stackTrace) {
        logger.d("Registration error $error");
        DialogBox(context,
            error.toString().replaceAll(RegExp('\\[.*?\\]'), '').trim());
      },
    );
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        logger.d("Login successful");
      },
    ).onError(
      (error, stackTrace) {
        logger.d("Login error $error");
        DialogBox(context,
            error.toString().replaceAll(RegExp('\\[.*?\\]'), '').trim());
      },
    );
  }

  Future<void> signInWithGoogleWeb(BuildContext context) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    await _auth.signInWithPopup(googleAuthProvider).onError(
          (error, stackTrace) => DialogBox(context,
              error.toString().replaceAll(RegExp('\\[.*?\\]'), '').trim()),
        );
    logger
        .d("Current user iss not empty = ${_auth.currentUser!.uid.isNotEmpty}");
  }

  Future<void> signInWithGoogleMobile(BuildContext context) async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().onError(
              (error, stackTrace) => DialogBox(context,
                  error.toString().replaceAll(RegExp('\\[.*?\\]'), '').trim()),
            );
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    await _auth
        .signInWithCredential(credential)
        .then((value) => logger.d("Google sign-in successful"))
        .onError(
      (error, stackTrace) {
        logger.d("Google sign-in error $error");
        DialogBox(context,
            error.toString().replaceAll(RegExp('\\[.*?\\]'), '').trim());
      },
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future addExpense(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(
          32.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                  text: "Name",
                  containerWidth: 130.0,
                  hintText: "Name",
                  controller: controllerName,
                  validator: (text) {
                    if (text.toString().isEmpty) {
                      return "Required";
                    }
                  }),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                  text: "Amount",
                  containerWidth: 100.0,
                  hintText: "Amount",
                  controller: controllerAmount,
                  validator: (text) {
                    if (text.toString().isEmpty) {
                      return "Required";
                    }
                  })
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await userCollection
                    .doc(_auth.currentUser!.uid)
                    .collection(CurrentUserCollections.Expenses)
                    .add({
                  "name": controllerName.text,
                  "amount": controllerAmount.text,
                }).onError((error, stackTrace) {
                  logger.d("add expense error $error");
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
            child: OpenSans(text: "Save", size: 15.0, color: Colors.white),
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ],
      ),
    );
  }

  Future addIncome(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          side: BorderSide(
            width: 1.0,
            color: Colors.black,
          ),
        ),
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                text: "Name",
                containerWidth: 130.0,
                hintText: "Name",
                controller: controllerName,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return "Required";
                  }
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                text: "Amount",
                containerWidth: 100.0,
                hintText: "Amount",
                controller: controllerAmount,
                digitsOnly: true,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return "Required";
                  }
                },
              )
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await userCollection
                    .doc(_auth.currentUser!.uid)
                    .collection(CurrentUserCollections.Incomes)
                    .add({
                      "name": controllerName.text,
                      "amount": controllerAmount.text
                    })
                    .then((value) => logger.d("Income added"))
                    .onError((error, stackTrace) {
                      logger.d("add income error $error");
                      return DialogBox(context, error.toString());
                    });
                Navigator.pop(context);
              }
            },
            child: OpenSans(
              text: "Save",
              size: 15.0,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.black,
            splashColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  void expensesStream() async {
    await for (var snapshot in userCollection
        .doc(_auth.currentUser!.uid)
        .collection(CurrentUserCollections.Expenses)
        .snapshots()) {
      expensesAmount = [];
      expensesName = [];

      for (var expense in snapshot.docs) {
        expensesName.add(expense.data()['name']);
        expensesAmount.add(expense.data()['amount']);
        notifyListeners();
      }
    }
  }

  void incomeStream() async {
    await for (var snapshot in userCollection
        .doc(_auth.currentUser!.uid)
        .collection(CurrentUserCollections.Incomes)
        .snapshots()) {
      incomesAmount = [];
      incomesName = [];

      for (var income in snapshot.docs) {
        incomesAmount.add(income.data()['amount']);
        incomesName.add(income.data()['name']);
        notifyListeners();
      }
    }
  }
}
