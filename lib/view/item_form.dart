import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../localDb/database_helper.dart';

class ItemForm extends StatefulWidget {
  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final dbHelper = DatabaseHelper();
  late String _title;
  late String _description;
  File? _image;
  late DateTime _currentDateTime = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  _loadItems() async {
    final loadedItems = await dbHelper.getItems();
    print("loadedItems: $loadedItems");
    // setState(() {
    //   items = loadedItems;
    // });
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Item Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item title';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Item Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getImage,
                  child: Text('Select Image'),
                ),
                SizedBox(height: 20),
                _image != null
                    ? Image.file(
                        _image!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                    : Text('No image selected.'),
                SizedBox(height: 20),
                Text(
                    'Current Datetime: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(_currentDateTime)}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Process form data
                      print('Title: $_title');
                      print('Description: $_description');
                      if (_image != null) {
                        print('Image Path: ${_image!.path}');
                      }
                      print('Datetime: $_currentDateTime');

                      await dbHelper.addItem({
                        'name': _title,
                        'description': _description,
                        'createdAt': _currentDateTime.toString(),
                        'image': _image!.path
                      });
                      _loadItems();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
