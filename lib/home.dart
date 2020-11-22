import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
      });
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,);
    setState(() {
      _output=output;
      _loading=false;
    });
  }

  loadModel() async{
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  pickImage() async{
    var image= await picker.getImage(source: ImageSource.camera);
    if(image==null) return null;

    setState(() {
      _image=File(image.path);
    });
    
    classifyImage(_image);
  }

  pickGallery() async{
    var image= await picker.getImage(source: ImageSource.gallery);
    if(image==null) return null;

    setState(() {
      _image=File(image.path);
    });

    classifyImage(_image);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF101010),
      backgroundColor: Colors.white,
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                )
              ),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  // Text(
                  //   'TeachableMachine.com  CNN',
                  //   style: TextStyle(
                  //     color: Color(0xFFEEDA28),
                  //     fontSize: 15,
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  Text(
                    'Detect Dogs And Cats',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Center(child: _loading? Container(
              width: 300,
              child: Column(
                children: [
                  Image.asset('assets/cat1.png'),
                  SizedBox(height: 50,),
                ],
              ),
            ) : Container(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    child: Image.file(_image),

                  ),
                  SizedBox(height: 20,),
                  _output!=null? Text('${_output[0]["label"]}', style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.w500),) : Container(),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            ),
            Center(
              child: Container(
                width: 185,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: FlatButton(
                    onPressed: (){
                      pickImage();
                },
                    // color: Color(0xFFE99600),

                    child: Text(
                      "Take A Photo",
                    style: TextStyle(color:Colors.white, fontSize: 16),),
                ),
              ),
            ),
            SizedBox(height: 15,),

            Center(
              child: Container(
                width: 185,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: FlatButton(
                    onPressed: (){
                      pickGallery();
                },
                    child: Text(
                        "Choose From Gallery",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                    ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
