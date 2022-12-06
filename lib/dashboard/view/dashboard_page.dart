import 'dart:async';
import 'package:e2t1m0t0r_frontend/dashboard/bloc/dashboard_events.dart';
import 'package:e2t1m0t0r_frontend/dashboard/bloc/dashboard_state.dart';
import 'package:e2t1m0t0r_frontend/dashboard/dashboard.dart';
import 'package:e2t1m0t0r_frontend/l10n/l10n.dart';
import 'package:e2t1m0t0r_frontend/utils/dimens.dart';
import 'package:e2t1m0t0r_frontend/utils/gaps.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(),
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
    final bloc = context.watch<DashboardBloc>();
    return SizedBox(
      width: Dimens.XXL * 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const EstimateText(),
          HorizontalGaps.M,
          if (bloc.state.processingStage == DashboardProcessingStage.loading)
            const CircularProgressIndicator()
          else
            const EstimateButton(),
        ],
      ),
    );
  }
}

class EstimateText extends StatelessWidget {
  const EstimateText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondsMap = context
        .select<DashboardBloc, Map<String, int>>((bloc) => bloc.state.fileDurations)
        .map((name, duration) => MapEntry(name, duration.toDouble() / 3600));
    return Text(
      secondsMap.toString(),
      style: theme.textTheme.bodyMedium,
    );
  }
}

class EstimateButton extends StatelessWidget {
  const EstimateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextButton(
      onPressed: () => _onPressed(context.read<DashboardBloc>()),
      child: Text(l10n.estimate),
    );
  }

  Future<void> _onPressed(DashboardBloc bloc) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['stl'],
      allowMultiple: true,
    );
    if (picked != null) {
      bloc.add(ProcessModelsEvent(Map.fromEntries(picked.files.map((file) => MapEntry(file.name, file.bytes!)))));
    }
  }
}
