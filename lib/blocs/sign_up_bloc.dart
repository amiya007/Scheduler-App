import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseFirestore _firestore;

  SignUpBloc({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        super(SignUpInitial()) {
    on<SignUpButtonPressed>(
      (event, emit) async {
        try {
          emit(SignUpLoading());

          //User Authentication
          final userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: event.email, password: event.password);

          //Save data To FIrestore
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': event.name,
            'email': event.email,
            'password': event.password,
          });
          emit(SignUpSuccess());
        } on FirebaseAuthException catch (e) {
          emit(SignUpFailure(error: e.message ?? 'Something went wrong.'));
        } catch (e) {
          emit(SignUpFailure(error: 'Something went wrong.'));
        }
      },
    );
  }
}

//Sign up Events
abstract class SignUpEvent {}

class SignUpButtonPressed extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  SignUpButtonPressed({
    required this.name,
    required this.email,
    required this.password,
  });
}

//Sign Up Sates
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure({required this.error});
}
