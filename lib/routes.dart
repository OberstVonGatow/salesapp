import 'package:salesapp/customer/customer.dart';
import 'package:salesapp/login/login.dart';
import 'package:salesapp/order/order.dart';
import 'package:salesapp/order/orderitem.dart';
import 'package:salesapp/order/pdfpreview.dart';

var appRoutes = {
  // '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/order': (context) => const OrderScreen(),
  '/customer': (context) => const CustomerScreen(),
  '/orderitem': (context) => const OrderItemScreen(),
  '/pdfpreview': (context) => const PDFPreviewScreen(),
};
