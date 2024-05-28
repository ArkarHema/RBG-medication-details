import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserHealthDetails extends StatefulWidget {
  final String userId;
  const UserHealthDetails({super.key, required this.userId});

  @override
  State<UserHealthDetails> createState() => _UserHealthDetailsState();
}

class _UserHealthDetailsState extends State<UserHealthDetails> {
  String healthDetailsText = '';
  String medicationDetailsText = '';
  String healthDetails='';
  String medicinename='';
  String dosage='';
  TextEditingController healthDetailsController = TextEditingController();
  TextEditingController medicationNameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();

  Future<void> updateUserDetails(String userId) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/update-health-details/$userId'), // replace localhost with server ip address
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patientHealthDetails':[
          {
            'details': healthDetailsController.text,
          },
        ],
      }),
    );

    if (response.statusCode == 200){
      print('User details updated successfully');
      getHealthDetails(widget.userId);
    } else {
      print('Error in updating user details');
      print(widget.userId);
    }
  }

  Future<void> updateMedicationDetails(String userId) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/update-medication-details/$userId'), // replace localhost with server ip address
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'currentMedications': [
          {
            'medicationName': medicationNameController.text,
            'dosage': dosageController.text,
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      // Medication details updated successfully
      print('Medication details updated successfully');
      getMedicationDetails(widget.userId);
    } else {
      // Error in updating medication details
      print('Error in updating medication details');
    }
  }

  Future<void> getHealthDetails(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/health-details/$userId'),// replace localhost with server ip address
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Health details fetched successfully
      final healthDetailsList = jsonDecode(response.body)['data'] as List;
      final healthDetails = healthDetailsList.map((entry) => entry['details'].toString()).toList();
      final formattedHealthDetails = healthDetails.join(', '); // or use any other formatting logic

      setState(() {
        healthDetailsText = formattedHealthDetails;
      });
      print('Health Details: $healthDetails');
    } else {
      // Error in fetching health details
      print('Error in fetching health details');
    }
  }

  Future<void> getMedicationDetails(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/medication-details/$userId'), // replace localhost with server ip address
      headers: {'Content-Type': 'application/json'},
    );
    print(response);
    if (response.statusCode == 200) {
      // Health details fetched successfully
      final medicationDetailsList = jsonDecode(response.body)['data'] as List;
      final medicationDetails = medicationDetailsList.map((entry) =>
      'Medication Name: ${entry['medicationName'].toString()}, Dosage: ${entry['dosage'].toString()}'
      ).toList();
      final formattedMedicationDetails = medicationDetails.join('\n'); // or use any other formatting logic

      setState(() {
        medicationDetailsText = formattedMedicationDetails;
      });
      print('Medication Details: $medicationDetails');
    } else {
      // Error in fetching health details
      print('Error in fetching health details');
    }
  }
  @override
  void initState() {
    super.initState();
    getHealthDetails(widget.userId);
    getMedicationDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User details",
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                      'Health details',
                      style: TextStyle(fontSize: 16.0),
                    ),
                        const SizedBox(
                            height: 16.0
                        ),
                        Text(
                          '$healthDetailsText',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(
                            height: 16.0
                        ),

                        TextButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                  title: const Text(
                                      'Add Health details'),
                                  content: Column(
                                    children: [
                                      const SizedBox(
                                        height: 16.0,
                                      ),
                                      TextFormField(
                                        controller: healthDetailsController,
                                        onSaved: (value) =>
                                        healthDetails = value!,
                                        style: const TextStyle(
                                          color: Colors
                                              .black, // Text color set to black
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: 'Health conditions',
                                          prefixIcon: Icon(Icons.add),
                                          border:
                                          OutlineInputBorder(), // Rounded border
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16.0,
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(onPressed: (){
                                      updateUserDetails(widget.userId);
                                      Navigator.pop(
                                          context, 'Health Details');
                                    }, child: const Text('Add'),)
                                  ],
                                ),
                          ),
                          child: const Text(
                            '+ Add health details',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors
                                  .purple, // Text color set to black
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 16.0
                        ),
                      ],
                    )
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Current Medications',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(
                              height: 16.0
                          ),
                          Text(
                            '$medicationDetailsText',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(
                              height: 16.0
                          ),
                          TextButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text(
                                        'Add Medication details'),
                                    content: Column(
                                      children: [
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        TextFormField(
                                          controller: medicationNameController,
                                          onSaved: (value) =>
                                          medicinename = value!,
                                          style: const TextStyle(
                                            color: Colors
                                                .black, // Text color set to black
                                          ),
                                          decoration: const InputDecoration(
                                            labelText: 'medicine name',
                                            prefixIcon: Icon(Icons.add),
                                            border:
                                            OutlineInputBorder(), // Rounded border
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        TextFormField(
                                          controller: dosageController,
                                          onSaved: (value) =>
                                          dosage = value!,
                                          style: const TextStyle(
                                            color: Colors
                                                .black, // Text color set to black
                                          ),
                                          decoration: const InputDecoration(
                                            labelText: 'dosage',
                                            prefixIcon: Icon(Icons.add),
                                            border:
                                            OutlineInputBorder(), // Rounded border
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                      ],
                                    ),

                                    actions: <Widget>[
                                      TextButton(onPressed: (){
                                        updateMedicationDetails(widget.userId);
                                        Navigator.pop(
                                            context, 'Medication Details');
                                      }, child: const Text('Add'),)
                                    ],
                                  ),
                            ),
                            child: const Text(
                              '+ Medication details',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors
                                    .purple, // Text color set to black
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 16.0
                          ),
                        ],
                      )
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
