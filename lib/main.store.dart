import 'package:counter_2_0/constant.dart';
import 'package:counter_2_0/monye_class.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'main.store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  @observable
  Decimal terminalAmount = Decimal.zero;

  @observable
  Decimal requestedAmount = Decimal.zero;

  @observable
  Decimal moneyAmount = Decimal.zero;

  @observable
  int? selectedValueIndex;

  @observable
  String mode = EditMode.money;

  @observable
  ObservableList<Map<String, dynamic>> moneyValues =
      ObservableList<Map<String, dynamic>>();

  MoneyData moneyData = MoneyData();

  @computed
  Decimal get totalAmount => (terminalAmount + moneyAmount) - requestedAmount;

  TextEditingController terimnalController = TextEditingController();
  TextEditingController requestedValueController = TextEditingController();
  TextEditingController calculatorValueController =
      TextEditingController(text: "");

  @observable
  Decimal calculatorSum = Decimal.zero;

  void init(BuildContext context) {
    moneyValues = ObservableList.of(moneyData.moneyValues);
  }

  void selectNextValue() {
    if (selectedValueIndex != null) {
      selectedValueIndex = (selectedValueIndex! + 1) % moneyValues.length;
    }
  }

  void selectPreviousValue() {
    if (selectedValueIndex != null) {
      selectedValueIndex =
          (selectedValueIndex! - 1 + moneyValues.length) % moneyValues.length;
    }
  }

  @action
  void refreshMoney(Decimal newSum) {
    moneyAmount = newSum;
    moneyValues = ObservableList.of(moneyData.moneyValues);
  }

  @action
  void setupTerminalValue() {
    if (mode == EditMode.money) {
      terimnalController.text.isNotEmpty
          ? terminalAmount = Decimal.parse(terimnalController.text)
          : terminalAmount = Decimal.zero;
      terimnalController.text = terminalAmount.toStringAsFixed(2);
    }
  }

  @action
  void setCalulatorSum() {
    if (calculatorValueController.text.isNotEmpty) {
      var text = calculatorValueController.text;
      final parts = text.split("+");
      Decimal sum = Decimal.zero;

      for (var part in parts) {
        if (part.isNotEmpty) {
          sum += Decimal.tryParse(part) ?? Decimal.zero;
        }
      }
      calculatorSum = sum;
    } else {
      calculatorSum = Decimal.zero;
    }
  }

  @action
  void toggleTerminalValueEdited() {
    mode = mode == EditMode.terimnalValue
        ? EditMode.money
        : EditMode.terimnalValue;
  }

  @action
  void setupRequestedValue() {
    if (mode == EditMode.money) {
      requestedValueController.text.isNotEmpty
          ? requestedAmount = Decimal.parse(requestedValueController.text)
          : requestedAmount = Decimal.zero;

      requestedValueController.text = requestedAmount.toStringAsFixed(2);
    }
  }

  @action
  void toggleRequestedValueEdited() {
    mode =
        mode == EditMode.requestValue ? EditMode.money : EditMode.requestValue;
  }

  void showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Czyszczenie zawartości'),
          content: Text(
              'Czy chcesz wyczyścić całą zawartość? Tej operacji nie można cofnąć.',
              style: TextStyle(fontSize: 16, color: Colors.red)),
          actions: <Widget>[
            TextButton(
              child: Text('Nie',
                  style: TextStyle(
                    fontSize: 18,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Tak',
                  style: TextStyle(
                    fontSize: 18,
                  )),
              onPressed: () {
                moneyData.resetAllMoneyValue();
                refreshMoney(moneyData.totalSum);
                terminalAmount = Decimal.zero;
                requestedAmount = Decimal.zero;
                calculatorSum = Decimal.zero;
                calculatorValueController.clear();
                terimnalController.clear();
                requestedValueController.clear();
                selectedValueIndex = null;
                mode = EditMode.money;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSetupTerminalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Szybkie ustawianie'),
          content: Text('Ustaw obliczoną sumę jako:',
              style: TextStyle(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              child: Text('Anuluj', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Zadana', style: TextStyle(fontSize: 18)),
              onPressed: () {
                requestedValueController.text =
                    calculatorSum.toStringAsFixed(2);
                requestedAmount = calculatorSum;
                mode = EditMode.money;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: Text('Terminal', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  terimnalController.text = calculatorSum.toStringAsFixed(2);
                  terminalAmount = calculatorSum;
                  mode = EditMode.money;
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  bool checkActualMode(BuildContext context, String checkingMode) {
    if (mode == checkingMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              checkingMode == EditMode.terimnalValue
                  ? 'Najpierw zakończ edycję kwoty terminala - zatwierdź ponownym kliknięciem'
                  : "Najpierw zakończ edycję kwoty zadanej - zatwierdź ponownym kliknięciem",
              style: TextStyle(fontSize: 20, color: Colors.red)),
          duration: snackDuration,
        ),
      );
      return false;
    }
    return true;
  }

  bool isValidInput(String text, String newCharacter) {
    var maxFractionDigits = 2;
    var newText = text + newCharacter;
    final hasComma = text.contains('.');
    if (!hasComma) return true;
    if (newText.contains('+')) {
      final sectionParts = newText.split("+");
      final parts = sectionParts.last.split(".");

      final fractionDigits = parts.length > 1 ? parts[1].length : 0;
      return fractionDigits <= maxFractionDigits;
    } else {
      final parts = newText.split(".");
      final fractionDigits = parts.length > 1 ? parts[1].length : 0;
      return fractionDigits <= maxFractionDigits;
    }
  }

  Color setFieldColor(Decimal totalAmount) {
    if (totalAmount > Decimal.zero) {
      return Colors.green;
    } else if (totalAmount < Decimal.zero) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  String setFieldInfo(Decimal totalAmount) {
    if (totalAmount > Decimal.zero) {
      return "SUPERATA";
    } else if (totalAmount < Decimal.zero) {
      return "BRAK";
    } else {
      return "ZGODNY";
    }
  }

  @action
  void setupControllerValue(TextEditingController controller, int number) {
    if (isValidInput(controller.text, number.toString())) {
      controller.text += number.toString();
    }
  }
}
