import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/block_quote/block_alert.dart';
///
///Tag: [MarkdownTag.blockquote]
///
/// A block quote marker, optionally preceded by up to three spaces of indentation
/// The custome blockquote node supports Alerts
class CustomBlockquoteNode extends ElementNode {
  final BlockquoteConfig _config;
  final WidgetVisitor _visitor;
  /// The alert
  final BlockQuoteAlert alert;
  CustomBlockquoteNode(this._config, this._visitor, {required this.alert});
  //
  @override
  TextSpan get childrenSpan {
    return TextSpan(
      children: children.map((e) {
        final span = e.build();
        return switch (alert.matchQuote(span.toPlainText())) {
          false => span,
          true => TextSpan(children: [
              _buildIcon(),
              TextSpan(
                style: span.style,
                text: alert.extractPureText(
                  span.toPlainText(),
                ),
              ),
            ])
        };
      }).toList(),
    );
  }
  //
  @override
  InlineSpan build() {
    return WidgetSpan(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: alert.color,
              width: _config.sideWith,
            ),
          ),
        ),
        padding: _config.padding,
        margin: _config.margin,
        child: ProxyRichText(
          childrenSpan,
          richTextBuilder: _visitor.richTextBuilder,
        ),
      ),
    );
  }
  //
  @override
  TextStyle? get style => TextStyle(color: _config.textColor).merge(parentStyle);
  //
  WidgetSpan _buildIcon() {
    return WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(bottom: _config.padding.left),
        child: Row(
          children: [
            Icon(
              alert.icon,
              color: alert.color,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              Localized(alert.name).v,
              style: TextStyle(
                color: alert.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
