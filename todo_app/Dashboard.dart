import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Dashboard extends StatefulWidget {
  final String token;
  Dashboard({required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  final todotitle = TextEditingController();
  final tododesc = TextEditingController();
  List? items;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodecToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodecToken['_id'];
    gettodolist(userId);
  }

  Future<void> gettodolist(userId) async {
    var regbody = {
      "userId": userId
    };

    var response = await http.post(
      Uri.parse('http://192.168.48.111:4000/gettodolist'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regbody),
    );

    var jsonResponse = jsonDecode(response.body);
    setState(() {
      items = jsonResponse['Success'];
    });
    print(jsonResponse['status']);
  }

  void addtodo() async {
    if (todotitle.text.isNotEmpty && tododesc.text.isNotEmpty) {
      var regbody = {
        "userId": userId,
        "title": todotitle.text,
        "desc": tododesc.text,
      };
      try {
        var response = await http.post(
          Uri.parse('http://10.0.2.2:4000/adtodo'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regbody),
        );

        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['status']);

        if (jsonResponse['status']) {
          Navigator.pop(context);
          gettodolist(userId);
          todotitle.clear();
          tododesc.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? "Try Again")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Network error: ${e.toString()}")),
        );
      }
    }
  }

Future<void> deletetodo(id) async {
  var regbody = {
    "id": id,};
  {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:4000/deletetodo'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regbody),
    );
    var jsonresponse=jsonDecode(response.body);
    if(jsonresponse['status']){
      gettodolist(userId);
    }
  }

  }

  Future<void> _displaytextinputdialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: todotitle,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent,
                  hintText: 'Enter Title',
                  helperText: 'At least 4 characters',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 12),
              TextField(
                controller: tododesc,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent,
                  hintText: 'Enter Description',
                  helperText: 'At least 5 characters',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              ElevatedButton(
                onPressed: addtodo,
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 60.0,
              left: 30,
              right: 30,
              bottom: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.list, size: 30),
                ),
                SizedBox(height: 10),
                Text(
                  "ToDo With Nodejs+ MongoDB",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text("5 Task", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: items == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: items!.length,
                  itemBuilder: (context, int index) {
                    return Slidable(
                      key: ValueKey(index),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: "Delete",
                            onPressed: (BuildContext context) {
                              print("${items![index]['id']}");
                              deletetodo('${items![index]['_id']}');
                            },
                          ),
                        ],
                      ),
                      child: Card(
                        borderOnForeground: false,
                        child: ListTile(
                          leading: Icon(Icons.task),
                          title: Text("${items![index]["title"]}"),
                          subtitle: Text("${items![index]["desc"]}"),
                          trailing: Icon(Icons.arrow_back),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displaytextinputdialog(context),
        tooltip: "Add_Todo",
        child: Icon(Icons.add),
      ),
    );
  }
}