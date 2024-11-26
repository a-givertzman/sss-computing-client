import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;
import 'package:sss_computing_client/presentation/docs_viewer/customisation/html_support.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/svg_support.dart';

/// A customised [ElementNode] that supports HTML, SVG manipulations
final class CustomTextNode extends ElementNode {
  final String text;
  final MarkdownConfig config;
  final WidgetVisitor visitor;

  CustomTextNode(this.text, this.config, this.visitor);

  @override
  void onAccepted(SpanNode parent) {
    final textStyle = config.p.textStyle.merge(parentStyle);
    children.clear();
    if (!text.contains(HtmlSupport.htmlRep)) {
      accept(TextNode(text: text, style: textStyle));
      return;
    }

    if (text.contains(HtmlSupport.svgReg)) {
      accept(SvgRawNode(svg: text));
      return;
    }

    final spans = HtmlSupport.parseHtml(
      m.Text(text),
      visitor: WidgetVisitor(
        config: visitor.config,
        generators: visitor.generators,
        richTextBuilder: visitor.richTextBuilder,
      ),
      parentStyle: parentStyle,
    );

    for (var element in spans) {
      accept(element);
    }
  }
}
