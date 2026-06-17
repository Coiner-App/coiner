import 'package:coiner/core/widgets/fluid_app_bar.dart';
import 'package:coiner/features/account/domain/models/current_user.dart';
import 'package:coiner/features/authentication/presentation/state_providers/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatelessWidget {
  final CurrentUser user;
  const AccountScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: FluidAppBar(
        title: Text.rich(TextSpan(
              style: TextTheme.of(context).headlineLarge!.copyWith(fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Coiner', style: TextStyle(color: theme.colorScheme.primary)),
                TextSpan(text: 'Account'),
              ],
            ),
          ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _ProfileHeader(user: user),
              Padding(
                padding: const EdgeInsets.only(top: 28.0, bottom: 8.0),
                child: Container(
                  width: 48.0,
                  height: 2,
                  color: theme.colorScheme.secondary,
                ),
              ),
              _StatisticsCard(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: 32.0,
                  height: 2,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              _SettingsListCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsListCard extends ConsumerWidget {
  const _SettingsListCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.white.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: theme.colorScheme.secondary, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(4.0),
              child: const ListTile(
                leading: Icon(Icons.settings_outlined, size: 22),
                title: Text("Settings"),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 20,
                ),
              ),
              onTap: () => context.push('/settings'),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8.0),
              child: const ListTile(
                leading: Icon(Icons.forum_outlined, size: 22),
                title: Text("Socials"),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 20,
                ),
              ),
              onTap: () => print('Socials'),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8.0),
              child: const ListTile(
                leading: Icon(Icons.exit_to_app, size: 22),
                title: Text("Log out"),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 20,
                ),
              ),
              onTap: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false), 
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true), 
                          child: Text("Log Out", style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (shouldLogout == true) {
                  ref.read(authStateProvider.notifier).logout();
                }
              },
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8.0),
              child: const ListTile(
                leading: Icon(Icons.help_outline, size: 22),
                title: Text("Help"),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 20,
                ),
              ),
              onTap: () => 'help pressed',
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8.0),
              child: const ListTile(
                leading: Icon(Icons.info_outline, size: 22),
                title: Text("About"),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 20,
                ),
              ),
              onTap: () => print('about pressed'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: Colors.white.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        //side: const BorderSide(color: CColors.secondary, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () => null,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              //Icons.bar_chart_outlined,
              Icons.insert_chart_outlined,
              size: 26,
              color: theme.colorScheme.onSurface,
            ),
            title: Text("Statistics"),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 22,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final CurrentUser user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      //fit: StackFit.passthrough,
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.network(
            "https://c.tenor.com/qzrqCt-yRBQAAAAM/nyan-cat.gif",
            height: 192,
            width: 192,
          ),
        ),
        Positioned(
          bottom: -16.0,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 18.0,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: Text(
              user.displayName,
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
