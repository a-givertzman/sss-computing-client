import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;
import 'package:sss_computing_client/presentation/docs_viewer/customisation/html_support.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/svg_support.dart';
import 'package:sss_computing_client/presentation/docs_viewer/patterns/html_pattern.dart';
import 'package:sss_computing_client/presentation/docs_viewer/patterns/md_pattern.dart';
///
/// A customised [ElementNode] that supports HTML, SVG manipulations
class CustomTextNode extends ElementNode {
  final String _text;
  final MarkdownConfig _config;
  final WidgetVisitor _visitor;
  CustomTextNode(this._text, this._config, this._visitor);

  @override
  void onAccepted(SpanNode parent) {
    final textStyle = _config.p.textStyle.merge(parentStyle);
    children.clear();
    if (!HtmlPattern().isMatch(_text)) {
      accept(TextNode(text: _text, style: textStyle));
      return;
    }
    if (SVGPattern().isMatch(_text)) {
      accept(SvgRawNode(svg: _text));
      return;
    }
    final spans = HtmlSupport.parseHtml(
      m.Text(_text),
      visitor: WidgetVisitor(
        config: _visitor.config,
        generators: _visitor.generators,
        richTextBuilder: _visitor.richTextBuilder,
      ),
      parentStyle: parentStyle,
    );
    for (var element in spans) {
      accept(element);
    }
  }
}
