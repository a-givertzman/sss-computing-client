import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown_widget/markdown_widget.dart';
///
/// A customised [SpanNode] for LaTex.
/// uses [Math.tex] to generate the [SpanNode]
class LatexNode extends SpanNode {
  /// the attributes of the [LatexNode]
  final Map<String, String> attributes;
  /// the text content.
  final String textContent;
  /// The style and other configs of the markdown.
  final MarkdownConfig config;
  LatexNode(this.attributes, this.textContent, this.config);
  //
  @override
  InlineSpan build() {
    final content = attributes['content'] ?? '';
    final isInline = attributes['isInline'] == 'true';
    final style = parentStyle ?? config.p.textStyle;
    if (content.isEmpty) return TextSpan(style: style, text: textContent);
    final latex = Math.tex(
      content,
      mathStyle: MathStyle.text,
      settings: const TexParserSettings(maxExpand: 2000),
      // textStyle: TextStyle(),
      // textStyle: style.copyWith(color: isDark ? Colors.white : Colors.black),
      textScaleFactor: 1,
      onErrorFallback: (error) {
        return Text(
          textContent,
          style: style.copyWith(color: Colors.red),
        );
      },
    );
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: !isInline
          ? Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: latex),
            )
          : latex,
    );
  }
}
