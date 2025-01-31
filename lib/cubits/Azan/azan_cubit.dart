import 'package:al_quran/models/azan_by_city/azan_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'data_provider.dart';

part 'azan_state.dart';

class AzanCubit extends Cubit<AzanState> {
  AzanCubit() : super(AzanInitial());
  Future<void> fetch({required String? latitude, required String? longitude}) async {
    emit( AzanFetchLoading());
    try {
    if(latitude==null ||longitude==null){
      emit(AzanFetchFailed());
    }else{
      final AzanModel data = await AzanDataProvider.azanFetchApi(latitude: latitude,longitude:longitude );
      emit(AzanFetchSuccess(azanData: data));
    }
    } catch (e) {
      print(e);
      emit(AzanFetchFailed());
    }
  }
}
