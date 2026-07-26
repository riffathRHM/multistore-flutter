
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height:MediaQuery.of(context).size.height*0.20,
      child: Stack(
        children: [
          Image.asset('assets/icons/searchBanner.jpeg',fit:BoxFit.cover,width: MediaQuery.of(context).size.width,),
          Positioned (
            left: 10,
            top: 50,
            child : SizedBox(width: 240,height: 50,child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter Text',
                hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF7F7F7F)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                prefixIcon:Image.asset('assets/icons/searc1.png'),
                suffixIcon: Image.asset('assets/icons/cam.png'),
                fillColor: Colors.grey.shade200,
                focusColor: Colors.black,
                filled: true,
              ),
            )),),
          Positioned(
            left: 265,
            top: 72,
            child: Material(
               type: MaterialType.transparency,
               child: InkWell(
                onTap: (){},
                overlayColor: WidgetStateProperty.all(const Color(0x000c7f7f)),
                child:Ink(
                  width: 31,
                  height: 31,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/bell.png'),
                      
                    ),
                  ),
                )
               ),
          )),
          Positioned(
            left:315,
            top: 72,
            child: Material(
              type: MaterialType.transparency,
             child: InkWell(
              onTap: (){},
              overlayColor: WidgetStateProperty.all(const Color(0x000c7f7f)),
              child:Ink(
                width: 31,
                height: 31,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/message.png'),
                    
                  ),
                ),
              )
             ),
          
          ))
        ],
      ),
    );
  }
}