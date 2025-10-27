import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/home/services/model/service_model.dart';
import 'package:myapp/home/services/repository/services_repository.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository _servicesRepository;

  ServicesBloc(this._servicesRepository) : super(ServicesInitial()) {
    on<FetchServices>((event, emit) async {
      emit(ServicesLoading());
      try {
        final servicesData = await _servicesRepository.getServices();
        final services = (servicesData['services'] as List)
            .map((service) => Service.fromJson(service))
            .toList();
        emit(ServicesLoaded(services));
      } catch (e) {
        emit(ServicesError(e.toString()));
      }
    });
  }
}
