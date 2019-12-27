import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_model.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {

  static const routName = '/edit_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  final _imageController = TextEditingController();

  var editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0
  );

  var _initValues = {
    'title' : '',
    'description' : '',
    'price' : '',
    'imageUrl' : ''
  };

  bool _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_imageUpdate);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        editedProduct =
            Provider.of<Products>(context, listen: false).items.firstWhere((prod) => prod.id == productId);
        _initValues = {
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageController.text = editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageController.dispose();
    _imageFocusNode.dispose();
    _imageFocusNode.removeListener(_imageUpdate);
    super.dispose();
  }

  void _imageUpdate() {
    if(!_imageFocusNode.hasFocus) {
      if(_imageController.text.isEmpty ||
          (!_imageController.text.startsWith('http') && !_imageController.text.startsWith('https')))
        {
          return;
        }
      setState(() {
      });
    }
  }

  void saveForm() {
   final isValid =  _form.currentState.validate();

   if(!isValid) {
     return ;
   }

    _form.currentState.save();

   setState(() {
     _isLoading = true;
   });

    if(editedProduct.id != null)
      {
        Provider.of<Products>(context).updateProduct(editedProduct.id, editedProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }else {
        Provider.of<Products>(context).addproduct(editedProduct)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        })
            .catchError((_) {
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text('An Error Occured'),
                content: Text('Something Went Wrong.'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      },
                    child: Text('Okay', style: TextStyle(
                        color: Colors.red
                    ),),
                  )
                ],
          ));
        });
    }


//    print(editedProduct.title);
//    print(editedProduct.id);
//    print(editedProduct.description);
//    print(editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: () {
              saveForm();
            },
          )
        ],
      ),
      body: _isLoading ?
      Center(
        child: CircularProgressIndicator(),
      ) : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title'
                ),
                autofocus: true,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                // ignore: missing_return
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Field Should not be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: value,
                    description: editedProduct.description,
                    imageUrl: editedProduct.imageUrl,
                    price: editedProduct.price,
                    isFavroute: editedProduct.isFavroute
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                    labelText: 'Price'
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                // ignore: missing_return
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Field Should not be empty';
                  }
                  if(double.tryParse(value) == null)
                    {
                      return 'Please enter valid number';
                    }
                  if(double.parse(value) <= 0)
                    {
                      return 'Value should be greater than Zero';
                    }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: editedProduct.description,
                      imageUrl: editedProduct.imageUrl,
                      price: double.parse(value),
                      isFavroute: editedProduct.isFavroute
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                // ignore: missing_return
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Field should not be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: value,
                      imageUrl: editedProduct.imageUrl,
                      price: editedProduct.price,
                      isFavroute: editedProduct.isFavroute
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                        right: 10,
                        top: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey
                      ),
                    ),
                    child: _imageController.text.isEmpty ?
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No Image'),
                      ),
                    ) :
                    FittedBox(
                      child:  Image.network('${_imageController.text}', fit: BoxFit.cover,),
                    )
                  ),
                  Expanded(
                    child: TextFormField(
                     // initialValue: _initValues['imageUrl'],
                      decoration: InputDecoration(
                        labelText: 'ImageUrl'
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageController,
                      focusNode: _imageFocusNode,
                      // ignore: missing_return
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Field Should not be empty';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https'))
                          {
                            return 'URL is not Valid';
                          }
//                        if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg'))
//                          {
//                            return 'Url is not Valid';
//                          }
                        return null;
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            imageUrl: value,
                            price: editedProduct.price,
                            isFavroute: editedProduct.isFavroute
                        );
                      },
                      onFieldSubmitted: (_) {
                        saveForm();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
