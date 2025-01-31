import 'package:flutter/material.dart';


class DAppBar extends StatelessWidget implements PreferredSizeWidget {
  DAppBar({
    super.key,
    this.title,
    this.widgetTitle,
    this.showBackArrow = false,
    this.centerTitle = true,
    this.leadingWidget,
    this.actions,
    this.bgColor,
    this.arrowBackColor = false,
    this.fontSize,
    this.showBackGroundColor = false,
    this.doSomeThing,
    this.enableGradient = true,
  });
  final String? title;
  final bool showBackArrow;
  final bool showBackGroundColor;
  final bool centerTitle;
  final double? fontSize;
  final bool arrowBackColor;
  final List<Widget>? actions;
  final Widget? leadingWidget;
  final Widget? widgetTitle;
  final Color? bgColor;
  final bool enableGradient;
  void Function()? doSomeThing;
  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return AppBar(
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize ?? 24,
        fontFamily: "AmiriQuran",
        color: Colors.white,
      ),
      backgroundColor: enableGradient ? null : (bgColor ?? Colors.green),
      flexibleSpace: enableGradient
          ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFFF3CA40)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      )
          : null,
      automaticallyImplyLeading: false,
      leading: showBackArrow
          ? IconButton(
        onPressed: () {
          if (doSomeThing != null) {
            doSomeThing!();
          }
          Navigator.of(context).pop();
        },

        icon: Icon(
          isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: arrowBackColor ? Colors.white : Colors.white,
        ),
        tooltip: "رجوع",
      )
          : leadingWidget,
      title: widgetTitle?? Text(
        title ?? "",
        textAlign: centerTitle ? TextAlign.center : TextAlign.start,
      ),
      centerTitle: centerTitle,
      actions: actions ??
          [
            IconButton(
              onPressed: () {
                // Call action (e.g., for Qibla direction)
              },
              icon: const Icon(Icons.explore_rounded, color: Colors.white),
              tooltip: "اتجاه القبلة",
            ),
            IconButton(
              onPressed: () {
                // Placeholder for Azan notifications
              },
              icon: const Icon(Icons.notifications_active, color: Colors.white),
              tooltip: "إشعارات الأذان",
            ),
            SizedBox(width: 12),
          ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
