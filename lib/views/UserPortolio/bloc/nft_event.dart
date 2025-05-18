import 'package:equatable/equatable.dart';

abstract class NFTEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNFTs extends NFTEvent {
  final int userId;

  LoadNFTs(this.userId);

  @override
  List<Object?> get props => [userId];
}
