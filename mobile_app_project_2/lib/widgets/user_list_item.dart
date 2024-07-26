import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserListItem extends StatelessWidget {
  final UserModel user;

  const UserListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to user profile
        Navigator.pushNamed(context, '/profile', arguments: user.id);
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.profileImageUrl),
            ),
            SizedBox(height: 8),
            Text(
              user.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
