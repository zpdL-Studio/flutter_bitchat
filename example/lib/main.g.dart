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

  void Function(Object e, StackTrace stackTrace)? asyncWorkerDefaultError;

  void asyncWorker(
    Future<void> Function() worker, [
    void Function(Object e, StackTrace stackTrace)? error,
  ]) => throw UnimplementedError('asyncWorker has not been implemented.');
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

  static bool asyncWorkingOf(BuildContext context) {
    return InheritedModel.inheritFrom<_BitChatInheritedModel>(
          context,
          aspect: 7,
        )?.asyncWorking ??
        false;
  }

  static FlutterBitchatPermissionStatus? permissionStatusOf(
    BuildContext context,
  ) {
    return InheritedModel.inheritFrom<_BitChatInheritedModel>(
      context,
      aspect: 0,
    )?.permissionStatus;
  }

  static String? nickNameOf(BuildContext context) {
    return InheritedModel.inheritFrom<_BitChatInheritedModel>(
      context,
      aspect: 1,
    )?.nickName;
  }

  static FlutterBitchatChannelData channelDataOf(BuildContext context) =>
      maybeChannelDataOf(context)!;

  static FlutterBitchatChannelData? maybeChannelDataOf(BuildContext context) {
    return InheritedModel.inheritFrom<_BitChatInheritedModel>(
      context,
      aspect: 2,
    )?.channelData;
  }

  static Map<String, Set<String>> channelMembersOf(BuildContext context) =>
      maybeChannelMembersOf(context)!;

  static Map<String, Set<String>>? maybeChannelMembersOf(BuildContext context) {
    return InheritedModel.inheritFrom<_BitChatInheritedModel>(
      context,
      aspect: 3,
    )?.channelMembers;
  }

  static List<String> connectedPeersOf(BuildContext context) =>
      maybeConnectedPeersOf(context)!;

  static List<String>? maybeConnectedPeersOf(BuildContext context) {
    return InheritedModel.inheritFrom<_BitChatInheritedModel>(
      context,
      aspect: 4,
    )?.connectedPeers;
  }

  static bool isConnectedOf(BuildContext context) =>
      maybeIsConnectedOf(context)!;

  static bool? maybeIsConnectedOf(BuildContext context) {
    return InheritedModel.inheritFrom<_BitChatInheritedModel>(
      context,
      aspect: 5,
    )?.isConnected;
  }

  static List<FlutterBitchatMessage> messagesOf(BuildContext context) =>
      maybeMessagesOf(context)!;

  static List<FlutterBitchatMessage>? maybeMessagesOf(BuildContext context) {
    return InheritedModel.inheritFrom<_BitChatInheritedModel>(
      context,
      aspect: 6,
    )?.messages;
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

  @override
  set nickName(String? value) {
    _setState(() => super.nickName = value);
  }

  @override
  set channelData(FlutterBitchatChannelData value) {
    _setState(() => super.channelData = value);
  }

  @override
  set channelMembers(Map<String, Set<String>> value) {
    _setState(() => super.channelMembers = value);
  }

  @override
  set connectedPeers(List<String> value) {
    _setState(() => super.connectedPeers = value);
  }

  @override
  set isConnected(bool value) {
    _setState(() => super.isConnected = value);
  }

  @override
  set messages(List<FlutterBitchatMessage> value) {
    _setState(() => super.messages = value);
  }

  int _$asyncWorkingCount = 0;

  bool get _asyncWorking => _$asyncWorkingCount > 0;

  @override
  void asyncWorker(
    Future<void> Function() worker, [
    void Function(Object e, StackTrace stackTrace)? error,
  ]) async {
    final asyncWorking = _asyncWorking;
    _$asyncWorkingCount++;
    if (_asyncWorking != asyncWorking) {
      try {
        _setState(() {});
      } catch (_) {}
    }
    try {
      await worker();
    } catch (e, stackTrace) {
      (error ?? asyncWorkerDefaultError)?.call(e, stackTrace);
    } finally {
      final asyncWorking = _asyncWorking;
      _$asyncWorkingCount--;
      if (_asyncWorking != asyncWorking) {
        try {
          _setState(() {});
        } catch (_) {}
      }
    }
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
      nickName: _model.nickName,
      channelData: _model.channelData,
      channelMembers: _model.channelMembers,
      connectedPeers: _model.connectedPeers,
      isConnected: _model.isConnected,
      messages: _model.messages,
      asyncWorking: _model._asyncWorking,
      model: _model,
      child: widget.child,
    );
  }
}

class _BitChatInheritedModel extends InheritedModel<int> {
  final FlutterBitchatPermissionStatus? permissionStatus;
  final String? nickName;
  final FlutterBitchatChannelData channelData;
  final Map<String, Set<String>> channelMembers;
  final List<String> connectedPeers;
  final bool isConnected;
  final List<FlutterBitchatMessage> messages;
  final bool asyncWorking;
  final _$BitChatModel model;

  const _BitChatInheritedModel({
    required this.permissionStatus,
    required this.nickName,
    required this.channelData,
    required this.channelMembers,
    required this.connectedPeers,
    required this.isConnected,
    required this.messages,
    required this.asyncWorking,
    required this.model,
    required super.child,
  });

  @override
  bool updateShouldNotify(_BitChatInheritedModel oldWidget) {
    return permissionStatus != oldWidget.permissionStatus ||
        nickName != oldWidget.nickName ||
        channelData != oldWidget.channelData ||
        channelMembers != oldWidget.channelMembers ||
        connectedPeers != oldWidget.connectedPeers ||
        isConnected != oldWidget.isConnected ||
        messages != oldWidget.messages ||
        asyncWorking != oldWidget.asyncWorking;
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
    if (dependencies.contains(1) && nickName != oldWidget.nickName) {
      return true;
    }
    if (dependencies.contains(2) && channelData != oldWidget.channelData) {
      return true;
    }
    if (dependencies.contains(3) &&
        channelMembers != oldWidget.channelMembers) {
      return true;
    }
    if (dependencies.contains(4) &&
        connectedPeers != oldWidget.connectedPeers) {
      return true;
    }
    if (dependencies.contains(5) && isConnected != oldWidget.isConnected) {
      return true;
    }
    if (dependencies.contains(6) && messages != oldWidget.messages) {
      return true;
    }
    if (dependencies.contains(7) && asyncWorking != oldWidget.asyncWorking) {
      return true;
    }
    return false;
  }
}
