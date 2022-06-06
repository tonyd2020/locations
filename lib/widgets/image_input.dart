
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {

  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final _picker = ImagePicker();
   final imageFile = await _picker.pickImage(
       source: ImageSource.camera,
   maxWidth: 600,);
   if(imageFile == null) {
     return;
   }
   setState(() {
     _storedImage = File(imageFile.path);
   });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            )
          ),
          child: _storedImage != null ? Image.file(
              _storedImage as File,
          fit: BoxFit.cover,
            width: double.infinity,
          ) : const Text('No image taken', textAlign: TextAlign.center,),
    alignment: Alignment.center,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
          label: const Text('Take picture'),
    textColor: Theme.of(context).primaryColor,
    onPressed: _takePicture,
    icon: const Icon(Icons.camera),
    ),
        )
      ],
    );
  }
}
