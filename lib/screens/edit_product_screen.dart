import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../widgets/image_input.dart';


class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  final String id;

  EditProductScreen({this.id});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  var _editedProduct = ProductItem(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  bool _isLoading = false;

  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  @override
  void initState() {
    super.initState();

    updateUI(widget.id);
  }

  void updateUI(String id) {
    if (id != null) {
      _editedProduct =
          Provider.of<Product>(context, listen: false).findbyId(id);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setLoading(bool isload) {
    setState(() {
      _isLoading = isload;
    });
  }

  Future<void> _saveForm() async {
    if (_fbKey.currentState.saveAndValidate()) {
      print(_fbKey.currentState.value);
      final _fields = _fbKey.currentState.value;
      
      setLoading(true);
      try {
      
        //upload image
        final fileUrl = await Provider.of<Product>(context, listen: false)
            .uploadFile(_pickedImage);

        print(fileUrl);
        ProductItem _prod = ProductItem(
          id: _editedProduct.id == null ? "0" : _editedProduct.id,
          title: _fields['title'],
          price: double.parse(_fields['price']),
          description:  _fields['description'],
          imageUrl: fileUrl.toString(),
        );

        if (_editedProduct.id != null) {
          await Provider.of<Product>(context, listen: false)
              .updateProduct(_editedProduct.id, _prod);
        } else {
          await Provider.of<Product>(context, listen: false).addProduct(_prod);
        }
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      setLoading(false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _fbKey,
                autovalidate: true,
                child: ListView(
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: 'title',
                      initialValue: _editedProduct.title,
                      decoration: InputDecoration(labelText: "Title"),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(50),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: 'description',
                      initialValue: _editedProduct.description,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: "Description"),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(10),
                        FormBuilderValidators.maxLength(200),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: 'price',
                      initialValue: _editedProduct.price > 0
                          ? _editedProduct.price.toString()
                          : "",
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Price"),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.min(1),
                        FormBuilderValidators.max(10000000),
                      ],
                    ),                 
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                         
                          ImageInput(_selectImage),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
