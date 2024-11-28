import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_widget/markdown_widget.dart';

/// A [SpanNode] for [local] and [remote] SVGs.
class SvgNode extends SpanNode {
  final Map<String, String> attributes;
  final MarkdownConfig config;
  final double? width;

  SvgNode({required this.attributes, required this.config, this.width});

  @override
  InlineSpan build() {
    final url = attributes['src'] ?? '';
    final alt = attributes['alt'] ?? '';
    final isNetSvg = url.startsWith('http');
    final imgWidget = isNetSvg
        ? SvgPicture.network(
            url,
            semanticsLabel: alt,
          )
        : SvgPicture.asset(
            url,
            semanticsLabel: alt,
            width: width,
          );

    return WidgetSpan(
      child: imgWidget,
    );
  }
}

/// A [SpanNode] for inline SVG.
class SvgRawNode extends SpanNode {
  /// The SVG code to be rendered.
  final String svg;

  SvgRawNode({required this.svg});

  @override
  InlineSpan build() {
    return WidgetSpan(
      child: SvgPicture.string(svg),
    );
  }
}
