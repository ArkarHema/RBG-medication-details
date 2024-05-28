import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DrugSearch extends StatefulWidget {
  const DrugSearch({super.key});
  @override
  State<DrugSearch> createState() => _DrugSearchState();
}

class _DrugSearchState extends State<DrugSearch> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _drugnamecon = TextEditingController();
  String _drugname='';
  bool _isLoading = false;
  String _drugSideEffects = '';
  String _drugDosage = '';
  String _drugcategory='';
  Future<void> getDrugDetails(String drugName) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/drug-details/$drugName'),  //localhost-> give the server ip address
      headers: {'Content-Type': 'application/json'},
    );
    final DrugSideEffects = jsonDecode(response.body)['data']['sideEffects'] ;
    final DrugDosage = jsonDecode(response.body)['data']['dosagePreferred'] ;
    final Drugcategory = jsonDecode(response.body)['data']['category'] ;
    if (response.statusCode == 200) {
      setState(() {
        _drugSideEffects = DrugSideEffects.toString();
        _drugDosage = DrugDosage.toString();
        _drugcategory = Drugcategory.toString();
      });
      print('Drug Details: $_drugSideEffects');
    } else {
      // Handle error
      print('Failed to fetch drug details. Error: ${response.statusCode}');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Drug details",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.9, // One-third of the screen width
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.purple
                        .withOpacity(0.4), // Decreased opacity
                    borderRadius:
                    BorderRadius.circular(12.0), // Rounded corners
                  ),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _drugnamecon,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter drug name'
                                  : null,
                              onSaved: (value) => _drugname = value!,
                              style: const TextStyle(
                                color: Colors.black, // Text color set to black
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Drug name',

                                prefixIcon: Icon(Icons.medication),
                                border: OutlineInputBorder(), // Rounded border
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            _isLoading
                                ? const CircularProgressIndicator()
                                :Padding(padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _drugname = _drugnamecon.text;
                                    getDrugDetails(_drugname);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.purple, // Text color
                                  padding: const EdgeInsets.all(
                                      16.0), // Padding
                                  textStyle: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                child: const Text('Check the drug details'),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Drug Side effects: $_drugSideEffects',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              'Dosage preferred: $_drugDosage',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              'Category: $_drugcategory',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}