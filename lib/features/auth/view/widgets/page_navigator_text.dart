import 'package:c_lient/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class PageNavigatorText extends StatelessWidget {
  const PageNavigatorText({
    super.key,
    required this.lable1,
    required this.lable2,
    required this.pageWidget,
  });
  final String lable1;
  final String lable2;
  final Widget pageWidget;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => pageWidget));
      },
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: Theme.of(context).textTheme.titleMedium,
          children: [
            TextSpan(
              text: "Sign Up",
              style: TextStyle(color: Pallete.gradient2),
            ),
          ],
        ),
      ),
    );
  }
}
