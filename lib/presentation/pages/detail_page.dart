import 'package:cached_network_image/cached_network_image.dart';
import '../../common/state_enum.dart';
import '../../data/models/data_model.dart';
import '../../presentation/pages/add_page.dart';
import '../../presentation/provider/detail_page_notifier.dart';
import '../../presentation/provider/home_page_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';

class DetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-page';

  final DataItem data;

  DetailPage({required this.data});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<HomePageNotifier>(context, listen: false)
        .fetchDataUsers(false));
    Future.microtask(() =>
        Provider.of<DetailPageNotifier>(context, listen: false)
            .fetchDataById(widget.data.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DetailContent(
          widget.data,
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final DataItem dataItem;

  DetailContent(
    this.dataItem,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Consumer<DetailPageNotifier>(
        builder: (contextIn, data, child) {
          if (data.state == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.state == RequestState.Loaded) {
            return Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: '${data.data.picture}',
                  width: screenWidth,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 48 + 8),
                  child: DraggableScrollableSheet(
                    builder: (contextIn, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: kRichBlack,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 16,
                          right: 16,
                        ),
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.data.title.toUpperCase(),
                                      style: kHeading5,
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pushNamed(
                                              context,
                                              AddPage.ROUTE_NAME,
                                              arguments: [data.data, "Edit"],
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.edit),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        ElevatedButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext ctx) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Delete this data'),
                                                    content: const Text(
                                                        'Are you sure to delete this data?'),
                                                    actions: [
                                                      // The "Yes" button
                                                      TextButton(
                                                          onPressed: () async {

                                                            Navigator.of(context).pop();

                                                            await Provider.of<
                                                                        DetailPageNotifier>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .remove(
                                                                    data.data);

                                                            final message =
                                                                Provider.of<DetailPageNotifier>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .message;

                                                            if (message ==
                                                                DetailPageNotifier
                                                                    .successMessage) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                          content:
                                                                              Text(message)));

                                                              await Provider.of<
                                                                          HomePageNotifier>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .fetchDataUsers(
                                                                      true);

                                                              Navigator.pop(
                                                                  context);
                                                            } else {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      content: Text(
                                                                          message),
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Yes')),
                                                      TextButton(
                                                          onPressed: () {
                                                            // Close the dialog
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('No'))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.delete),
                                              Text('Delete'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Full Name',
                                      style: kHeading6,
                                    ),
                                    Text(
                                      '${data.data.firstName} ${data.data.lastName}',
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Recommendations',
                                      style: kHeading6,
                                    ),
                                    Consumer<HomePageNotifier>(
                                      builder: (context, data, child) {
                                        if (data.state ==
                                            RequestState.Loading) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (data.state ==
                                            RequestState.Error) {
                                          return Text(data.message);
                                        } else if (data.state ==
                                            RequestState.Loaded) {
                                          return Container(
                                            height: 150,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                final movie = data.users[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator
                                                          .pushReplacementNamed(
                                                        context,
                                                        DetailPage.ROUTE_NAME,
                                                        arguments: movie,
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(8),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            '${movie.picture}',
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: data.users.length,
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                color: Colors.white,
                                height: 4,
                                width: 48,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    // initialChildSize: 0.5,
                    minChildSize: 0.25,
                    // maxChildSize: 1.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: kRichBlack,
                    foregroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            );
          } else {
            return Center(
              key: Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }
}
