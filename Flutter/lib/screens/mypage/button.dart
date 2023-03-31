import 'package:flutter/cupertino.dart';

class MyButton extends StatelessWidget{
  final String label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:Color(0xFFABB15A)
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}