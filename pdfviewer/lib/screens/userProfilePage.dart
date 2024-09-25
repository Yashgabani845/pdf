import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Models/User.dart';
import '../../Services/userServices.dart'; // Adjust the path as needed

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _profileImage = File(pickedImage.path);
        });

        String? imageUrl = await uploadProfileImage(userModel.uid, _profileImage!);
        if (imageUrl != null) {
          userModel.profileImageUrl = imageUrl;
          await _updateUserData();
        }
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> _removeProfileImage() async {
    setState(() {
      _profileImage = null;
      userModel.profileImageUrl = null;
    });

    await _updateUserData();
  }

  late UserModel userModel;
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        setState(() {
          userModel = UserModel.fromMap(snapshot.data()!, snapshot.id);
          _nameController.text = userModel.name;
          _emailController.text = userModel.email;
          _selectedGender = userModel.gender ?? '';
          _dobController.text = userModel.dob ?? '';
        });
      }
    } catch (e) {
      // Handle errors here
    }
  }

  Future<void> _updateUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userModel.name = _nameController.text;
        userModel.gender = _selectedGender;
        userModel.dob = _dobController.text;

        await updateUser(userModel);

        setState(() {
          _isEditing = false;
        });

        _fetchUserData();
      }
    } catch (e) {
      // Handle errors here
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      appBar: AppBar(
        title: Text('User Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // Blue background for AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.grey[900], // Dark background for the profile block
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (userModel.profileImageUrl != null
                        ? NetworkImage(userModel.profileImageUrl!)
                        : AssetImage('assets/sub_assets/p1.jpg')) as ImageProvider,
                    backgroundColor: Colors.blueGrey,
                  ),
                  SizedBox(height: 20.0),
                  if (_isEditing) _buildImageButtons(),
                  _buildField(
                    controller: _nameController,
                    label: 'Name',
                    isEditable: _isEditing,
                  ),
                  SizedBox(height: 15.0),
                  if (!_isEditing) _buildField(
                    controller: _emailController,
                    label: 'Email',
                    isEditable: false,
                  ),
                  SizedBox(height: 15.0),
                  _buildField(
                    label: 'Gender',
                    isEditable: _isEditing,
                    text: _selectedGender ?? 'Not specified',
                    isDropdown: true,
                    dropdownItems: ['Male', 'Female', 'Other'],
                    selectedValue: _selectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 15.0),
                  _buildField(
                    controller: _dobController,
                    label: 'Date of Birth',
                    isEditable: _isEditing,
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton.icon(
                    onPressed: _isEditing ? _updateUserData : () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
                    label: Text(_isEditing ? 'Save Profile' : 'Update Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                      backgroundColor: Colors.blue, // Blue buttons
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      textStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    TextEditingController? controller,
    required String label,
    required bool isEditable,
    bool isDropdown = false,
    List<String>? dropdownItems,
    String? selectedValue,
    Function(String?)? onChanged,
    GestureTapCallback? onTap,
    String? text,
  }) {
    if (isDropdown) {
      return isEditable
          ? DropdownButtonFormField<String>(
        value: selectedValue,
        items: dropdownItems!.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: Colors.grey[800], // Dropdown background
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        style: TextStyle(color: Colors.white),
      )
          : _displayTextField(label, text);
    }

    return isEditable
        ? TextFormField(
      controller: controller,
      enabled: isEditable,
      readOnly: onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
    )
        : _displayTextField(label, controller?.text);
  }

  Widget _displayTextField(String label, String? text) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label: ${text ?? 'Not specified'}',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildImageButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _pickAndUploadImage,
          icon: Icon(Icons.camera_alt, color: Colors.white),
          label: Text(userModel.profileImageUrl == null ? 'Set Profile Picture' : 'Change Profile Picture'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        if (userModel.profileImageUrl != null)
          SizedBox(height: 10.0),
        if (userModel.profileImageUrl != null)
          ElevatedButton.icon(
            onPressed: _removeProfileImage,
            icon: Icon(Icons.delete, color: Colors.white),
            label: Text('Remove Profile Picture'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
      ],
    );
  }
}

