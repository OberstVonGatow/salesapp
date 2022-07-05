import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:salesapp/services/firestore.dart';
import 'package:salesapp/services/models.dart';
import 'dart:convert';

class Collmex {
  void syncCustomers(CollmexLogin collmexLogin) async {
    final response = await http.post(
        Uri.parse(
            'https://www.collmex.de/c.cmx?${collmexLogin.userid},0,data_exchange'),
        headers: <String, String>{
          'Content-Type': 'text/csv',
        },
        body:
            'LOGIN;${collmexLogin.username};${collmexLogin.password}\nCUSTOMER_GET;;${collmexLogin.companynr}\n');

    if (response.statusCode == 200) {
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter(fieldDelimiter: ';').convert(response.body);

      FirestoreService fstore = FirestoreService();
      for (var row in rowsAsListOfValues) {
        if (row[0] != 'CMXKND') continue;
        var customer = collmexToCustomer(row);
        fstore.setCustomer(customer);
      }
    } else {
      print(response);
      throw Exception('Failed to connect to Collmex');
    }
  }

  Customer collmexToCustomer(List<dynamic> row) {
    var customer = Customer(
      customerId: row[1],
      name1: row[7],
      name2: row[8],
      street: row[9],
      zipcode: row[10].toString(),
      city: row[11],
      telephone: row[15],
      email: row[17],
    );
    if (customer.name1 == '') {
      customer.name1 = row[5] + ' ' + row[6];
    }
    return customer;
  }

  CollmexCustomer customerConvertToCollmex(Customer customer) {
    CollmexCustomer collmex = CollmexCustomer(
      kundennummer: customer.customerId,
      firma: customer.name1,
      abteilung: customer.name2,
      strasse: customer.street,
      ort: customer.city,
      plz: customer.zipcode,
      email: customer.email,
      telefon: customer.telephone,
    );
    return collmex;
  }

  void modifyCustomer(Customer customer, CollmexLogin collmexLogin) async {
    List<List<String>> csvList = [];

    List<String> csvLoginRow = [];
    csvLoginRow.add("LOGIN");
    csvLoginRow.add(collmexLogin.username);
    csvLoginRow.add(collmexLogin.password);
    csvList.add(csvLoginRow);

    var collmexCustMap = customerConvertToCollmex(customer).toJson();
    List<String> collCustList = [];
    collmexCustMap.forEach((k, v) => collCustList.add(v.toString()));
    csvList.add(collCustList);

    String csvString =
        const ListToCsvConverter(fieldDelimiter: ';').convert(csvList);

    debugPrint(csvString);

    final response = await http.post(
        Uri.parse(
            'https://www.collmex.de/c.cmx?${collmexLogin.userid},0,data_exchange'),
        headers: <String, String>{
          'Content-Type': 'text/csv',
        },
        body: csvString,
        encoding: Encoding.getByName("iso_8859-1"));


    if (response.statusCode == 200) {
      debugPrint(response.body);
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter(fieldDelimiter: ';').convert(response.body);
      var row = rowsAsListOfValues[0];
      if (row[0] == 'NEW_OBJECT_ID') {
        customer.customerId = row[1];
      }
      await FirestoreService().saveCustomer(customer);
    } else {
      debugPrint(response.body);
      throw Exception('Failed to connect to Collmex');
    }
  }
}
