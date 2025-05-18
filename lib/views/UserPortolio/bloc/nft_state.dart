import 'package:equatable/equatable.dart';
import '../model/nft_model.dart';

abstract class NFTState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NFTInitial extends NFTState {}

class NFTLoading extends NFTState {}

class NFTLoaded extends NFTState {
  final List<NFTModel> nfts;

  NFTLoaded(this.nfts);

  @override
  List<Object?> get props => [nfts];
}

class NFTError extends NFTState {
  final String message;

  NFTError(this.message);

  @override
  List<Object?> get props => [message];
}
