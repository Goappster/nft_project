import 'package:equatable/equatable.dart';
import '../model/nft_model.dart';

abstract class NFTState {}

class NFTInitial extends NFTState {}

class NFTLoading extends NFTState {}

class NFTLoaded extends NFTState {
  final NFTModel nftResponse; // Now this is the full response

  NFTLoaded(this.nftResponse);
}

class NFTError extends NFTState {
  final String message;

  NFTError(this.message);
}
