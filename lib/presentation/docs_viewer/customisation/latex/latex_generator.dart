import 'package:markdown/markdown.dart';
import 'package:markdown_widget/markdown_widget.dart';

/// A customised [SpanNodeGenerator] for LaTex.
/// Return latex tagged nodes
class LatexGenerator extends SpanNodeGeneratorWithTag {
  static final latexTag = 'latex';
  LatexGenerator({required super.tag, required super.generator});

  factory LatexGenerator.latex(
      {required SpanNode Function(Element, MarkdownConfig, WidgetVisitor)
          generator}) {
    return LatexGenerator(
      tag: latexTag,
      generator: generator,
    );
  }
}
