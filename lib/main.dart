import 'package:counter_2_0/constant.dart';
import 'package:counter_2_0/main.store.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rozliczenia 3.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final MainStore _store = MainStore();

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    _store.init(context);

    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: appMainColor,
                child: Observer(builder: (context) {
                  return ListView.builder(
                    itemCount: _store.moneyValues.length,
                    itemBuilder: (context, index) {
                      final item = _store.moneyValues[index];
                      return _moneyValueItem(context, item, index);
                    },
                  );
                }),
              ),
            ),
            Expanded(
              flex: orientation == Orientation.portrait ? 2 : 1,
              child: Observer(builder: (context) {
                return Column(
                  children: [
                    screenField(context),
                    Spacer(),
                    Visibility(
                        visible: _store.mode == EditMode.calculator,
                        child: calculatorField()),
                    Visibility(
                      visible: _store.mode != EditMode.calculator,
                      child: Column(
                        children: [
                          requestedValueField(),
                          moneyField(),
                          terminalField(),
                          sumField(),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: orientation == Orientation.portrait,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: numpad(context),
                        )),
                  ],
                );
              }),
            ),
            Visibility(
                visible: orientation == Orientation.landscape,
                child: Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
                      child: numpad(context),
                    )
                  ],
                )))
          ],
        ),
      ),
    );
  }

  Widget numpad(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
          padding: EdgeInsets.all(5),
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            shrinkWrap: true,
            children: [
              ...[1, 2, 3].map((nb) => _buildNumberButton(context, nb)),
              _buildBackspaceButton(context),
              ...[4, 5, 6].map((nb) => _buildNumberButton(context, nb)),
              Visibility(
                  visible: _store.mode == EditMode.money,
                  replacement: Visibility(
                    visible: _store.mode == EditMode.calculator,
                    child: _buildIconButton(context, Icons.add, () {
                      var text = _store.calculatorValueController.text;
                      if (text.isNotEmpty && text[text.length - 1] != '+') {
                        _store.calculatorValueController.text += '+';
                        _store.setCalulatorSum();
                      }
                    }),
                  ),
                  child: _buildIconButton(
                      context, Icons.arrow_upward, _store.selectPreviousValue)),
              ...[7, 8, 9].map((nb) => _buildNumberButton(context, nb)),
              Visibility(
                visible: _store.mode == EditMode.money,
                replacement: Visibility(
                  visible: _store.mode == EditMode.calculator,
                  child: _buildIconButton(context, Icons.point_of_sale, () {
                    _store.showSetupTerminalDialog(context);
                  }, color: Colors.greenAccent),
                ),
                child: _buildIconButton(
                    context, Icons.arrow_downward, _store.selectNextValue),
              ),
              _buildDotButton(context),
              _buildNumberButton(context, 0),
              _buildCalculatoreButton(context),
              _buildClearButton(context),
            ],
          ));
    });
  }

  Widget screenField(BuildContext context) {
    return Observer(
        builder: (context) => Container(
              padding: EdgeInsets.all(16.0),
              child: Visibility(
                visible: _store.mode == EditMode.money,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _store.selectedValueIndex != null
                          ? 'Nominał: ${_store.moneyValues[_store.selectedValueIndex!]['value']} PLN\nIlość: ${_store.moneyValues[_store.selectedValueIndex!]['quantity']}'
                          : "",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget sumField() {
    return Observer(
        builder: (context) => Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color:
                      _store.setFieldColor(_store.totalAmount).withAlpha(100),
                  border: Border.all(
                      color: _store.setFieldColor(_store.totalAmount),
                      width: 3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'SUMA: ${_store.totalAmount.toStringAsFixed(2)} PLN\nSTAN: ${_store.setFieldInfo(_store.totalAmount)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ));
  }

  Widget moneyField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: const Color.fromARGB(255, 94, 230, 230).withAlpha(150),
      child: Observer(builder: (context) {
        var money = _store.moneyAmount.toStringAsFixed(2);
        TextEditingController moneyController =
            TextEditingController(text: money);
        return SizedBox(
          height: 40,
          child: TextField(
            controller: moneyController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: "Kasa",
                border: OutlineInputBorder(),
                suffixText: "PLN"),
            readOnly: true,
            enabled: true,
            canRequestFocus: false,
          ),
        );
      }),
    );
  }

  Widget calculatorField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.blue.withAlpha(150),
      child: Observer(builder: (context) {
        return Stack(children: [
          Column(
            children: [
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.2
                        : MediaQuery.of(context).size.height * 0.4,
                child: TextField(
                  maxLines: 10,
                  controller: _store.calculatorValueController,
                  decoration: InputDecoration(
                    labelText: "Podawaj kwoty i dodawaj +",
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  enabled: true,
                  canRequestFocus: false,
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
          Positioned(
            right: 8.0,
            bottom: 0.0,
            child: Text(
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              "= ${_store.calculatorSum.toStringAsFixed(2)} PLN",
            ),
          )
        ]);
      }),
    );
  }

  Widget terminalField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.orange.withAlpha(100),
      child: Observer(builder: (context) {
        return SizedBox(
          height: 40,
          child: TextField(
            controller: _store.terimnalController,
            decoration: InputDecoration(
                labelText: _store.terminalAmount > Decimal.zero
                    ? "Kwota terminala ${_store.mode == EditMode.terimnalValue ? "- edycja" : ""}"
                    : 'Terminal - kliknij by ustawić',
                border: OutlineInputBorder(),
                suffixText: "PLN"),
            readOnly: true,
            enabled: _store.mode != EditMode.calculator,
            canRequestFocus: false,
            onTap: () {
              if (_store.checkActualMode(context, EditMode.requestValue)) {
                _store.toggleTerminalValueEdited();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        _store.mode == EditMode.terimnalValue
                            ? 'Podaj kwotę terminala i zatwierdź ponownym kliknięciem'
                            : "Terminal zatwierdzony",
                        style: TextStyle(fontSize: 20, color: Colors.green)),
                    duration: snackDuration,
                  ),
                );
                _store.setupTerminalValue();
              }
            },
          ),
        );
      }),
    );
  }

  Widget requestedValueField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.yellow.withAlpha(100),
      child: Observer(builder: (context) {
        return SizedBox(
          height: 40,
          child: TextField(
            controller: _store.requestedValueController,
            decoration: InputDecoration(
                labelText: _store.requestedAmount > Decimal.zero
                    ? "Kwota zadana ${_store.mode == EditMode.requestValue ? "- edycja" : ""}"
                    : 'Zadana - kliknij by ustawić',
                border: OutlineInputBorder(),
                suffixText: "PLN"),
            canRequestFocus: false,
            readOnly: true,
            enabled: _store.mode != EditMode.calculator,
            onTap: () {
              if (_store.checkActualMode(context, EditMode.terimnalValue)) {
                _store.toggleRequestedValueEdited();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        _store.mode == EditMode.requestValue
                            ? 'Podaj kwotę zadaną i zatwierdź ponownym kliknięciem'
                            : "Zada zatwierdzona",
                        style: TextStyle(fontSize: 20, color: Colors.green)),
                    duration: snackDuration,
                  ),
                );
                _store.setupRequestedValue();
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildDotButton(BuildContext context) {
    return Observer(builder: (context) {
      return Visibility(
        visible: _store.mode != EditMode.money,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(80),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            child: Center(child: Text('.', style: TextStyle(fontSize: 24))),
            onTap: () {
              switch (_store.mode) {
                case EditMode.terimnalValue:
                  if (!_store.terimnalController.text.contains('.')) {
                    _store.terimnalController.text += '.';
                  }
                case EditMode.requestValue:
                  if (!_store.requestedValueController.text.contains('.')) {
                    _store.requestedValueController.text += '.';
                  }
                case EditMode.calculator:
                  var text = _store.calculatorValueController.text;
                  if (text.isNotEmpty && !text.split("+").last.contains(".")) {
                    _store.calculatorValueController.text += '.';
                  }
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buildNumberButton(BuildContext context, int number) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(80),
          shape: BoxShape.circle,
        ),
        child: InkWell(
          child: Center(child: Text('$number', style: TextStyle(fontSize: 24))),
          onTap: () {
            switch (_store.mode) {
              case EditMode.terimnalValue:
                _store.setupControllerValue(_store.terimnalController, number);

              case EditMode.requestValue:
                _store.setupControllerValue(
                    _store.requestedValueController, number);

              case EditMode.calculator:
                _store.setupControllerValue(
                    _store.calculatorValueController, number);
                _store.setCalulatorSum();

              default:
                _store.moneyData
                    .updateQuantity(number, _store.selectedValueIndex);
                _store.refreshMoney(_store.moneyData.totalSum);
            }
          },
        ));
  }

  Widget _buildClearButton(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(220),
          shape: BoxShape.circle,
        ),
        child: InkWell(
          child: Center(child: Icon(Icons.refresh, size: 28)),
          onTap: () {
            _store.showClearConfirmationDialog(context);
          },
        ));
  }

  Widget _buildBackspaceButton(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(80),
          shape: BoxShape.circle,
        ),
        child: InkWell(
          child: Icon(Icons.backspace_outlined, size: 28),
          onTap: () {
            switch (_store.mode) {
              case EditMode.terimnalValue:
                if (_store.terimnalController.text.isNotEmpty) {
                  _store.terimnalController.text = _store
                      .terimnalController.text
                      .substring(0, _store.terimnalController.text.length - 1);
                }

              case EditMode.requestValue:
                if (_store.requestedValueController.text.isNotEmpty) {
                  _store.requestedValueController.text =
                      _store.requestedValueController.text.substring(
                          0, _store.requestedValueController.text.length - 1);
                }

              case EditMode.calculator:
                if (_store.calculatorValueController.text.isNotEmpty) {
                  _store.calculatorValueController.text =
                      _store.calculatorValueController.text.substring(
                          0, _store.calculatorValueController.text.length - 1);
                }
                _store.setCalulatorSum();

              default:
                _store.moneyData.removeLastDigit(_store.selectedValueIndex);
                _store.refreshMoney(_store.moneyData.totalSum);
            }
          },
          onLongPress: () {
            switch (_store.mode) {
              case EditMode.terimnalValue:
                if (_store.terimnalController.text.isNotEmpty) {
                  _store.terimnalController.text = "";
                }

              case EditMode.requestValue:
                if (_store.requestedValueController.text.isNotEmpty) {
                  _store.requestedValueController.text = "";
                }

              case EditMode.calculator:
                if (_store.calculatorValueController.text.isNotEmpty) {
                  _store.calculatorValueController.text = "";
                  _store.calculatorSum = Decimal.zero;
                }
            }
          },
        ));
  }

  Widget _buildCalculatoreButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(80),
        shape: BoxShape.circle,
      ),
      child: InkWell(
          child: Center(child: Icon(Icons.calculate, size: 28)),
          onTap: () {
            if (_store.checkActualMode(context, EditMode.requestValue) &&
                _store.checkActualMode(context, EditMode.terimnalValue)) {
              _store.selectedValueIndex = null;
              _store.mode = _store.mode == EditMode.calculator
                  ? EditMode.money
                  : EditMode.calculator;
            }
          }),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, Function action,
      {Color? color}) {
    return Container(
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primary.withAlpha(80),
          shape: BoxShape.circle,
        ),
        child: InkWell(
            child: Center(child: Icon(icon, size: 28)), onTap: () => action()));
  }

  Widget _moneyValueItem(
      BuildContext context, Map<String, dynamic> item, int index) {
    return GestureDetector(
      onTap: () {
        if (_store.checkActualMode(context, EditMode.requestValue) &&
            _store.checkActualMode(context, EditMode.terimnalValue) &&
            _store.mode != EditMode.calculator) {
          if (_store.selectedValueIndex == index) {
            _store.selectedValueIndex = null;
          } else {
            _store.selectedValueIndex = index;
          }
        }
      },
      child: Observer(
          builder: (context) => Container(
                height: 40,
                margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.all(5),
                color: _store.selectedValueIndex == index
                    ? Colors.blue[700]
                    : item['quantity'] > 0
                        ? const Color.fromARGB(255, 21, 231, 133)
                        : const Color.fromARGB(255, 69, 192, 192),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      '${item['value']} x ${item['quantity']} = ${(item['value'] * item['quantity']).toStringAsFixed(2)}',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: _store.selectedValueIndex == index
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              )),
    );
  }
}
