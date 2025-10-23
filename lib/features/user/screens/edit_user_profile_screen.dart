import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class EditUserProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditUserProfileScreen({super.key, required this.user});

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _displayName;
  late String _description;
  late String _photoUrl;

  @override
  void initState() {
    super.initState();
    _displayName = widget.user.displayName ?? '';
    _description = widget.user.description ?? '';
    _photoUrl = widget.user.photoUrl ?? '';
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedUser = UserModel(
        uid: widget.user.uid,
        email: widget.user.email,
        displayName: _displayName,
        description: _description,
        photoUrl: _photoUrl,
      );
      Provider.of<UserProvider>(context, listen: false).saveUser(updatedUser);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _displayName,
                decoration: const InputDecoration(labelText: 'Display Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a display name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _displayName = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _photoUrl,
                decoration: const InputDecoration(labelText: 'Photo URL'),
                onSaved: (value) {
                  _photoUrl = value ?? '';
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

