import 'package:flutter/material.dart';

class ListItemPage extends StatelessWidget {
  final String itemTitle;
  final String itemDesc;
  final String itemURL;

  final nameController = TextEditingController();
  final urlCharController = TextEditingController();

  ListItemPage(this.itemTitle, this.itemDesc, this.itemURL);

  get context => null;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueAccent[400]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          itemTitle,
          style: TextStyle(
            color: Colors.blueAccent[400],
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.network(itemURL, fit: BoxFit.fitHeight),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "$itemDesc",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
