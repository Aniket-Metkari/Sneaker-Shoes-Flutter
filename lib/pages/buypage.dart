import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:day15_shoes/pages/sneakers.dart';
import 'package:day15_shoes/pages/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BuyPage(),
      getPages: [
        GetPage(name: '/home', page: () => HomePage()), // Define routes here
        // Add other routes if needed
      ],
    );
  }
}

class BuyPage extends StatefulWidget {
  const BuyPage({Key? key}) : super(key: key);

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController customerNameController =
      TextEditingController(); // New controller for customer name
  String selectedGender = 'Male'; // Default gender
  String selectedSize = '38'; // Default size
  String selectedName = ''; // Default name
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isDataSubmitted = false;

  Map<String, List<String>> genderNameMap = {
    'Male': [
      'Football shoes',
      'AirJordan black-white',
      'AirJordan full White',
      'AirJordan full Black'
    ],
    'Female': ['Sport Shoes', 'Hill shoes', 'Black Boots', 'Sneakers shoes'],
    'Kid': ['Sport shoes', 'Pink Sneakers', 'Runs Shoes']
  };

  Map<String, List<String>> genderSizeMap = {
    'Male': ['38', '40', '42', '44'],
    'Female': ['36', '38', '40', '42'],
    'Kid': ['8', '10', '12', '14']
  };

  List<String> nameOptions = [];

  @override
  void initState() {
    super.initState();
    nameOptions = genderNameMap[selectedGender]!;
    selectedName = nameOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: null,
        title: Text(
          "BuyPage",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/header.jpg"),
                    fit: BoxFit.fill),
                color: Colors.white54,
              ),
              child: const Text(
                "",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.black,
              ),
              title: const Text(
                "Home",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () => Get.offAll(() => Sneakers()),
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: const Text(
                "Setting",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.pages,
                color: Colors.black,
              ),
              title: const Text(
                "Products",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            )
          ],
        ),
      ),
      body: isDataSubmitted
          ? _buildThankYouForm()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller:
                          customerNameController, // Use customerNameController for customer name
                      decoration: InputDecoration(
                        labelText:
                            'Customer Name', // Label for customer name input field
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedGender,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGender = newValue!;
                          nameOptions = genderNameMap[selectedGender]!;
                          selectedName = nameOptions[0];
                          selectedSize = genderSizeMap[selectedGender]![
                              0]; // Update selected size based on gender change
                        });
                      },
                      items: <String>['Male', 'Female', 'Kid']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedName,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedName = newValue!;
                        });
                      },
                      items: nameOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedSize,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSize = newValue!;
                        });
                      },
                      items: genderSizeMap[selectedGender]!
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Size',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle submit button press
                      String name = nameController.text;
                      String customerName = customerNameController
                          .text; // Get customer name from the controller

                      // Save data to Firestore
                      _firestore.collection('products').add({
                        'pname': name,
                        'pgender': selectedGender,
                        'pname': selectedName,
                        'psize': selectedSize,
                        'customerName':
                            customerName, // Add customer name to Firestore
                      }).then((_) {
                        // Reset text fields after successful submission
                        nameController.clear();
                        customerNameController
                            .clear(); // Clear customer name field

                        // Show a snackbar or any other feedback to the user
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Data submitted successfully'),
                        ));

                        setState(() {
                          isDataSubmitted = true;
                        });
                      }).catchError((error) {
                        // Handle errors, if any
                        print('Error adding to Firestore: $error');
                      });

                      // For demonstration, print the input data
                      print(
                          'Customer Name: $customerName, Name: $name, Gender: $selectedGender, Name: $selectedName, Size: $selectedSize');
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildThankYouForm() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
          SizedBox(height: 20),
          Text(
            'Thank you for Ordering!',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/home'); // Navigate to Homepage
            },
            child: Text('Back to Homepage'),
          ),
        ],
      ),
    );
  }
}
