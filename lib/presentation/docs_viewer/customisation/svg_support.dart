import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_widget/markdown_widget.dart';
///
/// A [SpanNode] for [local] and [remote] SVGs.
class SvgNode extends SpanNode {
  ///
  final Map<String, String> _attributes;
  ///
  /// The [MarkdownConfig] for the document.
  final MarkdownConfig config;
  ///
  final double? _width;
  //
  SvgNode({required Map<String, String> attributes, required this.config, double? width}) : _width = width,  _attributes = attributes;
  //
  @override
  InlineSpan build() {
    final url = _attributes['src'] ?? '';
    final alt = _attributes['alt'] ?? '';
    final isNetSvg = url.startsWith('http');
    final imgWidget = isNetSvg
        ? SvgPicture.network(
            url,
            semanticsLabel: alt,
          )
        : SvgPicture.asset(
            url,
            semanticsLabel: alt,
            width: _width,
          );

    return WidgetSpan(
      child: imgWidget,
    );
  }
}
///
/// A [SpanNode] for inline SVG.
class SvgRawNode extends SpanNode {
  /// The SVG code to be rendered.
  final String svg;
  //
  SvgRawNode({required this.svg});
  //
  @override
  InlineSpan build() {
    return WidgetSpan(
      child: SvgPicture.string(svg),
    );
  }
}
