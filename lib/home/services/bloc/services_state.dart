part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<Service> services;

  const ServicesLoaded(this.services);

  @override
  List<Object> get props => [services];
}

class ServicesError extends ServicesState {
  final String error;

  const ServicesError(this.error);

  @override
  List<Object> get props => [error];
}
