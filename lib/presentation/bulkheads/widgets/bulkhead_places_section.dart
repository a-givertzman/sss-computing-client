import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead_place.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkhead_place_widget.dart';
///
/// Widget displaying section of places for grain bulkhead.
class BulkheadPlacesSection extends StatelessWidget {
  final String _label;
  final double _bulkheadHeight;
  final List<BulkheadPlace> _bulkheadPlaces;
  final void Function(
    BulkheadPlace bulkheadPlace,
    int bulkheadI,
  )? _onBulkheadDropped;
  ///
  /// Creates widget displaying section of places for grain bulkhead.
  ///
  ///   [bulkhaedPlaces] – bulkhead places that will be displayed.
  ///   [onBulkheadDropped] – callback that will be called when
  /// bulkhead draggable widget is dropped and accepted by some place.
  const BulkheadPlacesSection({
    super.key,
    required String label,
    required double bulkheadHeight,
    required List<BulkheadPlace> bulkheadPlaces,
    void Function(BulkheadPlace, int)? onBulkheadDropped,
  })  : _label = label,
        _bulkheadHeight = bulkheadHeight,
        _bulkheadPlaces = bulkheadPlaces,
        _onBulkheadDropped = onBulkheadDropped;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    const placeholderMargin = 8.0;
    const placeholderPadding = 12.0;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: padding),
        SizedBox(
          height: _bulkheadHeight +
              placeholderMargin * 2.0 +
              placeholderPadding * 2.0,
          child: ListView.builder(
            itemCount: _bulkheadPlaces.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => BulkheadPlaceWidget(
              bulkheadPlace: _bulkheadPlaces[index],
              bulkheadId: switch (_bulkheadPlaces[index].bulkheadId) {
                final int id => id,
                _ => null,
              },
              bulkheadHeight: _bulkheadHeight,
              margin: placeholderMargin,
              padding: placeholderPadding,
              onBulkheadDropped: _onBulkheadDropped,
            ),
          ),
        ),
      ],
    );
  }
}
