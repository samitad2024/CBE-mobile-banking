import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

final class WalletStarted extends WalletEvent {
  const WalletStarted();
}

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

final class WalletInitial extends WalletState {
  const WalletInitial();
}

final class WalletLoading extends WalletState {
  const WalletLoading();
}

final class WalletLoaded extends WalletState {
  const WalletLoaded({
    required this.linkedWallets,
  });

  final List<String> linkedWallets;

  @override
  List<Object?> get props => [linkedWallets];
}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(const WalletInitial()) {
    on<WalletStarted>(_onStarted);
  }

  Future<void> _onStarted(
    WalletStarted event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());
    await Future<void>.delayed(const Duration(milliseconds: 200));
    emit(
      const WalletLoaded(
        linkedWallets: ['CBE Birr', 'Telebirr', 'M-Pesa'],
      ),
    );
  }
}
