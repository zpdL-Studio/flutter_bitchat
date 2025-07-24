// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// Generator: FlutterInheritedModelBuilder
// **************************************************************************

mixin $BitChatModel {
  void onInitState() {}

  void onDidUpdateWidget() {}

  void onDispose() {}

  void onDidChangeAppLifecycleState(AppLifecycleState state) {}
}

class BitChatInheritedModel extends StatefulWidget {
  static BitChatModel model(BuildContext context) {
    return maybeModel(context)!;
  }

  static BitChatModel? maybeModel(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<_BitChatInheritedModel>()
        ?.model;
  }

  static FlutterBitchatPermissionStatus? permissionStatusOf(
    BuildContext context,
  ) {
    return InheritedModel.inheritFrom<_BitChatInheritedModel>(
      context,
      aspect: 0,
    )?.permissionStatus;
  }

  const BitChatInheritedModel({super.key, required this.child});

  final Widget child;

  @override
  State<BitChatInheritedModel> createState() => _BitChatInheritedModelState();
}

class _$BitChatModel extends BitChatModel {
  StateSetter? _$setState;

  // ignore: unused_element
  void _setState(VoidCallback fn) {
    final setState = _$setState;
    if (setState == null) {
      fn();
      return;
    }
    setState(fn);
  }

  _$BitChatModel() : super._();

  @override
  set permissionStatus(FlutterBitchatPermissionStatus? value) {
    _setState(() => super.permissionStatus = value);
  }
}

class _BitChatInheritedModelState extends State<BitChatInheritedModel> {
  late final _$BitChatModel _model;

  @override
  void initState() {
    super.initState();
    _model = _$BitChatModel();
    _model.onInitState();
    _model._$setState = setState;
  }

  @override
  void dispose() {
    _model._$setState = null;
    _model.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BitChatInheritedModel(
      permissionStatus: _model.permissionStatus,
      model: _model,
      child: widget.child,
    );
  }
}

class _BitChatInheritedModel extends InheritedModel<int> {
  final FlutterBitchatPermissionStatus? permissionStatus;
  final _$BitChatModel model;

  const _BitChatInheritedModel({
    required this.permissionStatus,
    required this.model,
    required super.child,
  });

  @override
  bool updateShouldNotify(_BitChatInheritedModel oldWidget) {
    return permissionStatus != oldWidget.permissionStatus;
  }

  @override
  bool updateShouldNotifyDependent(
    _BitChatInheritedModel oldWidget,
    Set<int> dependencies,
  ) {
    if (dependencies.contains(0) &&
        permissionStatus != oldWidget.permissionStatus) {
      return true;
    }
    return false;
  }
}
