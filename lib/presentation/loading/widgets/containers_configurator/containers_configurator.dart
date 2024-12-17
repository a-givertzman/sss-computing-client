import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sss_computing_client/core/extensions/strings.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_containers.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/pg_stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection_iterate_extension.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
import 'package:sss_computing_client/presentation/container_cargo/container_cargo_page.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/bay_pair_indication.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/bay_pair_scheme.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/containers_table.dart';
///
/// Page to configure freight containers.
class ContainersConfigurator extends StatefulWidget {
  final PgStowageCollection _pgStowageCollection;
  final FreightContainers _freightContainersCollection;
  final List<FreightContainer> _containers;
  final List<Waypoint> _waypoints;
  final void Function() _refetchContainers;
  ///
  /// Creates page to configure freight containers.
  ///
  /// * [pgStowageCollection] - stowage plan collection stored in db, used to update associated [stowageCollection].
  /// * [freightContainersCollection] - collection of freight containers stored in db.
  /// * [containers] - list of containers to be configured.
  /// * [waypoints] - list of voyage waypoints that can be used as pol and pod for containers.
  /// * [refetchContainers] - callback to refresh containers list.
  const ContainersConfigurator({
    super.key,
    required PgStowageCollection pgStowageCollection,
    required FreightContainers freightContainersCollection,
    required List<FreightContainer> containers,
    required List<Waypoint> waypoints,
    required void Function() refetchContainers,
  })  : _pgStowageCollection = pgStowageCollection,
        _freightContainersCollection = freightContainersCollection,
        _containers = containers,
        _waypoints = waypoints,
        _refetchContainers = refetchContainers;
  //
  @override
  State<ContainersConfigurator> createState() => _ContainersConfiguratorState();
}
//
class _ContainersConfiguratorState extends State<ContainersConfigurator> {
  late final StowageCollection _stowagePlan;
  late final List<FreightContainer> _containers;
  late final List<Waypoint> _waypoints;
  late final ItemScrollController _bayPairsScrollController;
  late final ItemPositionsListener _bayPairsPositionsListener;
  late List<({int? odd, int? even, bool isThirtyFt})> _bayPairs;
  late List<Slot> _selectedSlots;
  late int? _selectedContainerId;
  //
  @override
  void initState() {
    _stowagePlan = widget._pgStowageCollection.stowageCollection;
    _containers = widget._containers;
    _waypoints = widget._waypoints;
    _bayPairsScrollController = ItemScrollController();
    _bayPairsPositionsListener = ItemPositionsListener.create();
    _bayPairs = _getBayPairs();
    _selectedSlots = [];
    _selectedContainerId = null;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Column(
        children: [
          Expanded(
            child: ScrollablePositionedList.separated(
              itemScrollController: _bayPairsScrollController,
              itemPositionsListener: _bayPairsPositionsListener,
              scrollDirection: Axis.horizontal,
              itemCount: _bayPairs.length,
              itemBuilder: (_, index) => BayPairScheme(
                oddBayNumber: _bayPairs[index].odd,
                evenBayNumber: _bayPairs[index].even,
                isThirtyFt: _bayPairs[index].isThirtyFt,
                slots: _stowagePlan.toFilteredSlotList(
                  shouldIncludeSlot: (slot) =>
                      (slot.bay == _bayPairs[index].odd ||
                          slot.bay == _bayPairs[index].even) &&
                      slot.isThirtyFt == _bayPairs[index].isThirtyFt,
                ),
                isFlyoverSlot: _isFlyoverSlot,
                shouldRenderEmptySlot: _filterSlotsByContainerSelected,
                onSlotTap: _onSlotSelected,
                onSlotDoubleTap: (bay, row, tier, isThirtyFt) {
                  _onSlotSelected(bay, row, tier, isThirtyFt);
                  _putSelectedContainer();
                },
                onSlotSecondaryTap: (bay, row, tier, isThirtyFt) {
                  _onSlotSelected(bay, row, tier, isThirtyFt);
                  _removeSelectedContainer();
                },
                selectedSlots: _selectedSlots
                    .where(
                      (s) =>
                          (s.bay == _bayPairs[index].odd ||
                              s.bay == _bayPairs[index].even) &&
                          s.isThirtyFt == _bayPairs[index].isThirtyFt,
                    )
                    .toList(),
              ),
              separatorBuilder: (_, __) => SizedBox(width: blockPadding),
            ),
          ),
          SizedBox(height: blockPadding),
          SizedBox(
            height: const Setting('scrollBarWidth', factor: 2).toDouble,
            child: Center(
              child: BayPairIndication(
                bayPairs: _bayPairs,
                bayPairsPositionsListener: _bayPairsPositionsListener,
                bayPairsScrollController: _bayPairsScrollController,
                stowagePlan: _stowagePlan,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.icon(
                onPressed: _handleUnloadAllContainers,
                icon: const Icon(Icons.clear_rounded),
                label: Text(const Localized('Clear bay plan').v),
              ),
              SizedBox(width: blockPadding),
              FilledButton.icon(
                onPressed:
                    _containers.isNotEmpty ? _handleDeleteAllContainers : null,
                icon: const Icon(Icons.delete_rounded),
                label: Text(const Localized('Delete all containers').v),
              ),
              SizedBox(width: blockPadding),
              const Spacer(),
              IconButton.filled(
                tooltip: const Localized('Add container').v,
                icon: const Icon(Icons.add_rounded),
                onPressed: _handleContainerAdd,
              ),
              SizedBox(width: blockPadding),
              IconButton.filled(
                tooltip: const Localized('Delete container').v,
                icon: const Icon(Icons.remove_rounded),
                onPressed: switch (_selectedContainerId) {
                  final int id => () => _handleContainerDelete(id),
                  _ => null,
                },
              ),
              SizedBox(width: blockPadding),
              IconButton.filled(
                tooltip: const Localized('Load container').v,
                icon: const Icon(Icons.file_download_outlined),
                onPressed:
                    (_selectedContainerId != null && _selectedSlots.isNotEmpty)
                        ? _putSelectedContainer
                        : null,
              ),
              SizedBox(width: blockPadding),
              IconButton.filled(
                tooltip: const Localized('Unload container').v,
                icon: const Icon(Icons.file_upload_outlined),
                onPressed: (_selectedSlots.isNotEmpty &&
                        _selectedSlots.any(
                          (s) => s.containerId != null,
                        ))
                    ? _removeSelectedContainer
                    : null,
              ),
            ],
          ),
          SizedBox(height: blockPadding),
          Expanded(
            child: ContainersTable(
              containers: _containers,
              waypoints: _waypoints,
              collection: _stowagePlan,
              selectedId: _selectedContainerId,
              onRowUpdate: _onTableRowUpdate,
              onRowTap: _toggleSelectedContainer,
              onRowDoubleTap: _scrollToContainerOnBayPairScheme,
            ),
          ),
        ],
      ),
    );
  }
  //
  List<({int? odd, int? even, bool isThirtyFt})> _getBayPairs() {
    final allBays = _stowagePlan.iterateBayPairs().toList();
    final resultBays = <({int? odd, int? even, bool isThirtyFt})>[];
    for (final bay in allBays) {
      final notThirtyFt = _stowagePlan.toFilteredSlotList(
        shouldIncludeSlot: (slot) =>
            (slot.bay == bay.odd || slot.bay == bay.even) && !slot.isThirtyFt,
      );
      final thirtyFt = _stowagePlan.toFilteredSlotList(
        shouldIncludeSlot: (slot) => slot.bay == bay.even && slot.isThirtyFt,
      );
      if (notThirtyFt.isNotEmpty) {
        resultBays.add((odd: bay.odd, even: bay.even, isThirtyFt: false));
      }
      if (thirtyFt.isNotEmpty) {
        resultBays.add((odd: null, even: bay.even, isThirtyFt: true));
      }
    }
    return resultBays;
  }
  //
  Slot? _findSlotWithContainerId(int? containerId) {
    return _stowagePlan
        .toFilteredSlotList(
          shouldIncludeSlot: (s) => s.containerId == containerId,
        )
        .firstOrNull;
  }
  //
  bool _isFlyoverSlot(Slot slot) {
    if (slot.containerId != null) return false;
    final upperSlot = _stowagePlan.findSlot(slot.bay, slot.row, slot.tier + 2);
    if (upperSlot == null || !upperSlot.isActive) return false;
    return true;
  }
  //
  void _handleContainerAdd() {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (context) => ContainerCargoPage(
          label: const Localized('Containers').v,
          onClose: navigator.pop,
          onSave: (container, number) async {
            switch (await widget._freightContainersCollection.addAll(
              List.generate(
                number,
                (_) => container,
              ),
            )) {
              case Ok():
                navigator.pop();
                widget._refetchContainers();
                return const Ok(null);
              case Err(:final error):
                _showErrorMessage(error.message);
                return Err(error);
            }
          },
        ),
        maintainState: false,
      ),
    );
  }
  //
  void _handleContainerDelete(int containerId) async {
    final isContainerLoaded = _stowagePlan
        .toFilteredSlotList(
          shouldIncludeSlot: (s) => s.containerId == containerId,
        )
        .isNotEmpty;
    if (isContainerLoaded) {
      _showErrorMessage(const Localized(
        'Cannot delete container that is loaded into slot',
      ).v);
      return;
    }
    switch (await widget._freightContainersCollection.removeById(
      containerId,
    )) {
      case Ok():
        _containers.removeWhere((c) => c.id == containerId);
        _selectedContainerId = null;
        setState(() {
          return;
        });
      case Err(:final error):
        const Log('Remove container').error(error);
        _showErrorMessage(error.message);
    }
  }
  //
  void _handleUnloadAllContainers() {
    widget._pgStowageCollection.removeAllContainers().then((result) {
      switch (result) {
        case Ok():
          if (mounted) {
            setState(() {
              return;
            });
          }
        case Err(:final error):
          const Log('Unload all containers').error(error);
          _showErrorMessage(error.message);
      }
    });
  }
  //
  void _handleDeleteAllContainers() {
    widget._freightContainersCollection.removeAll(_containers).then((result) {
      switch (result) {
        case Ok():
          if (mounted) {
            widget._refetchContainers();
          }
        case Err(:final error):
          const Log('Delete all containers').error(error);
          _showErrorMessage(error.message);
      }
    });
  }
  //
  void _onTableRowUpdate(newContainer, oldContainer) {
    widget._freightContainersCollection.update(newContainer, oldContainer).then(
      (result) {
        switch (result) {
          case Ok():
            final index = _containers.indexWhere(
              (c) => c.id == newContainer.id,
            );
            _containers[index] = newContainer;
            if (mounted) {
              setState(() {
                return;
              });
            }
          case Err(:final error):
            const Log('Update container').error(error);
            _showErrorMessage(error.message);
        }
      },
    );
  }
  //
  void _toggleSelectedContainer(FreightContainer container) {
    if (container.id == _selectedContainerId) {
      _selectedContainerId = null;
      setState(() {
        return;
      });
      return;
    }
    _onContainerSelected(container);
    setState(() {
      return;
    });
  }
  //
  void _scrollToContainerOnBayPairScheme(FreightContainer container) {
    final slotWithContainer = _findSlotWithContainerId(container.id);
    if (slotWithContainer == null) return;
    _onContainerSelected(container);
    final bayPairIndex = _bayPairs.indexWhere(
      (bayPair) =>
          (bayPair.odd == slotWithContainer.bay ||
              bayPair.even == slotWithContainer.bay) &&
          bayPair.isThirtyFt == slotWithContainer.isThirtyFt,
    );
    _bayPairsScrollController.scrollTo(
      index: bayPairIndex,
      duration: Duration(
        milliseconds: const Setting('animationDuration_ms').toInt,
      ),
      alignment: 0.5,
    );
  }
  //
  void _onContainerSelected(FreightContainer container) {
    _selectedContainerId = container.id;
    final slotWithContainer = _findSlotWithContainerId(container.id);
    if (slotWithContainer != null) {
      _onSlotSelected(
        slotWithContainer.bay,
        slotWithContainer.row,
        slotWithContainer.tier,
        slotWithContainer.isThirtyFt,
      );
    }
    setState(() {
      return;
    });
  }
  //
  void _onSlotSelected(int bay, int row, int tier, bool isThirtyFt) {
    _selectedSlots = _stowagePlan.toFilteredSlotList(
      row: row,
      tier: tier,
      shouldIncludeSlot: (slot) {
        if (bay.isOdd) {
          return (slot.bay == bay || slot.bay == bay - 1) &&
              slot.isThirtyFt == isThirtyFt;
        } else {
          return (slot.bay == bay || slot.bay == bay + 1) &&
              slot.isThirtyFt == isThirtyFt;
        }
      },
    );
    final containerIdInSlot = _selectedSlots
        .firstWhereOrNull((s) => s.containerId != null)
        ?.containerId;
    if (containerIdInSlot != null) _selectedContainerId = containerIdInSlot;
    setState(() {
      return;
    });
  }
  //
  void _putSelectedContainer() async {
    final container = _containers.firstWhereOrNull(
      (c) => c.id == _selectedContainerId,
    );
    if (container == null) return;
    final slotToPut = _selectedSlots
        .firstWhereOrNull((s) => switch (container.type.lengthCode) {
              4 => s.bay.isEven && !s.isThirtyFt && s.isActive,
              3 => s.bay.isEven && s.isThirtyFt && s.isActive,
              2 => s.bay.isOdd && !s.isThirtyFt && s.isActive,
              _ => false,
            });
    if (slotToPut == null) return;
    final putResult = await widget._pgStowageCollection.putContainer(
      container: container,
      bay: slotToPut.bay,
      row: slotToPut.row,
      tier: slotToPut.tier,
      isThirtyFt: slotToPut.isThirtyFt,
    );
    putResult.inspect((_) {
      _selectedSlots.clear();
      setState(() {
        return;
      });
    }).inspectErr((err) {
      _showErrorMessage('${err.message}');
      if (mounted) {
        _selectedSlots.clear();
        setState(() {
          return;
        });
      }
    });
  }
  //
  void _removeSelectedContainer() async {
    final slotToRemove =
        _selectedSlots.firstWhereOrNull((s) => s.containerId != null);
    if (slotToRemove == null) return;
    final removeResult = await widget._pgStowageCollection.removeContainer(
      bay: slotToRemove.bay,
      row: slotToRemove.row,
      tier: slotToRemove.tier,
      isThirtyFt: slotToRemove.isThirtyFt,
    );
    removeResult.inspect((_) {
      if (mounted) {
        setState(() {
          _selectedSlots.clear();
          return;
        });
      }
    }).inspectErr((err) {
      _showErrorMessage('${err.message}');
    });
  }
  //
  bool _filterSlotsByContainerSelected(Slot slot) {
    if (_selectedContainerId == null) return true;
    final selectedContainerType = _containers
        .firstWhereOrNull(
          (c) => c.id == _selectedContainerId,
        )
        ?.type;
    if (selectedContainerType == null) return true;
    return switch (selectedContainerType.lengthCode) {
      2 => (slot.bay.isOdd || slot.containerId != null) && !slot.isThirtyFt,
      3 => (slot.bay.isEven || slot.containerId != null) && slot.isThirtyFt,
      4 => (slot.bay.isEven || slot.containerId != null) && !slot.isThirtyFt,
      _ => false,
    };
  }
  //
  void _showErrorMessage(String message) {
    if (!mounted) return;
    BottomMessage.error(
      message: message.truncate(),
      displayDuration: Duration(
        milliseconds: const Setting('errorMessageDisplayDuration_ms').toInt,
      ),
    ).show(context);
  }
}
