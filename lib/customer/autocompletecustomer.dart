import 'package:flutter/material.dart';
import 'package:salesapp/services/models.dart';
import 'package:provider/provider.dart';
import 'package:salesapp/services/provider.dart';

class AutocompleteCustomer extends StatefulWidget {
  const AutocompleteCustomer({Key? key}) : super(key: key);

  static String _displayStringForOption(Customer option) => option.name1;

  @override
  State<AutocompleteCustomer> createState() => _AutocompleteCustomerState();
}

class _AutocompleteCustomerState extends State<AutocompleteCustomer> {
  final _autocomplete = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<Customer> _customers = context.watch<Customers>().customers;

    return Autocomplete<Customer>(
        key: _autocomplete,
        displayStringForOption: AutocompleteCustomer._displayStringForOption,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<Customer>.empty();
          }
          return _customers.where((Customer option) {
            return option.name1
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (Customer selection) {
          // debugPrint('You just selected ${_displayStringForOption(selection)}');
          context.read<CurrentOrder>().customer = selection;
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          textEditingController.text =
              context.read<CurrentOrder>().customer.name1;
          return TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(labelText: 'Name 1'),
            textInputAction: TextInputAction.next,
            focusNode: focusNode,
            onSaved: (value) =>
                context.read<CurrentOrder>().customer.name1 = value ?? '',
          );
        });
  }
}
