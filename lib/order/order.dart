import 'package:flutter/material.dart';
import 'package:salesapp/services/provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _form = GlobalKey<FormState>();
  final _format = DateFormat("dd.MM.yy");

  @override
  Widget build(BuildContext context) {
    TextEditingController _customerController = TextEditingController(
        text: context.watch<CurrentOrder>().customer.name1);
    TextEditingController _orderIdController = TextEditingController(
        text: context.watch<CurrentOrder>().order.orderNr);
    TextEditingController _orderTextController =
        TextEditingController(text: context.watch<CurrentOrder>().order.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auftrag'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteOrder,
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printOrder,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _setOrder,
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Auftragsnummer'),
                controller: _orderIdController,
                enabled: false,
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Kunde'),
                controller: _customerController,
                onTap: () {
                  _form.currentState?.save();
                  Navigator.pushNamed(context, '/customer');
                },
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Text'),
                controller: _orderTextController,
                textInputAction: TextInputAction.next,
                onSaved: (value) =>
                    context.read<CurrentOrder>().order.text = value ?? '',
              ),
              DateTimeField(
                decoration: const InputDecoration(labelText: 'Rechnungsdatum'),
                format: _format,
                initialValue: context.read<CurrentOrder>().order.orderdate ??
                    DateTime.now(),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(2022),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
                    locale: const Locale('de'),
                  );
                },
                onSaved: (value) => context
                    .read<CurrentOrder>()
                    .order
                    .orderdate = value ?? DateTime.now(),
              ),
              Expanded(
                child: Consumer<CurrentOrder>(
                    builder: (context, currentOrder, child) {
                  return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: currentOrder.order.items
                          .map(
                            (item) => Container(
                              key: Key(
                                  '${currentOrder.order.items.indexOf(item)}'),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: ListTile(
                                  leading: Text(item.posnum),
                                  title: Text(item.text),
                                  trailing: item.postype == "normal"
                                      ? Text(
                                          "${item.amountTotal.toStringAsFixed(2)} €")
                                      : const Text(""),
                                  onTap: () {
                                    context
                                        .read<CurrentOrder>()
                                        .currentOrderItem = item;
                                    Navigator.pushNamed(context, '/orderitem');
                                  }),
                            ),
                          )
                          .toList());
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _form.currentState?.save();
          context.read<CurrentOrder>().newOrderItem();
          Navigator.pushNamed(context, '/orderitem');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _setOrder() {
    _form.currentState?.save();
    context.read<CurrentOrder>().saveOrder();
    context.read<CurrentOrder>().newOrder();
    Navigator.pop(context);
  }

  void _deleteOrder() {
    context.read<CurrentOrder>().deleteOrder();
    Navigator.pop(context);
  }

  void _printOrder() {
    _form.currentState?.save();
    context.read<CurrentOrder>().saveOrder();
    Navigator.pushNamed(context, '/pdfpreview');
  }
}
