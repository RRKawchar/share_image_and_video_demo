import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final messageController = TextEditingController();

  String imageUrl="https://images.pexels.com/photos/53141/rose-red-blossom-bloom-53141.jpeg?cs=srgb&dl=pexels-pixabay-53141.jpg&fm=jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              /// Share Text
               sendTextWidget(),
              const SizedBox(height: 10,),

              /// Share Image from network
                sendNetWorkImgage(),
             /// Share Image from Gallery
                 ElevatedButton(onPressed: _sendImageFromGallery, child:const Text("Share image from gallery")),

              /// Share Video from Gallery
                 ElevatedButton(onPressed: _sendVideo, child:const Text("Share video from gallery")),

            ],
          ),
        ),
      ),
    );
  }

  Widget sendNetWorkImgage() {
    return Column(
                children: [
                  Image.network(imageUrl),
                  ElevatedButton(
                    onPressed: _sendNetWorkImage,
                    child: const Text("Share Image"),
                  )
                ],
              );
  }

  Widget sendTextWidget() {
    return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Message",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendText,
                  child: const Text("Shared Message"),
                ),
              ],
            );
  }
 /// Image method from gallery
  _sendImageFromGallery()async{
   final _image=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(_image == null){
      return;
    }else{
      await Share.shareFiles([_image.path]);
    }
  }

  ///  Network Image method
  void _sendNetWorkImage()async{
    final response = await http.get(Uri.parse(imageUrl));
    final bytes=response.bodyBytes;
    final temp= await getTemporaryDirectory();
    final path="${temp.path}/image.jpg";
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path]);
  }
  /// Send message  method
  void _sendText()async{

    if(messageController.value.text.isNotEmpty){
      await Share.share(messageController.text);
    }
  }

  /// Video method
  _sendVideo()async{
    final _video=await ImagePicker().pickVideo(source: ImageSource.gallery);
    if(_video==null){
      return;
    }else{
      await Share.shareFiles([_video.path]);

    }
  }



}
