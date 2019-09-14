import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realworld_flutter/api/model/update_user.dart';
import 'package:realworld_flutter/blocs/auth/bloc.dart';
import 'package:realworld_flutter/blocs/user_profile/bloc.dart';
import 'package:realworld_flutter/layout.dart';
import 'package:realworld_flutter/pages/settings.dart';
import 'package:realworld_flutter/screens/home.dart';
import 'package:realworld_flutter/widgets/scroll_page.dart';

class SettingsScreen extends StatefulWidget {
  static const String route = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AuthBloc _authBloc;
  UserProfileBloc _userProfileBloc;

  @override
  void initState() {
    super.initState();

    _authBloc = BlocProvider.of<AuthBloc>(context);
    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context)
      ..dispatch(LoadUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Layout(
      child: ScrollPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Your Settings',
                    style: theme.textTheme.title.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: BlocBuilder<UserProfileBloc, UserProfileState>(
                  builder: (BuildContext context, UserProfileState state) {
                if (state is UserProfileLoaded) {
                  return SettingsForm(
                    user: state.user,
                    onSave: _onSave,
                    onLogout: _onLogout,
                  );
                }

                return const CircularProgressIndicator();
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _onLogout() {
    _authBloc.dispatch(
      SignOutEvent(
        onComplete: () =>
            Navigator.of(context).pushReplacementNamed(HomeScreen.route),
      ),
    );
  }

  void _onSave(UpdateUser user) {
    _userProfileBloc.dispatch(UpdateUserProfileEvent(user));

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: const Text('Saving User')));
  }
}
