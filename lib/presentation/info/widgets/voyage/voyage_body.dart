import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/voyage/pg_waypoints.dart';
import 'package:sss_computing_client/core/models/voyage/waypoints.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/models/voyage/pg_voyage_details.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/voyage_details.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/voyage_waypoints_table.dart';
///
/// The widget that displays the body of the voyage
/// e.g [VoyageItineraries] and [VoyageFlightDetails]
class VoyageBody extends StatefulWidget {
  ///
  const VoyageBody({super.key});
  //
  @override
  State<VoyageBody> createState() => _VoyageBodyState();
}
///
class _VoyageBodyState extends State<VoyageBody> {
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String _authToken;
  late final Waypoints _waypointsCollection;
  late final PgVoyageDetails _voyageDetailsCollection;
  //
  @override
  void initState() {
    _apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    _dbName = const Setting('api-database').toString();
    _authToken = const Setting('api-auth-token').toString();
    _waypointsCollection = PgWaypoints(
      apiAddress: _apiAddress,
      dbName: _dbName,
      authToken: _authToken,
    );
    _voyageDetailsCollection = PgVoyageDetails(
      apiAddress: _apiAddress,
      dbName: _dbName,
      authToken: _authToken,
    );
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: blockPadding),
      child: Column(
        children: [
          Expanded(
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(blockPadding),
                child: FutureBuilderWidget(
                  onFuture: _voyageDetailsCollection.fetch,
                  caseData: (_, details, refreshDetails) => VoyageDetailsWidget(
                    detailsCollection: _voyageDetailsCollection,
                    details: details,
                    onDetailsChange: refreshDetails,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: blockPadding),
          Expanded(
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(blockPadding),
                child: FutureBuilderWidget(
                  onFuture: _waypointsCollection.fetchAll,
                  caseData: (_, waypoints, __) => VoyageWaypointsTable(
                    waypoints: waypoints,
                    waypointsCollection: _waypointsCollection,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
