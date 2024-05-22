import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({super.key, this.widgets});

  final Widget? widgets;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body:Stack(
          children: [
            Image.asset("assets/images/R.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,),
             SafeArea(child:widgets!),

          ],
      )
    );
  }
}