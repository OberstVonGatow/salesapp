import 'package:flutter/material.dart';
import 'package:salesapp/services/auth.dart';
import 'package:salesapp/services/collmex.dart';
import 'package:salesapp/services/firestore.dart';
import 'package:salesapp/services/models.dart';

class CurrentOrder with ChangeNotifier {
  Order _order = Order();
  OrderItem _currentOrderItem = OrderItem();

  Customer get customer {
    return _order.customer ?? Customer();
  }

  set customer(Customer customer) {
    _order.customer = customer;
    notifyListeners();
  }

  Order get order => _order;

  set order(Order order) {
    _order = order;
    notifyListeners();
  }

  void saveCurrentItem() {
    if (_currentOrderItem.amountGross > 0) {
      _currentOrderItem.amountVat = _currentOrderItem.amountGross /
          (100 + _currentOrderItem.vat) *
          _currentOrderItem.vat;
      _currentOrderItem.amountNet =
          _currentOrderItem.amountGross - _currentOrderItem.amountVat;
      _currentOrderItem.amountTotal =
          _currentOrderItem.amountGross * _currentOrderItem.quantity;
    }

    if (_currentOrderItem.posId != 0) {
      var index = _order.items
          .indexWhere((item) => item.posId == _currentOrderItem.posId);
      _order.items[index] = _currentOrderItem;
    } else {
      if (_order.items.isEmpty) {
        _currentOrderItem.posId = 1;
        List<OrderItem> currentList = [_currentOrderItem];
        _order.items = currentList;
      } else {
        _currentOrderItem.posId =
            _order.items.reduce((a, b) => a.posId > b.posId ? a : b).posId + 1;
        _order.items.add(_currentOrderItem);
      }
    }
    _order.items.sort((a, b) {
      var anum = int.tryParse(a.posnum);
      var bnum = int.tryParse(b.posnum);
      if (anum != null && bnum != null) {
        return anum.compareTo(bnum);
      } else {
        return a.posnum.compareTo(b.posnum);
      }
    });
    notifyListeners();
  }

  OrderItem get currentOrderItem => _currentOrderItem;

  set currentOrderItem(OrderItem item) {
    _currentOrderItem = item;
    notifyListeners();
  }

  void saveOrder() {
    _order.amountGross = _order.amountNet = _order.amountNet7 =
        _order.amountVat7 = _order.amountNet19 = _order.amountVat19 = 0;
    for (var item in _order.items) {
      _order.amountGross += item.amountTotal;
      _order.amountNet += item.amountNet * item.quantity;
      if (item.vat == 7.0) {
        _order.amountNet7 += item.amountNet * item.quantity;
        _order.amountVat7 += item.amountVat * item.quantity;
      } else if (item.vat == 19.0) {
        _order.amountNet19 += item.amountNet * item.quantity;
        _order.amountVat19 += item.amountVat * item.quantity;
      }
    }

    FirestoreService().saveOrder(_order);
  }

  void deleteOrder() {
    FirestoreService().deleteOrder(_order);
    notifyListeners();
  }

  void newOrder() {
    _order = Order();
    _order.customer = Customer();
  }

  void newOrderItem() {
    int newPos = 10;
    if (_order.items.isNotEmpty) {
      var lastnum = int.tryParse(_order.items.last.posnum);
      newPos = ((lastnum ?? 0) + 10);
    }
    _currentOrderItem = OrderItem(posnum: newPos.toString());
  }

  void deleteOrderItem() {
    if (_currentOrderItem.posId != 0) {
      var index = _order.items
          .indexWhere((item) => item.posId == _currentOrderItem.posId);
      _order.items.removeAt(index);
      notifyListeners();
    }
  }

  void saveCustomer(CollmexLogin collmexLogin) async {
    await FirestoreService().saveCustomer(_order.customer!);
    Collmex().modifyCustomer(_order.customer!, collmexLogin);
    notifyListeners();
  }
}

class UserDataProvider with ChangeNotifier {
  UserData _userData = UserData();

  UserData get userData {
    var user = AuthService().user!;
    FirestoreService().getUserData(user).then((value) {
      _userData = value;
      notifyListeners();
    });
    return _userData;
  }
}

class Customers with ChangeNotifier {
  List<Customer> _customers = [];

  List<Customer> get customers {
    if (_customers.isEmpty) {
      FirestoreService().selectCustomers().then((value) {
        _customers = value;
        notifyListeners();
      });
    }
    return _customers;
  }
}
