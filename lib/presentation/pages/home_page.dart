import '../../presentation/pages/about_page.dart';
import '../../common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/home_page_notifier.dart';
import '../widgets/user_card_list.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<HomePageNotifier>(context, listen: false)
            .fetchDataUsers(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Gusti Ngurah Mertayasa'),
              accountEmail: Text('gusti.ngurah.mertayasa@gmail.com'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Dummyapi'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AddPage.ROUTE_NAME,
                arguments: [null,"Add"],
              );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: const Text('Delete All Data'),
                      content: const Text('Are you sure to delete all data?'),
                      actions: [
                        // The "Yes" button
                        TextButton(
                            onPressed: () async {

                              // Close the dialog
                              Navigator.of(context).pop();

                                await Provider.of<HomePageNotifier>(
                                    context,
                                    listen: false)
                                    .removeAllData();

                              final message =
                                  Provider.of<HomePageNotifier>(context,
                                      listen: false)
                                      .message;

                              if (message ==
                                  HomePageNotifier
                                      .successMessage ) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(message),
                                      );
                                    });
                              }

                            },
                            child: const Text('Yes')),
                        TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'))
                      ],
                    );
                  });
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<HomePageNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.users[index];
                  return MovieCard(movie);
                },
                itemCount: data.users.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),

      ),
    );
  }
}
