import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';

class AddUserForm extends StatefulWidget {
  final int id;
  const AddUserForm({super.key, required this.id});

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  String _email = '';
  String _role = "worker";

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
                      _email = value!;
                    },
                  ),
                  DropdownButtonFormField(
                    value: _role,
                    onChanged: (String? newValue) {
                      setState(() {
                        _role = newValue!;
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
                      BlocProvider.of<DetailProjectBloc>(context).add(AddUSerEvent(
                          email: _email,
                          role: _role,
                          rate: "",
                          projectID: widget.id,
                          context: context));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Что то пошло не так")));
                    }
                  }
                },
                child: const Text("Submit"))
          ],
        ),
      ],
    );
  }
}
