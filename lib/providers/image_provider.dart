import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/models/image_models/image_model.dart';
import 'package:suvidhaorg/services/backend_service.dart';

class ImageProvider extends ChangeNotifier{

  late BackendService backendService;
  ImageModel? image;
  final BuildContext context;
  List<ImageModel> images=[];
  
  ImageProvider({required this.context}):backendService=Provider.of<BackendService>(context);
  String? _errorMessage;
  String? get errorMessage=>_errorMessage;
  File? imageFile;
  String? imageType;
  String? imageUrl;

  
  //method to upload an image

  Future<void> uploadImage() async{
  try{
    final response= await backendService.postImage(image: imageFile!, imageType: imageType!);
    if(response.data != null){
          image = ImageModel.fromJson(response.data!);
          ScaffoldMessenger.of(context).
          showSnackBar(
            SnackBar(content: Text(response.message),
            backgroundColor: Theme.of(context).colorScheme.onError,
          
          
          
          ),);
          notifyListeners();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
      notifyListeners();
          
    }
    }
    catch(e){
      debugPrint('Error on uploading image :${e.toString()}');
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong, please try again later."),
        backgroundColor: Theme.of(context).colorScheme.onError,
        ),
        );
    }
  }


  //method to get the image
Future<void> getImage()async{
   try {
         final response= await backendService.getImage(imageUrl: imageUrl!);
         if(response.data!=null){
              image= ImageModel.fromJson(response.data!);
              notifyListeners();
         }
         else{
          _errorMessage= response.message;
          notifyListeners();
         }
   } catch (e) {
              debugPrint("Error in getting image :${e.toString()}");
              _errorMessage="Something went wrong, please try again later";
              notifyListeners();
   }

}
//delete the image
     
   Future<void> deleteImage()async{
      try {
        final response= await backendService.deleteImage(imageUrl: imageUrl!);
        if(response.statusCode==200){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            );
            notifyListeners();
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message),
            backgroundColor: Theme.of(context).colorScheme.onError,
            ),
            );
            notifyListeners();
        }
      } catch (e) {
        debugPrint("Error in deleting image :${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Something went wrong, please try again later."),
          backgroundColor: Theme.of(context).colorScheme.onError,
          ),
          );
          notifyListeners();
      }
   }
  
}
