import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  ///GORNJI DEO STRANICE
  @override
  Widget build(BuildContext context) {
    return AppBar(
      //Gornji deo stranice
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.orange,
      title: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: Image.asset(
              'images/basket_AppBar.png',
              fit: BoxFit.cover,
            ),
            onTap: () => {
              if (ModalRoute.of(context).settings.name != '/login')
                {Navigator.pop(context), Navigator.pushNamed(context, '/Home')}
            },
          ),
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'KOTARICA',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
