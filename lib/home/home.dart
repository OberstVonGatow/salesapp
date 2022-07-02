import 'package:salesapp/services/firestore.dart';
import 'package:salesapp/services/models.dart';

import '../login/login.dart';
import '../services/auth.dart';
import '../shared/error.dart';
import '../shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:salesapp/services/provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: ErrorMessage(),
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Kundenaufträge'), actions: [
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: _syncCustomers,
              ),
            ]),
            body: StreamBuilder<List<Order>>(
                stream: FirestoreService().streamOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingScreen();
                  }
                  if (!snapshot.hasData) {
                    return const Text('No Data');
                  }

                  return ListView.builder(
                      // itemExtent: 80,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: ListTile(
                            leading: Text(snapshot.data![index].orderNr),
                            title: Text(snapshot.data![index].customer!.name1 +
                                ' ' +
                                snapshot.data![index].text),
                            trailing: Text(snapshot.data![index].amountGross
                                    .toStringAsFixed(2) +
                                ' €'),
                            onTap: () {
                              context.read<CurrentOrder>().order =
                                  snapshot.data![index];
                              Navigator.pushNamed(context, '/order');
                            },
                          ),
                        );
                      });
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<CurrentOrder>().newOrder();
                Navigator.pushNamed(context, '/order');
              },
              // backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  _syncCustomers() {
    // Collmex().syncCustomers();
    FirestoreService().selectCustomers();
  }
}
