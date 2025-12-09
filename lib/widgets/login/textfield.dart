// packages
// ignore_for_file: deprecated_member_use

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class TextFieldNeumorphic extends StatefulWidget {
  final String type;
  final double width, height, fontsize;
  final ValueChanged<String>? onChanged;
  const TextFieldNeumorphic({
    super.key,
    required this.type,
    this.onChanged,
    required this.width,
    required this.height,
    required this.fontsize,
  });

  @override
  State<TextFieldNeumorphic> createState() => _TextFieldNeumorphic();
}

class _TextFieldNeumorphic extends State<TextFieldNeumorphic> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _filledAndUnfocused = false, _eyeclosed = true;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _filledAndUnfocused =
            !_focusNode.hasFocus && _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Neumorphic(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        style: NeumorphicStyle(
          color: Colors.white,
          depth: _filledAndUnfocused ? 6 : -6,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(500)),
          intensity: 0.8,
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: _controller,
          focusNode: _focusNode,
          obscureText: widget.type == 'password' && _eyeclosed,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: widget.fontsize,
            color: Colors.black87,
          ),
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            hintText: widget.type[0].toUpperCase() + widget.type.substring(1),
            hintStyle: TextStyle(
              fontFamily: 'RalewayReg',
              fontSize: widget.fontsize,
              color: Colors.black12,
            ),
            suffixIcon:
                widget.type == 'password'
                    ? GestureDetector(
                      onTap:
                          () => setState(() {
                            _eyeclosed = !_eyeclosed;
                          }),
                      child: Container(
                        width: 6.w,
                        margin: EdgeInsets.only(right: 8.w, left: 5.w),

                        alignment: Alignment.center,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset(
                          _eyeclosed
                              ? './assets/imgs/closedeye.png'
                              : './assets/imgs/openeye.png',
                        ),
                      ),
                    )
                    : null,

            prefixIcon: Container(
              width: 3.5.w,
              margin: EdgeInsets.only(left: 8.w, right: 5.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                widget.type == 'username'
                    ? './assets/imgs/user.png'
                    : './assets/imgs/lock.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
