import 'dart:async';
import 'package:e2t1m0t0r_frontend/dashboard/dashboard.dart';
import 'package:e2t1m0t0r_frontend/l10n/l10n.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appBarTitle)),
      body: const Center(child: EstimatingArea()),
    );
  }
}

class EstimatingArea extends StatelessWidget {
  const EstimatingArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        EstimateText(),
        EstimateButton(),
      ],
    );
  }
}

class EstimateText extends StatelessWidget {
  const EstimateText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final seconds = context.select<DashboardCubit, int>((cubit) => cubit.state);
    final hours = seconds.toDouble() / 3600;
    return Text(
      seconds > 0 ? '${hours.toStringAsFixed(2)} hours' : l10n.beforeEstimationInfo,
      style: theme.textTheme.bodyMedium,
    );
  }
}

class EstimateButton extends StatelessWidget {
  const EstimateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _onPressed(context.read<DashboardCubit>()),
      child: const Text('Estimate'),
    );
  }

  Future<void> _onPressed(DashboardCubit cubit) async {
    final picked = await FilePicker.platform.pickFiles();
    if (picked != null) {
      unawaited(cubit.processModel(picked.files.single.bytes!));
    } else {
      print('file null');
    }
  }
}
