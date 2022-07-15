import '../../data/models/data_model.dart';
import '../../presentation/provider/add_page_notifier.dart';
import '../../presentation/provider/detail_page_notifier.dart';
import '../../presentation/provider/home_page_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../common/constants.dart';

class AddPage extends StatefulWidget {
  static const ROUTE_NAME = '/add-page';

  final DataItem? data;
  final String title;

  AddPage({this.data, required this.title});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AddContent(widget.data, widget.title),
      ),
    );
  }
}

class AddContent extends StatelessWidget {
  final DataItem? data;
  final String title;
  final _formKey = GlobalKey<FormState>();

  AddContent(this.data, this.title);

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _firstNameController = TextEditingController();
    TextEditingController _lastNameController = TextEditingController();
    TextEditingController _pictureController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  initialValue: title == "Edit" ? data!.title : "",
                  onChanged: (value) {
                    _titleController.text = value;
                  },
                  decoration: new InputDecoration(
                    hintText: "Example: MR, MS, MISS",
                    labelText: "Title",
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  initialValue: title == "Edit" ? data!.firstName : "",
                  onChanged: (value) {
                    _firstNameController.text = value;
                  },
                  decoration: new InputDecoration(
                    hintText: "Example: Gusti",
                    labelText: "First Name",
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  initialValue: title == "Edit" ? data!.lastName : "",
                  onChanged: (value) {
                    _lastNameController.text = value;
                  },
                  decoration: new InputDecoration(
                    hintText: "Example: Mertayasa",
                    labelText: "Last Name",
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  initialValue: title == "Edit" ? data!.picture : "",
                  onChanged: (value) {
                    _pictureController.text = value;
                  },
                  decoration: new InputDecoration(
                    hintText: "Example: https://image.com/profil.jpg",
                    labelText: "Picture",
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Picture cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Container(
          margin: const EdgeInsets.all(18),
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kMikadoYellow)),
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                print("masuk");
                if (title.toString() == "Add") {
                  var uuid = Uuid();
                  DataItem value = new DataItem(
                      id: uuid.v4(),
                      title: _titleController.text,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      picture: _pictureController.text);
                  await Provider.of<AddPageNotifier>(context, listen: false)
                      .add(value);

                  final message =
                      Provider.of<AddPageNotifier>(context, listen: false)
                          .message;

                  if (message == AddPageNotifier.successMessage) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));

                    await Provider.of<HomePageNotifier>(context, listen: false)
                        .fetchDataUsers(true);

                    Navigator.pop(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(message),
                          );
                        });
                  }
                } else {
                  DataItem value = new DataItem(
                    id: data!.id,
                    title: _titleController.text.isNotEmpty ||
                            _titleController.text != ""
                        ? _titleController.text
                        : data!.title,
                    firstName: _firstNameController.text.isNotEmpty ||
                            _firstNameController.text != ""
                        ? _firstNameController.text
                        : data!.firstName,
                    lastName: _lastNameController.text.isNotEmpty ||
                            _lastNameController.text != ""
                        ? _lastNameController.text
                        : data!.lastName,
                    picture: _pictureController.text.isNotEmpty ||
                            _pictureController.text != ""
                        ? _pictureController.text
                        : data!.picture,
                  );
                  await Provider.of<AddPageNotifier>(context, listen: false)
                      .edit(value);

                  final message =
                      Provider.of<AddPageNotifier>(context, listen: false)
                          .message;

                  if (message == AddPageNotifier.editSuccessMessage) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));

                    await Provider.of<DetailPageNotifier>(context,
                            listen: false)
                        .fetchDataById(data!.id);

                    await Provider.of<HomePageNotifier>(context, listen: false)
                        .fetchDataUsers(true);

                    Navigator.pop(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(message),
                          );
                        });
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
