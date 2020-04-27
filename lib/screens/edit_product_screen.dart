import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  final String id;

  EditProductScreen({this.id});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _priceFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  // final _imageUrlController = TextEditingController();
  // final _imageUrlFocusNode = FocusNode();

  //final _form = GlobalKey<FormState>();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  var _editedProduct = ProductItem(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  bool _isLoading = false;
  // var _initValues = {
  //   'title': '',
  //   'description': '',
  //   'price': '',
  //   'imageUrl': '',
  // };
  //var _isInit = true;

  @override
  void initState() {
    //_imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();

    updateUI(widget.id);
  }

  void updateUI(String id) {
    if (id != null) {
      _editedProduct =
          Provider.of<Product>(context, listen: false).findbyId(id);
    }
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     final productId = ModalRoute.of(context).settings.arguments as String;
  //     if (productId != null) {
  //       _editedProduct =
  //           Provider.of<Product>(context, listen: false).findById(productId);
  //       _initValues = {
  //         'title': _editedProduct.title,
  //         'description': _editedProduct.description,
  //         'price': _editedProduct.price.toString(),
  //         // 'imageUrl': _editedProduct.imageUrl,
  //         'imageUrl': '',
  //       };
  //       _imageUrlController.text = _editedProduct.imageUrl;
  //     }
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    // _priceFocusNode.dispose();
    // _descriptionFocusNode.dispose();
    // _imageUrlController.dispose();
    // _imageUrlFocusNode.dispose();
    super.dispose();
  }

  // void _updateImageUrl() {
  //   if (!_imageUrlFocusNode.hasFocus) {
  //     if ((!_imageUrlController.text.startsWith('http') &&
  //             !_imageUrlController.text.startsWith('https')) ||
  //         (!_imageUrlController.text.endsWith('.png') &&
  //             !_imageUrlController.text.endsWith('.jpg') &&
  //             !_imageUrlController.text.endsWith('.jpeg'))) {
  //       return;
  //     }
  //     setState(() {});
  //   }
  // }

  void setLoading(bool isload) {
    setState(() {
      _isLoading = isload;
    });
  }

  Future<void> _saveForm() async {
    if (_fbKey.currentState.saveAndValidate()) {
      print(_fbKey.currentState.value);

      setLoading(true);
      var prodlist = _fbKey.currentState.value.values.toList();

      ProductItem _prod = ProductItem(
        id: _editedProduct.id,
        title: prodlist[0].toString(),
        price: double.parse(prodlist[2].toString()),
        description: prodlist[1].toString(),
        imageUrl: prodlist[3].toString(),
      );

      try {
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
                    FormBuilderTextField(
                      attribute: 'imageUrl',
                      initialValue: _editedProduct.imageUrl,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(labelText: "Image Url"),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.url(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
