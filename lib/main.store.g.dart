// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainStore on _MainStore, Store {
  Computed<Decimal>? _$totalAmountComputed;

  @override
  Decimal get totalAmount =>
      (_$totalAmountComputed ??= Computed<Decimal>(() => super.totalAmount,
              name: '_MainStore.totalAmount'))
          .value;

  late final _$terminalAmountAtom =
      Atom(name: '_MainStore.terminalAmount', context: context);

  @override
  Decimal get terminalAmount {
    _$terminalAmountAtom.reportRead();
    return super.terminalAmount;
  }

  @override
  set terminalAmount(Decimal value) {
    _$terminalAmountAtom.reportWrite(value, super.terminalAmount, () {
      super.terminalAmount = value;
    });
  }

  late final _$requestedAmountAtom =
      Atom(name: '_MainStore.requestedAmount', context: context);

  @override
  Decimal get requestedAmount {
    _$requestedAmountAtom.reportRead();
    return super.requestedAmount;
  }

  @override
  set requestedAmount(Decimal value) {
    _$requestedAmountAtom.reportWrite(value, super.requestedAmount, () {
      super.requestedAmount = value;
    });
  }

  late final _$moneyAmountAtom =
      Atom(name: '_MainStore.moneyAmount', context: context);

  @override
  Decimal get moneyAmount {
    _$moneyAmountAtom.reportRead();
    return super.moneyAmount;
  }

  @override
  set moneyAmount(Decimal value) {
    _$moneyAmountAtom.reportWrite(value, super.moneyAmount, () {
      super.moneyAmount = value;
    });
  }

  late final _$selectedValueIndexAtom =
      Atom(name: '_MainStore.selectedValueIndex', context: context);

  @override
  int? get selectedValueIndex {
    _$selectedValueIndexAtom.reportRead();
    return super.selectedValueIndex;
  }

  @override
  set selectedValueIndex(int? value) {
    _$selectedValueIndexAtom.reportWrite(value, super.selectedValueIndex, () {
      super.selectedValueIndex = value;
    });
  }

  late final _$modeAtom = Atom(name: '_MainStore.mode', context: context);

  @override
  String get mode {
    _$modeAtom.reportRead();
    return super.mode;
  }

  @override
  set mode(String value) {
    _$modeAtom.reportWrite(value, super.mode, () {
      super.mode = value;
    });
  }

  late final _$moneyValuesAtom =
      Atom(name: '_MainStore.moneyValues', context: context);

  @override
  ObservableList<Map<String, dynamic>> get moneyValues {
    _$moneyValuesAtom.reportRead();
    return super.moneyValues;
  }

  @override
  set moneyValues(ObservableList<Map<String, dynamic>> value) {
    _$moneyValuesAtom.reportWrite(value, super.moneyValues, () {
      super.moneyValues = value;
    });
  }

  late final _$calculatorSumAtom =
      Atom(name: '_MainStore.calculatorSum', context: context);

  @override
  Decimal get calculatorSum {
    _$calculatorSumAtom.reportRead();
    return super.calculatorSum;
  }

  @override
  set calculatorSum(Decimal value) {
    _$calculatorSumAtom.reportWrite(value, super.calculatorSum, () {
      super.calculatorSum = value;
    });
  }

  late final _$_MainStoreActionController =
      ActionController(name: '_MainStore', context: context);

  @override
  void refreshMoney(Decimal newSum) {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.refreshMoney');
    try {
      return super.refreshMoney(newSum);
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setupTerminalValue() {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.setupTerminalValue');
    try {
      return super.setupTerminalValue();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCalulatorSum() {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.setCalulatorSum');
    try {
      return super.setCalulatorSum();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleTerminalValueEdited() {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.toggleTerminalValueEdited');
    try {
      return super.toggleTerminalValueEdited();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setupRequestedValue() {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.setupRequestedValue');
    try {
      return super.setupRequestedValue();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleRequestedValueEdited() {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.toggleRequestedValueEdited');
    try {
      return super.toggleRequestedValueEdited();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setupControllerValue(TextEditingController controller, int number) {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.setupControllerValue');
    try {
      return super.setupControllerValue(controller, number);
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
terminalAmount: ${terminalAmount},
requestedAmount: ${requestedAmount},
moneyAmount: ${moneyAmount},
selectedValueIndex: ${selectedValueIndex},
mode: ${mode},
moneyValues: ${moneyValues},
calculatorSum: ${calculatorSum},
totalAmount: ${totalAmount}
    ''';
  }
}
