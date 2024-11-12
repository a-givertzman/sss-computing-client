import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/pg_voyage_details.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/voyage_details.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/voyage_itinerary_table.dart';

///
/// The widget that displays the body of the voyage
/// e.g [VoyageItineraries] and [VoyageFlightDetails]
class VoyageBody extends StatelessWidget {
  ///
  const VoyageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: blockPadding),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(blockPadding),
                child: FutureBuilderWidget(
                  onFuture: PgVoyageDetails().fetchDetails,
                  caseData: (_, details, __) =>
                      VoyageDetailsWidget(details: details),
                ),
              ),
            ),
          ),
          SizedBox(height: blockPadding),
          Expanded(
            // flex: 3,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(blockPadding),
                child: FutureBuilderWidget(
                  onFuture: PgVoyageDetails().fetchItineraries,
                  caseData: (_, data, __) => VoyageItineraryTable(
                    itineraries: data,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
