import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSelected;

  const MenuButton({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isSelected = false, // Mặc định là false nếu không truyền vào
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.grey[700],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey[700],
          ),
        ),
        tileColor: isSelected ? Colors.grey[400] : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        onTap: onPressed,
      ),
    );
  }
}
