part of 'azan_cubit.dart';

@immutable
sealed class AzanState {}

final class AzanInitial extends AzanState {}

final class AzanFetchLoading extends AzanState {}

final class AzanFetchSuccess extends AzanState {
  final AzanModel azanData;

  AzanFetchSuccess({
    required this.azanData,
  });
}

final class AzanFetchFailed extends AzanState {}
