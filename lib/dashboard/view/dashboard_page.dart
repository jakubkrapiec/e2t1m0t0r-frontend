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
            const ProgressIndicator()
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
    final l10n = context.l10n;
    final seconds = context.select<DashboardBloc, int>((bloc) => bloc.state.duration);
    final hours = seconds.toDouble() / 3600;
    return Text(
      seconds > 0 ? '${hours.toStringAsFixed(2)} ${l10n.hours}' : l10n.beforeEstimationInfo,
      style: theme.textTheme.bodyMedium,
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({super.key});

  @override
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> with TickerProviderStateMixin {
  static const _expectedWaitingTime = Duration(seconds: 30);

  var _progress = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        _progress = 1;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimens.XL * 3,
        child: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            width: Dimens.XL * 3 * _progress,
            height: Dimens.M,
            color: Theme.of(context).primaryColor,
            duration: _expectedWaitingTime,
          ),
        ),
      ),
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
    );
    if (picked != null && picked.files.single.bytes != null) {
      bloc.add(ProcessSingleModelEvent(picked.files.single.bytes!));
    }
  }
}
