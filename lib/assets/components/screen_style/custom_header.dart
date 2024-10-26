import 'package:flutter/material.dart';

class CustomScreenHeader extends StatelessWidget {
  final String imagePath;
  final Widget child;

  const CustomScreenHeader({
    super.key,
    required this.imagePath,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20),
          child: Image.asset(
            imagePath,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        //BORDA ARREDONDADA
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 2.0,
          decoration: const BoxDecoration(
            //COR FUNDO PARTE INFERIOR
            color: Color(0xFFA8BEE0),

            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}