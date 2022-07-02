// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      customerId: json['customerId'] as int? ?? 0,
      name1: json['name1'] as String? ?? '',
      name2: json['name2'] as String? ?? '',
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      zipcode: json['zipcode'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telephone: json['telephone'] as String? ?? '',
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'customerId': instance.customerId,
      'name1': instance.name1,
      'name2': instance.name2,
      'street': instance.street,
      'city': instance.city,
      'zipcode': instance.zipcode,
      'email': instance.email,
      'telephone': instance.telephone,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      uid: json['uid'] as String? ?? '',
      mail: json['mail'] as String? ?? '',
    )..collmex = json['collmex'] == null
        ? null
        : CollmexLogin.fromJson(json['collmex'] as Map<String, dynamic>);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'uid': instance.uid,
      'mail': instance.mail,
      'collmex': instance.collmex,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      orderId: json['orderId'] as int? ?? 0,
      orderNr: json['orderNr'] as String? ?? '',
      orderstate: json['orderstate'] as String? ?? '',
      amountGross: (json['amountGross'] as num?)?.toDouble() ?? 0.0,
      amountNet: (json['amountNet'] as num?)?.toDouble() ?? 0.0,
      amountNet7: (json['amountNet7'] as num?)?.toDouble() ?? 0.0,
      amountVat7: (json['amountVat7'] as num?)?.toDouble() ?? 0.0,
      amountNet19: (json['amountNet19'] as num?)?.toDouble() ?? 0.0,
      amountVat19: (json['amountVat19'] as num?)?.toDouble() ?? 0.0,
      collmexBooking: json['collmexBooking'] as int? ?? 0,
      paymethod: json['paymethod'] as String? ?? '',
      text: json['text'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..customer = json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>)
      ..orderdate = json['orderdate'] == null
          ? null
          : DateTime.parse(json['orderdate'] as String)
      ..emaildate = json['emaildate'] == null
          ? null
          : DateTime.parse(json['emaildate'] as String);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'orderNr': instance.orderNr,
      'customer': instance.customer,
      'orderdate': instance.orderdate?.toIso8601String(),
      'orderstate': instance.orderstate,
      'amountGross': instance.amountGross,
      'amountNet': instance.amountNet,
      'amountNet7': instance.amountNet7,
      'amountVat7': instance.amountVat7,
      'amountNet19': instance.amountNet19,
      'amountVat19': instance.amountVat19,
      'collmexBooking': instance.collmexBooking,
      'paymethod': instance.paymethod,
      'emaildate': instance.emaildate?.toIso8601String(),
      'text': instance.text,
      'items': instance.items,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      posId: json['posId'] as int? ?? 0,
      posnum: json['posnum'] as String? ?? '',
      postype: json['postype'] as String? ?? 'normal',
      text: json['text'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      vat: (json['vat'] as num?)?.toDouble() ?? 7,
      amountGross: (json['amountGross'] as num?)?.toDouble() ?? 0,
      amountNet: (json['amountNet'] as num?)?.toDouble() ?? 0,
      amountVat: (json['amountVat'] as num?)?.toDouble() ?? 0,
      amountTotal: (json['amountTotal'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'posId': instance.posId,
      'posnum': instance.posnum,
      'postype': instance.postype,
      'text': instance.text,
      'quantity': instance.quantity,
      'vat': instance.vat,
      'amountGross': instance.amountGross,
      'amountNet': instance.amountNet,
      'amountVat': instance.amountVat,
      'amountTotal': instance.amountTotal,
    };

CollmexCustomer _$CollmexCustomerFromJson(Map<String, dynamic> json) =>
    CollmexCustomer(
      satzart: json['satzart'] as String? ?? "CMXKND",
      kundennummer: json['kundennummer'] as int? ?? 0,
      firmanr: json['firmanr'] as int? ?? 1,
      anrede: json['anrede'] as String? ?? "",
      titel: json['titel'] as String? ?? "",
      vorname: json['vorname'] as String? ?? "",
      name: json['name'] as String? ?? "",
      firma: json['firma'] as String? ?? "",
      abteilung: json['abteilung'] as String? ?? "",
      strasse: json['strasse'] as String? ?? "",
      plz: json['plz'] as String? ?? "",
      ort: json['ort'] as String? ?? "",
      bemerkung: json['bemerkung'] as String? ?? "",
      inaktiv: json['inaktiv'] as int? ?? 0,
      land: json['land'] as String? ?? "",
      telefon: json['telefon'] as String? ?? "",
      telefax: json['telefax'] as String? ?? "",
      email: json['email'] as String? ?? "",
      kontonr: json['kontonr'] as String? ?? "",
      blz: json['blz'] as String? ?? "",
      iban: json['iban'] as String? ?? "",
      bic: json['bic'] as String? ?? "",
      bankname: json['bankname'] as String? ?? "",
      steuernummer: json['steuernummer'] as String? ?? "",
      ustidnr: json['ustidnr'] as String? ?? "",
      zahlungsbed: json['zahlungsbed'] as int? ?? 0,
      rabattgruppe: json['rabattgruppe'] as int? ?? 0,
      lieferbedingung: json['lieferbedingung'] as String? ?? "",
      liefbedzusatz: json['liefbedzusatz'] as String? ?? "",
      ausgabemedium: json['ausgabemedium'] as int? ?? 0,
    );

Map<String, dynamic> _$CollmexCustomerToJson(CollmexCustomer instance) =>
    <String, dynamic>{
      'satzart': instance.satzart,
      'kundennummer': instance.kundennummer,
      'firmanr': instance.firmanr,
      'anrede': instance.anrede,
      'titel': instance.titel,
      'vorname': instance.vorname,
      'name': instance.name,
      'firma': instance.firma,
      'abteilung': instance.abteilung,
      'strasse': instance.strasse,
      'plz': instance.plz,
      'ort': instance.ort,
      'bemerkung': instance.bemerkung,
      'inaktiv': instance.inaktiv,
      'land': instance.land,
      'telefon': instance.telefon,
      'telefax': instance.telefax,
      'email': instance.email,
      'kontonr': instance.kontonr,
      'blz': instance.blz,
      'iban': instance.iban,
      'bic': instance.bic,
      'bankname': instance.bankname,
      'steuernummer': instance.steuernummer,
      'ustidnr': instance.ustidnr,
      'zahlungsbed': instance.zahlungsbed,
      'rabattgruppe': instance.rabattgruppe,
      'lieferbedingung': instance.lieferbedingung,
      'liefbedzusatz': instance.liefbedzusatz,
      'ausgabemedium': instance.ausgabemedium,
    };

CollmexLogin _$CollmexLoginFromJson(Map<String, dynamic> json) => CollmexLogin(
      userid: json['userid'] as String? ?? "",
      username: json['username'] as String? ?? "",
      password: json['password'] as String? ?? "",
      companynr: json['companynr'] as String? ?? "",
    );

Map<String, dynamic> _$CollmexLoginToJson(CollmexLogin instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'username': instance.username,
      'password': instance.password,
      'companynr': instance.companynr,
    };
