import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:universal_html/html.dart';

///A Flutter Widget to render Mathematics / Maths, Physics and Chemistry, Statistics / Stats Equations based on LaTeX with full HTML and JavaScript support.
///
///
class TeXView extends StatefulWidget {
  final Key key;

  ///Raw String containing HTML and TEX Code e.g. String textHTML = r"""$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$<br> """
  @required
  final String teXHTML;

  /// Render Engine to render TeX.
  final RenderingEngine renderingEngine;

  /// Fixed Height for TeXView. (Avoid using fixed height for TeXView, let it to adopt the height by itself)
  final double height;

  /// Show a loading widget before rendering completes.
  final Widget loadingWidget;

  /// Callback when TEX rendering finishes.
  final Function(double height) onRenderFinished;

  /// Callback when TeXView loading finishes.
  final Function(String message) onPageFinished;

  /// Keep widget Alive. (True by default).
  final bool keepAlive;

  TeXView(
      {this.key,
      this.teXHTML,
      this.height,
      this.loadingWidget,
      this.keepAlive,
      this.onRenderFinished,
      this.onPageFinished,
      this.renderingEngine});

  @override
  _TeXViewState createState() => _TeXViewState();
}

class _TeXViewState extends State<TeXView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 300,
      child: HtmlElementView(
        key: UniqueKey(),
        viewType: widget.teXHTML,
      ),
    );
  }

  @override
  void initState() {
    String renderEngine =
        widget.renderingEngine == RenderingEngine.MathJax ? "mathjax" : "katex";
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(widget.teXHTML, (int viewId) {
      return IFrameElement()
        ..width = context != null
            ? MediaQuery.of(context).size.width.toString()
            : '800' //'800'
        ..height = context != null
            ? MediaQuery.of(context).size.height.toString()
            : '400' //'400'
        ..src = kReleaseMode
            ? "assets/packages/flutter_tex/$renderEngine/index.html?teXHTML=${Uri.encodeComponent(widget.teXHTML)}"
            : "packages/flutter_tex/$renderEngine/index.html?teXHTML=${Uri.encodeComponent(widget.teXHTML)}"
        ..style.border = 'none';
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
