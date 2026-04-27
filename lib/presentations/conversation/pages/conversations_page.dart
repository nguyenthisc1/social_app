import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/routes/app_routes.dart';
import 'package:social_app/core/utils/extensions.dart';
import 'package:social_app/core/widgets/in_app_status_wrapper.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_state.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_type.dart';
import 'package:social_app/features/user/application/cubit/user_cubit.dart';
import 'package:social_app/presentations/conversation/widgets/conversation_list_item.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationCubit, ConversationState>(
      builder: (context, state) {
        final userState = context.watch<UserCubit>().state;
        return InAppStatusWrapper(
          hasContent: state.conversations.isNotEmpty,
          isLoading: state.isLoading,
          errorMessage: state.errorMessage,
          loadingText: 'Loading conversations...',
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.conversations.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: 76,
              color: context.colorScheme.outline.withAlpha(30),
            ),
            itemBuilder: (context, index) {
              final conversation = state.conversations[index];
              final otherUserId = conversation.participantIds
                  .where((id) => id != state.currentUserId)
                  .firstOrNull;
              final otherUser = conversation.type == ConversationType.group
                  ? null
                  : (otherUserId == null
                        ? null
                        : userState.usersById[otherUserId]);

              return ConversationListItem(
                conversation: conversation,
                currentUserId: state.currentUserId,
                otherUser: otherUser,
                onTap: () =>
                    context.push('${AppRoutes.chat}/${conversation.id}'),
              );
            },
          ),
        );
      },
    );
  }
}
