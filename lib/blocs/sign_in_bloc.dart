
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(super.initialState) {
    on<SignInButtonPressed>(
      (event, state) async {
        try {
          emit(SignInLoading());
          await firebaseAuth
              .signInWithEmailAndPassword(
                  email: event.email.trim(), password: event.password)
              .then((value) {
            emit(SignInSuccess());
          });
        } on FirebaseAuthException catch (e) {
          emit(SignInFailure(error: 'Wrong E-mail or Password'));
        } catch (e) {
          emit(SignInFailure(error: 'Something went wrong.'));
        }
      },
    );
  }
}

//Sign In Events
abstract class SignInEvent {}

class SignInButtonPressed extends SignInEvent {
  final String email;
  final String password;

  SignInButtonPressed({
    required this.email,
    required this.password,
  });
}

//Sign In States
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {
  final String error;

  SignInFailure({required this.error});
}
