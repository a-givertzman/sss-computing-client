import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:sss_computing_client/core/models/resource/resource.dart';
import 'package:sss_computing_client/core/models/text_file_stream/text_file_stream.dart';
import 'package:sss_computing_client/core/widgets/async_widget_builder/stream_widget_builder.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/block_quote/block_alert.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/block_quote/custom_block_quote_node.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/custom_img_node.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/custom_node.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/latex/latex_node.dart';
import 'package:sss_computing_client/presentation/docs_viewer/customisation/latex/latex_syntax.dart';
///
/// Viewer widget for markdown docs
class ViewerWidget extends StatefulWidget {
  const ViewerWidget({super.key, required this.paths});
  /// Paths to markdown files.
  final List<String> paths;
  ///
  @override
  State<ViewerWidget> createState() => _ViewerWidgetState();
}
///
class _ViewerWidgetState extends State<ViewerWidget> {
  @override
  void initState() {
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    return StreamBuilderWidget<String>(
      stream: TextFileStream.assets(widget.paths).create(),
      caseData: (context, data, __) {
        return _BuildBody(data: data);
      },
    );
  }
}
///
class _BuildBody extends StatefulWidget {
  const _BuildBody({required this.data});
  /// Markdown data.
  final String data;
  ///
  @override
  State<_BuildBody> createState() => __BuildBodyState();
}

class __BuildBodyState extends State<_BuildBody> {
  late TocController _tocController;
  @override
  void initState() {
    _tocController = TocController();
    super.initState();
  }
  ///
  @override
  void dispose() {
    _tocController.dispose();
    super.dispose();
  }
  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MarkdownWidget(
              data: widget.data,
              tocController: _tocController,
              config: MarkdownConfig(
                configs: [
                  // TableConfig(
                  //   defaultColumnWidth: FlexColumnWidth(),
                  //   //     IntrinsicColumnWidth(
                  //   //   flex: 1,
                  //   // ),
                  // ),
                  BlockquoteConfig(
                    textColor: theme.primaryColor,
                    sideColor: theme.primaryColor,
                  ),
                  LinkConfig(
                    onTap: (url) async {
                      Resource.fromUrl(url, context).launch();
                    },
                  ),
                ],
              ),
              markdownGenerator: MarkdownGenerator(
                textGenerator: (node, config, visitor) =>
                    CustomTextNode(node.textContent, config, visitor),
                generators: [
                  SpanNodeGeneratorWithTag(
                    tag: MarkdownTag.blockquote.name,
                    generator: (e, config, visitor) {
                      return CustomBlockquoteNode(
                        config.blockquote,
                        visitor,
                        alert: BlockQuoteAlert.fromQuote(e.textContent),
                      );
                    },
                  ),
                  SpanNodeGeneratorWithTag(
                    tag: 'latex',
                    generator: (e, config, visitor) => LatexNode(
                      e.attributes,
                      e.textContent,
                      config,
                    ),
                  ),
                  SpanNodeGeneratorWithTag(
                    tag: MarkdownTag.img.name,
                    generator: (e, config, visitor) {
                      return CustomImgNode(e.attributes, config, visitor)
                          .build();
                    },
                  ),
                ],
                inlineSyntaxList: [
                  LatexSyntax(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    const Localized('On this page').v,
                    style: theme.textTheme.titleMedium,
                  ),
                  Expanded(
                    child: TocWidget(
                      controller: _tocController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
