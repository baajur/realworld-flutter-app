import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realworld_flutter/api/model/new_user.dart';
import 'package:realworld_flutter/blocs/user/bloc.dart';
import 'package:realworld_flutter/helpers/form.dart';
import 'package:realworld_flutter/widgets/error_container.dart';
import 'package:realworld_flutter/widgets/rounded_button.dart';

class SignUpForm extends StatefulWidget {
  final String error;
  SignUpForm({this.error});
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _newUser = NewUser();
  UserBloc _userBloc;
  NewUserValidator _validator;

  @override
  void initState() {
    super.initState();

    _validator = NewUserValidator();

    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          if (widget.error != null)
            ErrorContainer(
              error: widget.error,
            ),
          createTextField(
            hintText: 'Your Name',
            // focusNode: _emailFocus,
            validator: _validator.validateUsername,
            onSaved: (String value) {
              setState(() {
                _newUser.username = value;
              });
            },
          ),
          const SizedBox(height: 16),
          createTextField(
            // focusNode: _emailFocus,
            hintText: 'Email',
            autovalidate: false,
            keyboardType: TextInputType.emailAddress,
            validator: _validator.validateEmail,
            onSaved: (String value) {
              setState(() {
                _newUser.email = value;
              });
            },
          ),
          const SizedBox(height: 16),
          createTextField(
            hintText: 'Password',
            autovalidate: false,
            obscureText: true,
            // focusNode: _passwordFocus,
            onChanged: (String value) {
              _newUser.password = value;
            },
            validator: _validator.validatePassword,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: RoundedButton(
              text: 'Sign Up',
              onPressed: _signUp,
            ),
          ),
        ],
      ),
    );
  }

  void _signUp() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _userBloc.dispatch(SignUpEvent(_newUser));
    }
  }
}
