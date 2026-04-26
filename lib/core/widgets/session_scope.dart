import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app/di/injection_container.dart';
import 'package:social_app/features/auth/application/bloc/auth_bloc.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';
import 'package:social_app/features/conversation/application/services/bardge-service/badge_service.dart';
import 'package:social_app/features/notification/application/cubit/notification_cubit.dart';
import 'package:social_app/features/user/application/cubit/user_cubit.dart';
import 'package:social_app/features/user/application/cubit/user_state.dart';

class SessionScope extends StatelessWidget {
  const SessionScope({
    super.key,
    required this.child,
    required this.isAuthenticated,
  });

  final Widget child;
  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          lazy: false,
          create: (_) {
            final cubit = sl<UserCubit>();
            if (isAuthenticated) {
              cubit.initializeSession();
            }
            return cubit;
          },
        ),
        BlocProvider<ConversationCubit>(
          lazy: false,
          create: (_) => sl<ConversationCubit>(),
        ),
        BlocProvider<NotificationCubit>(
          lazy: false,
          create: (_) => sl<NotificationCubit>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserCubit, UserState>(
            listenWhen: (previous, current) =>
                previous.profile?.id != current.profile?.id &&
                current.profile?.id != null,
            listener: (context, state) {
              final userId = state.profile?.id;
              if (userId != null) {
                context.read<ConversationCubit>().initializeSession(userId);
                context.read<NotificationCubit>().initialize(userId);
              }
            },
          ),

          BlocListener<ConversationCubit, ConversationState>(
            listenWhen: (previous, current) {
              return previous.conversations != current.conversations ||
                  previous.currentUserId != current.currentUserId;
            },
            listener: (context, state) async {
              // Fetch users participant when init
              final participantIds = state.conversations
                  .expand((conversation) => conversation.participantIds)
                  .where((id) => id != state.currentUserId)
                  .toSet()
                  .toList();

              if (participantIds.isNotEmpty) {
                context.read<UserCubit>().fetchUsersByIds(participantIds);
              }

              final badgeService = sl<BadgeService>();
              final conversationCubit = context.read<ConversationCubit>();
              final totalUnread = conversationCubit.getTotalUnreadCount(state);

              if (totalUnread <= 0) {
                await badgeService.clear();
                return;
              }

              await badgeService.updateCount(totalUnread);
            },
          ),

          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthUnauthenticated) {
                await sl<BadgeService>().clear();
              }
            },
          ),
        ],
        child: child,
      ),
    );
  }
}
