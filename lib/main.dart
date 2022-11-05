import 'dart:io';
import 'dart:convert';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late EmployeeDataSource employeeDataSource;
  late List<GridColumn> _columns;
  String searchString = "";

  @override
  void initState() {
    super.initState();
    _columns = getColumns();
  }

  Future<dynamic> generateEmployeeList() async {
    // Give your sever URL of get_employees_details.php file
    var url = "http://192.168.1.33:82/FetchDatabaseMysql/fetch.php";

    final response = await http.get(Uri.parse(url));
    var list = json.decode(response.body);
    List<Employee> employees =
        await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    employeeDataSource = EmployeeDataSource(employees);
    return employees;
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'saleid',
        width: 120,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          color: Colors.yellowAccent[200],
          child: const Text(
            'SaleID',
            textScaleFactor: 1.3,
          ),
        ),
      ),
      GridColumn(
        columnName: 'custname',
        width: 120,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          color: Colors.yellowAccent[200],
          child: const Text(
            'Name',
            textScaleFactor: 1.3,
          ),
        ),
      ),
      GridColumn(
        columnName: 'mobile',
        width: 120,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          color: Colors.yellowAccent[200],
          child: const Text(
            'Mobile',
            textScaleFactor: 1.3,
          ),
        ),
      ),
      GridColumn(
        columnName: 'cashreceive',
        width: 120,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          color: Colors.yellowAccent[200],
          child: const Text(
            'Amount',
            textScaleFactor: 1.3,
          ),
        ),
      ), //GridColumn
      GridColumn(
        columnName: 'billtype',
        width: 120,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          color: Colors.yellowAccent[200],
          child: const Text(
            'Bill-Type',
            textScaleFactor: 1.3,
          ),
        ),
      ),
      GridColumn(
        columnName: 'billtime',
        width: 120,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          color: Colors.yellowAccent[200],
          child: const Text(
            'Bill-Time',
            textScaleFactor: 1.3,
          ),
        ),
      ),
      GridColumn(
        columnName: 'date',
        width: 120,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          color: Colors.yellowAccent[200],
          child: const Text(
            'Date',
            textScaleFactor: 1.3,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Data Analysis'),
        ),
        body: Column(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Search', suffixIcon: Icon(Icons.search)),
                ),
              ),

              const SizedBox(height: 5),
              FutureBuilder<dynamic>(
                  future: generateEmployeeList(),
                  builder: (context, data) {
                    return data.hasData
                        ? SfDataGrid(
                            source: employeeDataSource,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            columnWidthMode: ColumnWidthMode.fill,
                            columns: _columns)
                        : const Center(
                            child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: 0.8,
                          ));
                  }),
            ]),
      ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(this.employees) {
    buildDataGridRow();
  }

  void buildDataGridRow() {
    _employeeDataGridRows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'saleid', value: e.saleid),
              DataGridCell<String>(columnName: 'custname', value: e.custname),
              DataGridCell<String>(columnName: 'mobile', value: e.mobile),
              DataGridCell<int>(
                  columnName: 'cashreceive', value: e.cashreceive),
              DataGridCell<String>(columnName: 'billtype', value: e.billtype),
              DataGridCell<String>(columnName: 'billtime', value: e.billtime),
              DataGridCell<String>(columnName: 'date', value: e.date),
            ]))
        .toList();
  }

  List<Employee> employees = [];

  List<DataGridRow> _employeeDataGridRows = [];

  @override
  List<DataGridRow> get rows => _employeeDataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  void updateDataGrid() {
    notifyListeners();
  }
}

class Employee {
  int saleid;
  String custname;
  String mobile;
  int cashreceive;
  String billtype;
  String billtime;
  String date;

  Employee(
      {required this.saleid,
      required this.custname,
      required this.mobile,
      required this.cashreceive,
      required this.billtype,
      required this.billtime,
      required this.date});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      saleid: int.parse(json['saleid']),
      custname: json['custname'] as String,
      mobile: json['mobile'] as String,
      cashreceive: int.parse(json['cashreceive']),
      billtype: json['billtype'] as String,
      billtime: json['billtime'] as String,
      date: json['date'] as String,
    );
  }
}
