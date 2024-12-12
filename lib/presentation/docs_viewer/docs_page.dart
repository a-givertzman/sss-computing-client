import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/accordion/accordion_items_builder.dart';
import 'package:sss_computing_client/core/models/accordion/accordion_model.dart';
import 'package:sss_computing_client/core/models/directory/directory_file.dart';
import 'package:sss_computing_client/core/models/directory/directory_info.dart';
import 'package:sss_computing_client/core/models/docs_manifest/doc_manifest.dart';
import 'package:sss_computing_client/core/widgets/accordion/accordion.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/docs_viewer/widgets/viewer.dart';

///
/// The page to render local [Mockdown] docs using [mardown_widget] library.
class MarkdownViewerPage extends StatelessWidget {
  /// Relative asset path to load
  final String relativePath;

  /// Current asset path
  final String? currentPath;
  const MarkdownViewerPage({
    super.key,
    this.relativePath = 'assets/docs/user-guide/ru',
    this.currentPath,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilderWidget(
        onFuture: LoadMarkdownInfo(
          MarkdownManifest(relativePath).loadAssets(),
        ).load,
        caseData: (_, assets, __) {
          return _BodyWidget(
            assets,
            currentAsset: currentPath,
          );
        },
      ),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget(this.assets, {this.currentAsset});

  /// List of assets paths
  final List<AssetsDirectoryInfo> assets;

  /// Current asset
  final String? currentAsset;

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  late MarkdownAccordionModel _markdownAccordion;
  @override
  void initState() {
    final items = AssetsAccordions(
      widget.assets,
      deep: 2,
    ).build();
    _markdownAccordion = MarkdownAccordionModel(items)
      ..initialiseCurrentItem(
        currentAsset: widget.currentAsset,
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          /// Navigation
          Expanded(
            child: AccordionWidget<List<String>>(
              current: _markdownAccordion.currentItem,
              items: _markdownAccordion.items,
              onSelected: (item) {
                setState(() {
                  _markdownAccordion.onItemSelected(item);
                });
              },
            ),
          ),
          VerticalDivider(
            color: Colors.grey.shade700,
          ),
          Expanded(
            flex: 3,
            child: ViewerWidget(
              paths: _markdownAccordion.currentAssets,
            ),
          ),
        ],
      ),
    );
  }
}
