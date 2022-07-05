import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salesapp/customer/autocompletecustomer.dart';
import 'package:salesapp/services/models.dart';
import 'package:salesapp/services/provider.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _name2Controller = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  static String _displayStringForOption(Customer option) => option.name1;

  @override
  Widget build(BuildContext context) {
    _name2Controller.text = context.watch<CurrentOrder>().customer.name2;
    _streetController.text = context.watch<CurrentOrder>().customer.street;
    _zipcodeController.text = context.watch<CurrentOrder>().customer.zipcode;
    _cityController.text = context.watch<CurrentOrder>().customer.city;
    _emailController.text = context.watch<CurrentOrder>().customer.email;
    _telephoneController.text =
        context.watch<CurrentOrder>().customer.telephone;
    var _userData = context.read<UserDataProvider>().userData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kunde'),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.floppyDisk),
            onPressed: _saveCustomer,
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AutocompleteCustomer(),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name 2'),
                controller: _name2Controller,
                textInputAction: TextInputAction.next,
                onSaved: (value) =>
                    context.read<CurrentOrder>().customer.name2 = value ?? '',
              ),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Straße'),
                  controller: _streetController,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => context
                      .read<CurrentOrder>()
                      .customer
                      .street = value ?? ''),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'PLZ'),
                  controller: _zipcodeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    context.read<CurrentOrder>().customer.zipcode = value ?? '';
                  }),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Stadt'),
                  controller: _cityController,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) =>
                      context.read<CurrentOrder>().customer.city = value ?? ''),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => context
                      .read<CurrentOrder>()
                      .customer
                      .email = value ?? ''),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Telefon'),
                  controller: _telephoneController,
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => context
                      .read<CurrentOrder>()
                      .customer
                      .telephone = value ?? ''),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _saveCustomer,
                child: const Text('Speichern', textAlign: TextAlign.center),
              ),
              ElevatedButton(
                onPressed: _clearCustomer,
                child: const Text('Leeren', textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveCustomer() {
    _form.currentState?.save();
    // UserData _userdata = context.read<UserDataProvider>().userData;
    // context.read<CurrentOrder>().saveCustomer(_userdata.collmex!);
    context.read<CurrentOrder>().saveCustomer();
    Navigator.pop(context);
  }

  void _clearCustomer() {
    context.read<CurrentOrder>().customer = Customer();
  }
}
