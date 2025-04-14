import 'package:equatable/equatable.dart';
import 'package:erp_app/bloc/auth_bloc/auth_event.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfile extends ProfileEvent {}

