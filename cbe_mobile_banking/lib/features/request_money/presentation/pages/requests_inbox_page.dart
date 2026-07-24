import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/app/router/app_router.dart';
import 'package:cbe_mobile_banking/core/theme/app_colors.dart';
import 'package:cbe_mobile_banking/core/utils/money_formatter.dart';
import 'package:cbe_mobile_banking/core/widgets/app_empty_state.dart';
import 'package:cbe_mobile_banking/core/widgets/app_primary_button.dart';
import 'package:cbe_mobile_banking/core/widgets/app_secondary_button.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/incoming_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/requests_inbox_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Inbox for Home "N Requests → Proceed" (fills PDF IA gap).
class RequestsInboxPage extends StatelessWidget {
  const RequestsInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<RequestsInboxBloc>()..add(const RequestsInboxStarted()),
      child: const _RequestsInboxView(),
    );
  }
}

class _RequestsInboxView extends StatelessWidget {
  const _RequestsInboxView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plumDeep,
      appBar: AppBar(
        title: const Text('Requests'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<RequestsInboxBloc, RequestsInboxState>(
        builder: (context, state) {
          if (state is RequestsInboxLoading || state is RequestsInboxInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RequestsInboxFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  TextButton(
                    onPressed: () => context
                        .read<RequestsInboxBloc>()
                        .add(const RequestsInboxRefreshed()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is! RequestsInboxLoaded) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              Expanded(
                child: state.items.isEmpty
                    ? const AppEmptyState(
                        title: 'No pending requests',
                        subtitle:
                            'When someone asks you for money, it will show here.',
                      )
                    : RefreshIndicator(
                        color: AppColors.peach,
                        onRefresh: () async {
                          context
                              .read<RequestsInboxBloc>()
                              .add(const RequestsInboxRefreshed());
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                          itemCount: state.items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _IncomingRequestTile(
                              request: state.items[index],
                              onPay: () => context.push(AppRoutes.transfer),
                            );
                          },
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: AppPrimaryButton(
                  label: 'Request money',
                  icon: Icons.south_west,
                  onPressed: () => context.push(AppRoutes.requestMoney),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IncomingRequestTile extends StatelessWidget {
  const _IncomingRequestTile({
    required this.request,
    required this.onPay,
  });

  final IncomingRequestEntity request;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final initial =
        request.fromName.trim().isEmpty ? '?' : request.fromName.trim()[0];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.plum,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.peach.withValues(alpha: 0.18),
                child: Text(
                  initial.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.peach,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.fromName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.maskedAccount,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                MoneyFormatter.formatEtb(request.amountEtb),
                style: const TextStyle(
                  color: AppColors.peach,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            request.note,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          AppSecondaryButton(
            label: 'Pay',
            icon: Icons.north_east,
            onPressed: onPay,
          ),
        ],
      ),
    );
  }
}
