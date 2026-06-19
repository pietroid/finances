import 'package:app_ui/app_ui.dart';
import 'package:finances/finance/bloc/finance_bloc.dart';
import 'package:finances/finance/models/transaction.dart' as finance;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      builder: (_) => BlocProvider.value(
        value: context.read<FinanceBloc>(),
        child: AddTransactionBottomSheet(category: category),
      ),
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
    final text = _controller.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    final value = int.parse(text) / 100;
    final transaction = finance.Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: widget.category,
      value: value,
      date: DateTime.now(),
      description: widget.category,
    );
    context.read<FinanceBloc>().add(FinanceTransactionAdded(transaction));
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
