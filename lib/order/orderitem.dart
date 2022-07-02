import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesapp/services/provider.dart';

class OrderItemScreen extends StatefulWidget {
  const OrderItemScreen({Key? key}) : super(key: key);

  @override
  State<OrderItemScreen> createState() => _OrderItemScreenState();
}

class _OrderItemScreenState extends State<OrderItemScreen> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Position'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteOrderItem,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _setOrderItem,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Pos'),
                    initialValue:
                        context.watch<CurrentOrder>().currentOrderItem.posnum,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => context
                        .read<CurrentOrder>()
                        .currentOrderItem
                        .posnum = value ?? ''),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Typ'),
                  value: context.watch<CurrentOrder>().currentOrderItem.postype,
                  items: const [
                    DropdownMenuItem(child: Text("Normal"), value: "normal"),
                    DropdownMenuItem(child: Text("Text"), value: "text"),
                  ],
                  onChanged: (selected) {
                    if (selected is String) {
                      context.read<CurrentOrder>().currentOrderItem.postype =
                          selected;
                    }
                  },
                  onSaved: (selected) {
                    if (selected is String) {
                      context.read<CurrentOrder>().currentOrderItem.postype =
                          selected;
                    }
                  },
                ),
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Text'),
                    initialValue:
                        context.watch<CurrentOrder>().currentOrderItem.text,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => context
                        .read<CurrentOrder>()
                        .currentOrderItem
                        .text = value ?? ''),
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Menge'),
                    initialValue: context
                        .watch<CurrentOrder>()
                        .currentOrderItem
                        .quantity
                        .toString(),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      context.read<CurrentOrder>().currentOrderItem.quantity =
                          value == '' ? 0 : int.parse(value!);
                    }),
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Steuer'),
                    initialValue: context
                        .watch<CurrentOrder>()
                        .currentOrderItem
                        .vat
                        .toStringAsFixed(2),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      context.read<CurrentOrder>().currentOrderItem.vat =
                          value == '' ? 0.0 : double.parse(value!);
                    }),
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Preis'),
                    initialValue: context
                        .watch<CurrentOrder>()
                        .currentOrderItem
                        .amountGross
                        .toStringAsFixed(2),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      context
                              .read<CurrentOrder>()
                              .currentOrderItem
                              .amountGross =
                          value == '' ? 0.0 : double.parse(value!);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setOrderItem() {
    _form.currentState?.save();
    context.read<CurrentOrder>().saveCurrentItem();
    Navigator.pop(context);
  }

  void _deleteOrderItem() {
    context.read<CurrentOrder>().deleteOrderItem();
    Navigator.pop(context);
  }
}
