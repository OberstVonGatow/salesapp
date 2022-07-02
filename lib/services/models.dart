import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Customer {
  int customerId;
  String name1;
  String name2;
  String street;
  String city;
  String zipcode;
  String email;
  String telephone;

  Customer(
      {this.customerId = 0,
      this.name1 = '',
      this.name2 = '',
      this.street = '',
      this.city = '',
      this.zipcode = '',
      this.email = '',
      this.telephone = ''});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class UserData {
  String uid;
  String mail;
  CollmexLogin? collmex;
  UserData({
    this.uid = '',
    this.mail = '',
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class Order {
  int orderId;
  String orderNr;
  Customer? customer;
  DateTime? orderdate;
  String orderstate;
  double amountGross;
  double amountNet;
  double amountNet7;
  double amountVat7;
  double amountNet19;
  double amountVat19;
  int collmexBooking;
  String paymethod;
  DateTime? emaildate;
  String text;
  List<OrderItem> items;

  Order({
    this.orderId = 0,
    this.orderNr = '',
    this.orderstate = '',
    this.amountGross = 0.0,
    this.amountNet = 0.0,
    this.amountNet7 = 0.0,
    this.amountVat7 = 0.0,
    this.amountNet19 = 0.0,
    this.amountVat19 = 0.0,
    this.collmexBooking = 0,
    this.paymethod = '',
    this.text = '',
    this.items = const [],
  });
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class OrderItem {
  int posId;
  String posnum;
  String postype;
  String text;
  int quantity;
  double vat;
  double amountGross;
  double amountNet;
  double amountVat;
  double amountTotal;

  OrderItem(
      {this.posId = 0,
      this.posnum = '',
      this.postype = 'normal',
      this.text = '',
      this.quantity = 1,
      this.vat = 7,
      this.amountGross = 0,
      this.amountNet = 0,
      this.amountVat = 0,
      this.amountTotal = 0});
  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class CollmexCustomer {
  String satzart;
  int kundennummer;
  int firmanr;
  String anrede;
  String titel;
  String vorname;
  String name;
  String firma;
  String abteilung;
  String strasse;
  String plz;
  String ort;
  String bemerkung;
//Inaktiv: 0 = aktiv, 1 = inaktiv, 2 = löschen, 3 = löschen, sofern nicht verwendet, andernfalls unverändert lassen.
  int inaktiv;
// Land C 2	ISO Codes
  String land;
  String telefon;
  String telefax;
  String email;
  String kontonr;
  String blz;
  String iban;
  String bic;
  String bankname;
  String steuernummer;
  String ustidnr;
  int zahlungsbed;
  int rabattgruppe;
  String lieferbedingung;
  String liefbedzusatz;
// Ausgabemedium: 0 = Druck, 1 = E-Mail, 2 = Fax, 3 = Brief. Standard ist E-Mail.
  int ausgabemedium;

  CollmexCustomer({
    this.satzart = "CMXKND",
    this.kundennummer = 0,
    this.firmanr = 1,
    this.anrede = "",
    this.titel = "",
    this.vorname = "",
    this.name = "",
    this.firma = "",
    this.abteilung = "",
    this.strasse = "",
    this.plz = "",
    this.ort = "",
    this.bemerkung = "",
    this.inaktiv = 0,
    this.land = "",
    this.telefon = "",
    this.telefax = "",
    this.email = "",
    this.kontonr = "",
    this.blz = "",
    this.iban = "",
    this.bic = "",
    this.bankname = "",
    this.steuernummer = "",
    this.ustidnr = "",
    this.zahlungsbed = 0,
    this.rabattgruppe = 0,
    this.lieferbedingung = "",
    this.liefbedzusatz = "",
    this.ausgabemedium = 0,
  });
  factory CollmexCustomer.fromJson(Map<String, dynamic> json) =>
      _$CollmexCustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CollmexCustomerToJson(this);
}

@JsonSerializable()
class CollmexLogin {
  String userid;
  String username;
  String password;
  String companynr;

  CollmexLogin({
    this.userid = "",
    this.username = "",
    this.password = "",
    this.companynr = "",
  });
  factory CollmexLogin.fromJson(Map<String, dynamic> json) =>
      _$CollmexLoginFromJson(json);
  Map<String, dynamic> toJson() => _$CollmexLoginToJson(this);
}
