import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_db_app/view/item_form.dart';

import 'localDb/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Example',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  _loadItems() async {
    final loadedItems = await dbHelper.getItems();
    setState(() {
      items = loadedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Example'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          print("ITEM: $item");
          return ListTile(
            title: Text(item['name']),
            subtitle:
                Text(item['description'] + " " + item['createdAt'].toString()),
            leading: item['image'] != null
                ? Image.file(
                    File(item['image']!),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : Text('No IMG'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await dbHelper.deleteItem(item['id']);
                _loadItems();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ItemForm()));
          // Add new item
          // await dbHelper.addItem({
          //   'name': 'New Item',
          //   'description': 'Description for new item',
          //   'createdAt': DateTime.now().toString(),
          //   'image': 'image path'
          // });
          setState(() {
            _loadItems();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
