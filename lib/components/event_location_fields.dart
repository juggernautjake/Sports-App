import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class EventLocationFields extends StatelessWidget {
  final TextEditingController streetAddressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipCodeController;
  final bool submitted;

  EventLocationFields({
    required this.streetAddressController,
    required this.cityController,
    required this.stateController,
    required this.zipCodeController,
    required this.submitted,
  });

  final List<String> _states = const [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
    'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts',
    'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico',
    'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
    'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(context, streetAddressController, 'Street Address'),
        _buildTextField(context, cityController, 'City'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    errorStyle: TextStyle(height: 0),
                    suffixIcon: submitted && stateController.text.isEmpty ? Icon(Icons.error, color: Colors.red) : null,
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return _states.where((state) => state.toLowerCase().contains(pattern.toLowerCase())).toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  stateController.text = suggestion;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        _buildTextField(context, zipCodeController, 'Zip Code', keyboardType: TextInputType.number),
      ],
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              errorStyle: TextStyle(height: 0),
              suffixIcon: submitted && controller.text.isEmpty ? Icon(Icons.error, color: Colors.red) : null,
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: (value) {
              // Trigger any needed state changes
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              if (label == 'Street Address' && !RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                return '';
              }
              if (label == 'City' && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                return '';
              }
              if (label == 'Zip Code' && !RegExp(r'^\d{5}$').hasMatch(value)) {
                return '';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
