import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      DropdownMenuItem(
          value: "admin", child: Text(AppLocalizations.of(context)!.roleAdmin)),
      DropdownMenuItem(
          value: "worker",
          child: Text(AppLocalizations.of(context)!.roleWorker)),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.addUser,
            style: Theme.of(context).textTheme.headlineMedium),
        Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.emailHint),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseEnterText;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  DropdownButtonFormField(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    value: _role,
                    onChanged: (String? newValue) {
                      setState(() {
                        _role = newValue!;
                      });
                    },
                    items: dropdownItems,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseEnterText;
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
                      BlocProvider.of<DetailProjectBloc>(context).add(
                          AddUserEvent(
                              email: _email,
                              role: _role,
                              rate: "",
                              projectID: widget.id));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .somethingWentWrong)));
                    }
                  }
                },
                child: Text(AppLocalizations.of(context)!.submitButton))
          ],
        ),
      ],
    );
  }
}
