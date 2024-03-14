import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';
import 'package:sss_computing_client/presentation/cargo_details/widgets/table_view.dart';

class CargoTable extends StatefulWidget {
  final List<Cargo> _cargos;
  const CargoTable({super.key, required List<Cargo> cargos}) : _cargos = cargos;

  @override
  State<CargoTable> createState() => _CargoTableState();
}

class _CargoTableState extends State<CargoTable> {
  late final List<Cargo> cargos;
  late final DaviModel<Cargo> model;

  @override
  // ignore: long-method
  void initState() {
    cargos = widget._cargos;
    model = DaviModel(
      columns: [
        DaviColumn(
          name: 'No.',
          pinStatus: PinStatus.left,
          intValue: (cargo) => cargo.id,
        ),
        DaviColumn(
          grow: 2,
          name: 'Name',
          stringValue: (cargo) => cargo.name,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.name,
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            onSave: (name) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                name: name,
              );
              model.replaceRows(cargos);
            }),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'Weight [t]',
          doubleValue: (cargo) => cargo.weight,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.weight.toString(),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            onSave: (weight) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                weight: double.tryParse(weight),
              );
              model.replaceRows(cargos);
            }),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'VCG [m]',
          doubleValue: (cargo) => cargo.vcg,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.vcg.toString(),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            onSave: (vcg) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                vcg: double.tryParse(vcg),
              );
              model.replaceRows(cargos);
            }),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'LCG [m]',
          doubleValue: (cargo) => cargo.lcg,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.lcg.toString(),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            onSave: (lcg) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                lcg: double.tryParse(lcg),
              );
              model.replaceRows(cargos);
            }),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'TCG [m]',
          doubleValue: (cargo) => cargo.tcg,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.tcg.toString(),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            onSave: (tcg) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                tcg: double.tryParse(tcg),
              );
              model.replaceRows(cargos);
            }),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'X1 [m]',
          doubleValue: (cargo) => cargo.leftSideX,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.leftSideX.toString(),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            onSave: (leftSideX) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                leftSideX: double.tryParse(leftSideX),
              );
              model.replaceRows(cargos);
            }),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'X2 [m]',
          doubleValue: (cargo) => cargo.rightSideX,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.rightSideX.toString(),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            onSave: (rightSideX) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                rightSideX: double.tryParse(rightSideX),
              );
              model.replaceRows(cargos);
            }),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'Mf.sx [t∙m]',
          stringValue: (_) => '—',
        ),
        DaviColumn(
          grow: 1,
          name: 'Mf.sy [t∙m]',
          stringValue: (_) => '—',
        ),
      ],
      rows: cargos,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TableView<Cargo>(
      model: model,
    );
  }
}

class EditOnTapField extends StatefulWidget {
  final String initialValue;
  final Color textColor;
  final Color iconColor;
  final Function(String)? onSave;
  const EditOnTapField({
    super.key,
    required this.initialValue,
    required this.textColor,
    required this.iconColor,
    this.onSave,
  });

  @override
  State<EditOnTapField> createState() => _EditOnTapFieldState();
}

class _EditOnTapFieldState extends State<EditOnTapField> {
  bool _isActive = false;

  void _handleActivate() {
    setState(() {
      _isActive = true;
    });
  }

  void _handleDeactivate() {
    setState(() {
      _isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isActive
        ? TapRegion(
            onTapOutside: (_) => _handleDeactivate(),
            child: EditableInputField(
              textColor: widget.textColor,
              iconColor: widget.iconColor,
              onCancel: (_) => _handleDeactivate(),
              onSave: (value) {
                widget.onSave?.call(value);
                _handleDeactivate();
              },
              initialValue: widget.initialValue,
            ),
          )
        : MouseRegion(
            cursor: SystemMouseCursors.text,
            child: GestureDetector(
              onTap: () => _handleActivate(),
              child: Text(widget.initialValue),
            ),
          );
  }
}

class EditableInputField extends StatefulWidget {
  final String initialValue;
  final Color textColor;
  final Color iconColor;
  final Function(String)? onSave;
  final Function(String)? onCancel;
  const EditableInputField({
    super.key,
    required this.initialValue,
    required this.textColor,
    required this.iconColor,
    this.onSave,
    this.onCancel,
  });

  @override
  State<EditableInputField> createState() => _EditableInputFieldState();
}

class _EditableInputFieldState extends State<EditableInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: (value) => widget.onSave?.call(value),
              style: TextStyle(
                color: widget.textColor,
              ),
            ),
          ),
          SizedBox(
            width: IconTheme.of(context).size,
            height: IconTheme.of(context).size,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => widget.onSave?.call(_controller.text),
              child: Icon(
                Icons.done,
                color: widget.iconColor,
              ),
            ),
          ),
          SizedBox(
            width: IconTheme.of(context).size,
            height: IconTheme.of(context).size,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => widget.onCancel?.call(_controller.text),
              child: Icon(
                Icons.close,
                color: widget.iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// WidgetSpan subscriptedTextSpan(String text, Color color) {
//   return WidgetSpan(
//     child: Transform.translate(
//       offset: const Offset(0.0, 4.0),
//       child: Text(
//         text,
//         textScaler: const TextScaler.linear(0.5),
//         style: TextStyle(color: color),
//       ),
//     ),
//   );
// }
