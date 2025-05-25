import 'package:equatable/equatable.dart';

abstract class NFTEvent {}

class LoadNFTs extends NFTEvent {
  final int userId;

  LoadNFTs(this.userId);
}
