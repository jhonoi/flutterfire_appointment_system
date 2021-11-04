import 'package:flutter/material.dart';

class HairStyleTile extends StatelessWidget {
  final String hairstyle;
  final int price;
  final String imgUrl;
  final String id;

  HairStyleTile(
      {@required this.hairstyle,
      @required this.price,
      @required this.imgUrl,
      @required this.id});

  @override
  Widget build(BuildContext context) {
    void selectHairStyle() {
      Navigator.pushNamed(context, '/details/${id.toString()}');
    }

    return GestureDetector(
      onTap: selectHairStyle,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                'images/${this.imgUrl}.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    hairstyle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '\$${this.price}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6A6A6A),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
