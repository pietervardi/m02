import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minggu_02/my_bio_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MyBio extends StatefulWidget {
  const MyBio({Key? key}) : super(key: key);

  @override
  State<MyBio> createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {
  final ImagePicker _picker = ImagePicker();
  final String _keyScore = 'score';
  final String _keyImage = 'image';
  final String _keyDate = 'date';

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      final myBioProvider = Provider.of<MyBioProvider>(context, listen: false);
      myBioProvider.setScore(prefs.getDouble(_keyScore) ?? 0);
      myBioProvider.setImage(prefs.getString(_keyImage));
      myBioProvider.setDate(DateTime.parse(prefs.getString(_keyDate) ?? DateTime.now().toIso8601String()),);
    }
  }

  Future<void> _setScore(double value) async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      final myBioProvider = Provider.of<MyBioProvider>(context, listen: false);
      myBioProvider.setScore(value);
      prefs.setDouble(_keyScore, value);
    }
  }

  Future<void> _setImage(String? value) async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      final myBioProvider = Provider.of<MyBioProvider>(context, listen: false);
      if (value != null) {
        myBioProvider.setImage(value);
        prefs.setString(_keyImage, value);
      }
    }
  }

  Future<void> _setDate(DateTime date) async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      final myBioProvider = Provider.of<MyBioProvider>(context, listen: false);
      myBioProvider.setDate(date);
      prefs.setString(_keyDate, date.toIso8601String());
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<MyBioProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(color: Colors.red[200]),
                  child: prov.image != null
                      ? Image.file(
                          File(prov.image!),
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 198, 198, 198)),
                          width: 200,
                          height: 200,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    _setImage(image?.path);
                  },
                  child: const Text('Take Image'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinBox(
                  max: 10.0,
                  min: 0.0,
                  value: prov.score,
                  decimals: 1,
                  step: 0.1,
                  decoration: const InputDecoration(labelText: 'Decimals'),
                  onChanged: _setScore,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Selected Date: ${DateFormat('dd/MM/yyyy').format(prov.date.toLocal())}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final DateTime picked = (await showDatePicker(
                          context: context,
                          initialDate: prov.date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        )) ??
                        prov.date;
                    if (picked != null && picked != prov.date) {
                      _setDate(picked);
                    }
                  },
                  child: const Text('Select Date'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}