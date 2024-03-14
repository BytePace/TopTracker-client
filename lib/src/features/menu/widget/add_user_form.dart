import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';

class AddUserForm extends StatefulWidget {
  final int id;
  const AddUserForm({super.key, required this.id});

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final TextEditingController emailController = TextEditingController();
  String selectedValue = "worker";

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("admin"), value: "admin"),
      const DropdownMenuItem(child: Text("worker"), value: "worker"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserServices>(context);

    return Form(
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
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  try {
                    viewModel.addUser("aleksandrsherbakov.2005@gmail.com", "", selectedValue, widget.id);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Что то пошло не так")));
                  }
                }
              },
              child: Text("Submit"))
        ],
      ),
    );
  }
}
