library awesome_dialog;

import 'anims/anims.dart';
import 'package:awesome_dialog/animated_button.dart';
import 'package:awesome_dialog/anims/flare_header.dart';
import 'package:awesome_dialog/vertical_stack_header_dialog.dart';
import 'package:flutter/material.dart';

enum DialogType { INFO, WARNING, ERROR, SUCCES }
enum AnimType { SCALE, LEFTSLIDE, RIGHSLIDE, BOTTOMSLIDE, TOPSLIDE }

class AwesomeDialog {
  final DialogType dialogType;
  final Widget customHeader;
  final String tittle;
  final String desc;
  final BuildContext context;
  final String btnOkText;
  final IconData btnOkIcon;
  final Function btnOkOnPress;
  final Color btnOkColor;
  final String btnCancelText;
  final IconData btnCancelIcon;
  final Function btnCancelOnPress;
  final Color btnCancelColor;
  final Widget btnOk;
  final Widget btnCancel;
  final Widget body;
  final bool dismissOnTouchOutside;
  final Function onDissmissCallback;
  final AnimType animType;
  final AlignmentGeometry aligment;
  final EdgeInsetsGeometry padding;
  final bool isDense;
  final bool headerAnimationLoop;
  final bool useRootNavigator;
  AwesomeDialog(
      {@required this.context,
      this.dialogType,
      this.customHeader,
      this.tittle = '',
      this.desc = '',
      this.body,
      this.btnOk,
      this.btnCancel,
      this.btnOkText,
      this.btnOkIcon,
      this.btnOkOnPress,
      this.btnOkColor,
      this.btnCancelText,
      this.btnCancelIcon,
      this.btnCancelOnPress,
      this.btnCancelColor,
      this.onDissmissCallback,
      this.isDense = false,
      this.dismissOnTouchOutside = true,
      this.headerAnimationLoop = true,
      this.aligment = Alignment.center,
      this.animType = AnimType.SCALE,
      this.padding,
      this.useRootNavigator = false})
      : assert(
          (dialogType != null || customHeader != null),
          context != null,
        );

  Future<bool> show() async {
    var result = await showDialog<bool>(
        context: this.context,
        useRootNavigator: this.useRootNavigator,
        barrierDismissible: dismissOnTouchOutside,
        builder: (BuildContext context) {
          return build();
        });
    if (onDissmissCallback != null) onDissmissCallback();
    return result ?? false;
  }

  Widget build() {
    switch (animType) {
      case AnimType.SCALE:
        return Scale(
            scalebegin: 0.1,
            curve: Curves.fastLinearToSlowEaseIn,
            child: _buildDialog());
        break;
      case AnimType.LEFTSLIDE:
        return Slide(from: SlideFrom.LEFT, child: _buildDialog());
        break;
      case AnimType.RIGHSLIDE:
        return Slide(from: SlideFrom.RIGHT, child: _buildDialog());
        break;
      case AnimType.BOTTOMSLIDE:
        return Slide(from: SlideFrom.BOTTOM, child: _buildDialog());
        break;
      case AnimType.TOPSLIDE:
        return Slide(from: SlideFrom.TOP, child: _buildDialog());
        break;
      default:
        return _buildDialog();
    }
  }

  _buildDialog() {
    return VerticalStackDialog(
      header: customHeader ??
          FlareHeader(
            loop: headerAnimationLoop,
            dialogType: this.dialogType,
          ),
      title: this.tittle,
      desc: this.desc,
      body: this.body,
      isDense: isDense,
      aligment: aligment,
      padding: padding ?? EdgeInsets.only(left: 5, right: 5),
      btnOk: btnOk ?? (btnOkOnPress != null ? _buildFancyButtonOk() : null),
      btnCancel: btnCancel ??
          (btnCancelOnPress != null ? _buildFancyButtonCancel() : null),
    );
  }

  _buildFancyButtonOk() {
    return AnimatedButton(
      pressEvent: () {
        Navigator.of(context, rootNavigator: useRootNavigator).pop(true);
        btnOkOnPress();
      },
      text: btnOkText ?? 'Ok',
      color: btnOkColor ?? Color(0xFF00CA71),
      icon: btnOkIcon,
    );
  }

  _buildFancyButtonCancel() {
    return AnimatedButton(
      pressEvent: () {
        Navigator.of(context, rootNavigator: useRootNavigator).pop(false);
        btnCancelOnPress();
      },
      text: btnCancelText ?? 'Cancel',
      color: btnCancelColor ?? Colors.red,
      icon: btnCancelIcon,
    );
  }

  dissmiss() {
    Navigator.of(context, rootNavigator: useRootNavigator).pop(false);
  }
}
