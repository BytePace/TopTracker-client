import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/users/services/users_services.dart';

class AddUserForm extends StatefulWidget {
  final int id;
  const AddUserForm({super.key, required this.id});

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  String _formData = '';
  String selectedValue = "worker";

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "admin", child: Text("admin")),
      const DropdownMenuItem(value: "worker", child: Text("worker")),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserServices>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Добавить пользователя",
            style: Theme.of(context).textTheme.headlineMedium),
        Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(hintText: "email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData = value!;
                    },
                  ),
                  DropdownButtonFormField(
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      viewModel.addUser(
                          _formData, "", selectedValue, widget.id, context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Что то пошло не так")));
                    }
                  }
                },
                child: Text("Submit"))
          ],
        ),
      ],
    );
  }
}
