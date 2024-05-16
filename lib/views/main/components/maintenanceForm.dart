import 'package:dorminic_co/main.dart';
import 'package:dorminic_co/models/utils/constants/sizes.dart';
import 'package:dorminic_co/models/utils/constants/text_provider.dart';
import 'package:dorminic_co/models/utils/helpers/passwordvisibilitytoggle.dart';
import 'package:dorminic_co/models/utils/http/http_client.dart';
import 'package:dorminic_co/views/main/maintenance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MaintenanceForm extends StatefulWidget {
  final APIClient apiClient;
  final String orgCode;
  const MaintenanceForm(
      {super.key, required this.apiClient, required this.orgCode});

  @override
  State<MaintenanceForm> createState() => _MaintenanceFormState();
}

class _MaintenanceFormState extends State<MaintenanceForm> {
  final _formKey = GlobalKey<FormState>();
  late String _orgCode;
  //String _informantId = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orgCode = widget
        .orgCode; // Initialize _orgCode with the value from widget.orgCode
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Iconsax.arrow_left,
              color: Colors.white,
            ),
            onPressed: () {
              // Action to perform when back button is pressed
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spaceBtwItems, horizontal: 16),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.tag),
                      labelText: 'Topic',
                      //labelStyle: TextStyle(fontSize: 16)
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spaceBtwInputFields,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.message),
                      labelText: 'Description',
                      //labelStyle: TextStyle(fontSize: 16)
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spaceBtwInputFields,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          widget.apiClient.createMaintenance(
                            _orgCode,
                            titleController.text,
                            descriptionController.text
                            //_informantId,
                          );
                          Get.snackbar(
                            'Success',
                            'Maintenance reported successfully',
                          );
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text('Report New Issue'),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spaceBtwItems,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
