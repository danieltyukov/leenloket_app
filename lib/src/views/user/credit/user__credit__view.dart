import 'package:Leenloket/src/models/credit_transaction_model.dart';
import 'package:Leenloket/src/views/user/home/components/side_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/views/user/reservations/user__reservations__single.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:intl/intl.dart';

class UserCreditView extends StatefulWidget {
  const UserCreditView({super.key, required this.currentUser});

  final UserModel.User currentUser;

  static const routeName = '/user/profile/credit';

  @override
  State<UserCreditView> createState() => _UserCreditView();
}

class _UserCreditView extends State<UserCreditView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit'),
      ),
      drawer: SideMenu(
        currentUser: widget.currentUser,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder(
                  future: widget.currentUser.fetchDoubleCredit(),
                  builder: (context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: Center(
                              child: Text('€ ${snapshot.data}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  )),
                            )),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              const SizedBox(height: 50),
              const Text(
                'Credit Transactions',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              FutureBuilder<List<CreditTransaction>>(
                future: widget.currentUser.fetchCreditTransactions(),
                builder:
                    (context, AsyncSnapshot<List<CreditTransaction>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print(
                        'Error fetching credit transactions: ${snapshot.error}');
                    return Text('Error fetching data ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          String date = snapshot.data![index].date;

                          return Card(
                            child: ListTile(
                              title:
                                  Text(snapshot.data![index].type.toString()),
                              trailing:
                                  Text('€ ${snapshot.data![index].amount}'),
                              subtitle: Text(
                                  '${date.substring(0, 10)} at ${date.substring(11, 16)}'),
                            ),
                          );
                        });
                  } else {
                    return const Text('No credit transactions available');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
