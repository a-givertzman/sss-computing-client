import 'package:markdown_widget/markdown_widget.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/svg_support.dart';

/// Custom node to support [SVG]s and images
///
/// Supports both local and remote [SVG]s
final class CustomImgNode {
  /// Attributes of the node like [src], [alt]
  final Map<String, String> attributes;

  /// [MarkdownConfig]
  final MarkdownConfig config;

  /// [WidgetVisitor]
  final WidgetVisitor visitor;

  CustomImgNode(this.attributes, this.config, this.visitor);

  SpanNode build() {
    final url = attributes['src'] ?? '';
    final attr = switch (url.startsWith('http')) {
      true => attributes,
      false => {
          'src': url.startsWith('/') ? url.replaceFirst('/', '') : '',
          'alt': attributes['alt'] ?? ''
        }
    };
    if (url.endsWith('.svg')) {
      return SvgNode(
        attributes: attr,
        config: config,
        width: 500,
      );
    }
    return ImageNode(attr, config, visitor);
  }
}
