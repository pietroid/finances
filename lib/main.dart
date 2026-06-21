import 'package:firebase_core/firebase_core.dart';
import 'package:finances/finance/bloc/finance_bloc.dart';
import 'package:finances/finance/repository/firestore_finance_repository.dart';
import 'package:finances/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    RepositoryProvider(
      create: (_) => FirestoreFinanceRepository(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _limits = {"Básico": 2000.0, "Compras": 2000.0, "Lazer": 2000.0};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 0, 66, 7)),
      ),
      home: BlocProvider(
        create: (context) => FinanceBloc(
          repository: context.read<FirestoreFinanceRepository>(),
          limits: _limits,
        )..add(FinanceSubscriptionRequested()),
        child: const HomePage(),
      ),
    );
  }
}
