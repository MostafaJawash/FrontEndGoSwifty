import 'package:delivery/Services/apiAdminProduct.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

abstract class ProductDialogBase extends StatefulWidget {
  const ProductDialogBase({Key? key}) : super(key: key);
}

abstract class ProductDialogBaseState<T extends ProductDialogBase>
    extends State<T> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 217, 22, 238)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 193, 64, 208), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 217, 22, 238), width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget buildDialogContent(String title) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 153, 9, 169),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey[300],
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _image == null
                    ? const Center(
                        child: Icon(Icons.image, size: 40, color: Colors.grey),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 183, 16, 183),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add_a_photo, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Add Image', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: _inputDecoration('Product Name'),
            validator: (value) => value != null && value.isNotEmpty
                ? null
                : 'This field is required',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: _inputDecoration('Description'),
            maxLines: 1,
            validator: (value) => value != null && value.isNotEmpty
                ? null
                : 'This field is required',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Price'),
            validator: (value) =>
                value != null && double.tryParse(value) != null
                    ? null
                    : 'Enter a valid price',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Quantity'),
            validator: (value) => value != null && int.tryParse(value) != null
                ? null
                : 'Enter a valid quantity',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CreateProductDialog extends ProductDialogBase {
  final String token;
  final String storeId;

  const CreateProductDialog({required this.token, required this.storeId});

  @override
  _CreateProductDialogState createState() => _CreateProductDialogState();
}

class _CreateProductDialogState
    extends ProductDialogBaseState<CreateProductDialog> {
  Future<void> _createProduct() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    if (_image == null) {
      print('Please select an image.');
      return;
    }

    try {
      await createProduct(
        idStore: widget.storeId,
        token: widget.token,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        image: _image!,
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error creating product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildDialogContent('Create Product'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 183, 16, 183),
              ),
              onPressed: _createProduct,
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProductDialog extends StatefulWidget {
  final String currentName;
  final String currentDescription;
  final double currentPrice;
  final double currentQuantity;
  final String productId;
  final String token;

  EditProductDialog({
    required this.currentName,
    required this.currentDescription,
    required this.currentPrice,
    required this.currentQuantity,
    required this.productId,
    required this.token,
  });

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _descriptionController.text = widget.currentDescription;
    _priceController.text = widget.currentPrice.toString();
    _quantityController.text = widget.currentQuantity.toString();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProduct() async {
    String updatedName = _nameController.text;
    String updatedDescription = _descriptionController.text;
    double updatedPrice = double.tryParse(_priceController.text) ?? 0.0;
    int updatedQuantity = int.tryParse(_quantityController.text) ?? 0;

    if (_image == null) {
      _showErrorDialog('Please select an image.');
      return;
    }

    bool success = await updateProduct(
      id: widget.productId,
      token: widget.token,
      name: updatedName,
      description: updatedDescription,
      price: updatedPrice,
      quantity: updatedQuantity,
      image: _image!,
    );

    if (success) {
      Navigator.pop(context);
      _showSuccessDialog();
    } else {
      _showErrorDialog('Failed to update product. Please try again later.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Product updated successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 217, 22, 238)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 193, 64, 208), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 217, 22, 238), width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Product',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 153, 9, 169),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey[300],
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _image == null
                        ? const Center(
                            child:
                                Icon(Icons.image, size: 40, color: Colors.grey),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 183, 16, 183),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.add_a_photo, color: Colors.white),
                        SizedBox(width: 5),
                        Text('Add Image',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Product Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Description'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: _inputDecoration('Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: _inputDecoration('Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 183, 16, 183),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showDeleteProductConfirmationDialog({
  required BuildContext context,
  required String token,
  required String productId,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              bool success =
                  await deleteProduct(token: token, productId: productId);

              if (success) {
                if (context.mounted) {}
              } else {
                if (context.mounted) {
                  showFailureDialog(context);
                }
              }
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}

void showFailureDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text('فشل في حذف المنتج. يرجى المحاولة لاحقًا.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
