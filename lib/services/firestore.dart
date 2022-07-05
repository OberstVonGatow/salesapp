import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/auth.dart';
import '/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User _firebaseuser = AuthService().user!;

  ///Select Customers
  Future<List<Customer>> selectCustomers() async {
    var ref = _db.collection('/users/${_firebaseuser.uid}/customers/');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var customers = data.map((d) => Customer.fromJson(d));
    return customers.toList();
  }

  Stream<List<Order>> streamOrders() {
    return _db
        .collection('users')
        .doc(_firebaseuser.uid)
        .collection('orders')
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => Order.fromJson(doc.data())).toList());
  }

  ///Init User
  Future<void> setCustomer(Customer customer) {
    var docPath =
        '/users/${_firebaseuser.uid}/customers/${customer.customerId}';
    var ref = _db.doc(docPath);
    return ref.set(customer.toJson());
  }

  /// Retrieves UserData Document
  Future<UserData> getUserData(User user) async {
    var ref = _db.collection('users').doc(user.uid);
    var snapshot = await ref.get().catchError((error) {
      initUserData(user);
    });
    return UserData.fromJson(snapshot.data() ?? {});
  }

  ///Init User
  Future<void> initUserData(User user) {
    var userDocPath = '/users/' + user.uid;
    var ref = _db.doc(userDocPath);
    var data = {
      'uid': user.uid,
      'mail': user.email,
    };
    return ref.set(data);
  }

  Future<void> saveOrder(Order order) async {
    if (order.orderId == 0) {
      order.orderId = await getHighestOrderID();
      order.orderId += 1;
      if (order.orderNr == '') {
        order.orderNr = 'RE' + order.orderId.toString().padLeft(5, '0');
      }
    }
    var ref = _db
        .collection('users')
        .doc(_firebaseuser.uid)
        .collection('orders')
        .doc(order.orderId.toString());

    List<Map> items = [];
    for (var item in order.items) {
      items.add(item.toJson());
    }
    var orderjson = order.toJson();
    orderjson["customer"] = order.customer!.toJson();
    orderjson["items"] = items;
    return ref.set(orderjson, SetOptions(merge: true));
  }

  Future<int> getHighestOrderID() async {
    var ref =
        _db.collection('users').doc(_firebaseuser.uid).collection('orders');
    var query = ref.orderBy('orderId').limitToLast(1);
    var snapshot = await query.get();
    return int.parse(snapshot.docs.single.id);
  }

  void deleteOrder(Order order) {
    var ref = _db
        .collection('users')
        .doc(_firebaseuser.uid)
        .collection('orders')
        .doc(order.orderId.toString());

    ref.delete();
  }

  Future<void> saveCustomer(Customer customer) async {
    if (customer.customerId == 0) {
      customer.customerId = await getHighestCustomerID();
      customer.customerId += 1;
    }
    var ref = _db
        .collection('users')
        .doc(_firebaseuser.uid)
        .collection('customers')
        .doc(customer.customerId.toString());
    return ref.set(customer.toJson(), SetOptions(merge: true));
  }

  Future<int> getHighestCustomerID() async {
    var ref =
        _db.collection('users').doc(_firebaseuser.uid).collection('customers');
    var query = ref.orderBy('customerId').limitToLast(1);
    var snapshot = await query.get();
    return int.parse(snapshot.docs.single.id);
  }
}
