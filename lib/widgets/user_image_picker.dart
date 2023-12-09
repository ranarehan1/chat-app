import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});

  final void Function(File pickedImage) onPickedImage;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageFile;
  void onPickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 150, imageQuality: 50);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
    widget.onPickedImage(pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          foregroundImage: pickedImageFile != null
              ? FileImage(pickedImageFile!)
              : null,
          backgroundImage: const AssetImage('assets/default_signup_image.png'),
          backgroundColor: Colors.white,
        ),
        const SizedBox(
          width: 15,
        ),
        ElevatedButton.icon(
          onPressed: onPickImage,
          icon: Icon(
            Icons.photo,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: Text(
            'Upload Image',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
