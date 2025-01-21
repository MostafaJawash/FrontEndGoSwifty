import 'package:delivery/Services/apiAdminStore.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

abstract class StoreDialogBase extends StatefulWidget {
  const StoreDialogBase({Key? key}) : super(key: key);
}

abstract class StoreDialogBaseState<T extends StoreDialogBase>
    extends State<T> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? userImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        userImage = pickedFile;
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
                  image: userImage != null
                      ? DecorationImage(
                          image: FileImage(File(userImage!.path)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: userImage == null
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
            decoration: _inputDecoration('Store Name'),
            validator: (value) => value != null && value.isNotEmpty
                ? null
                : 'This field is required',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: _inputDecoration('Address'),
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
        ],
      ),
    );
  }
}

class CreateStoreDialog extends StoreDialogBase {
  final String token;
  CreateStoreDialog({required this.token});

  @override
  _CreateStoreDialogState createState() => _CreateStoreDialogState();
}

class _CreateStoreDialogState extends StoreDialogBaseState<CreateStoreDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildDialogContent('Create Store'),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                String address = _addressController.text;
                String description = _descriptionController.text;

                if (userImage == null) {
                  print('Please select an image.');
                  return;
                }

                try {
                  await createStore(
                    token: widget.token,
                    name: name,
                    image: File(userImage!.path),
                    description: description,
                    address: address,
                  );

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('Store created successfully!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } catch (e) {
                  print('Error creating store: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 183, 16, 183),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditStoreDialog extends StatefulWidget {
  final String currentName;
  final String currentAddress;
  final String currentDescription;
  final String storeId;
  final String token;

  EditStoreDialog({
    required this.currentName,
    required this.currentAddress,
    required this.currentDescription,
    required this.storeId,
    required this.token,
  });

  @override
  _EditStoreDialogState createState() => _EditStoreDialogState();
}

class _EditStoreDialogState extends State<EditStoreDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _addressController.text = widget.currentAddress;
    _descriptionController.text = widget.currentDescription;
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

  Future<void> _saveStore() async {
    String updatedName = _nameController.text;
    String updatedAddress = _addressController.text;
    String updatedDescription = _descriptionController.text;

    if (_image == null) {
      _showErrorDialog('Please select an image.');
      return;
    }

    bool success = await updateStore(
      token: widget.token,
      storeId: widget.storeId,
      name: updatedName,
      address: updatedAddress,
      description: updatedDescription,
      image: _image!,
    );

    if (success) {
      Navigator.pop(context);
      _showSuccessDialog();
    } else {
      _showErrorDialog('Failed to update store. Please try again later.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Store updated successfully.'),
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
                'Edit Store',
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
                decoration: _inputDecoration('Store Name'),
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : 'This field is required',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: _inputDecoration('Address'),
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
              ElevatedButton(
                onPressed: _saveStore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 183, 16, 183),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showDeleteConfirmationDialog({
  required BuildContext context,
  required String token,
  required String storeId,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure you want to delete this store?'),
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

              bool success = await deleteStore(token: token, storeId: storeId);

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
        content: Text('فشل في حذف المتجر. يرجى المحاولة لاحقًا.'),
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
