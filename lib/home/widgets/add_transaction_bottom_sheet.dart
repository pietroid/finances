import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final valueInCents = int.parse(digits);
    final reais = valueInCents ~/ 100;
    final centavos = valueInCents % 100;
    final formatted =
        'R\$ ${reais.toString()},${centavos.toString().padLeft(2, '0')}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key, required this.category});

  final String category;

  static Future<void> show(BuildContext context, {required String category}) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => AddTransactionBottomSheet(category: category),
    );
  }

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    print(_controller.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.large,
        right: AppSpacing.large,
        top: AppSpacing.large,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.large,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.category, style: textTheme.headlineSmall),
          SizedBox(height: AppSpacing.medium),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [_CurrencyInputFormatter()],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'R\$ 0,00',
            ),
          ),
          SizedBox(height: AppSpacing.medium),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _onConfirm, child: Text('Confirm')),
          ),
        ],
      ),
    );
  }
}
