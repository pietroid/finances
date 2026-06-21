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
      isScrollControlled: true,
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
  final _valueController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _valueController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onConfirm() {
    final text = _valueController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    final value = int.parse(text) / 100;
    final description = _descriptionController.text.trim();
    final transaction = finance.Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: widget.category,
      value: value,
      date: _selectedDate,
      description: description.isEmpty ? widget.category : description,
    );
    context.read<FinanceBloc>().add(FinanceTransactionAdded(transaction));
    Navigator.of(context).pop();
  }

  String _dateLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final diff = today.difference(dateOnly).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${dateOnly.day.toString().padLeft(2, '0')}/${dateOnly.month.toString().padLeft(2, '0')}/${dateOnly.year}';
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
            controller: _valueController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => _descriptionFocusNode.requestFocus(),
            inputFormatters: [_CurrencyInputFormatter()],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'R\$ 0,00',
            ),
          ),
          SizedBox(height: AppSpacing.medium),
          TextField(
            controller: _descriptionController,
            focusNode: _descriptionFocusNode,
            textInputAction: TextInputAction.done,
            onEditingComplete: _onConfirm,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Description',
            ),
          ),
          SizedBox(height: AppSpacing.medium),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(_dateLabel()),
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
