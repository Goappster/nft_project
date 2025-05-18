import 'package:flutter_bloc/flutter_bloc.dart';
import 'nft_event.dart';
import 'nft_state.dart';
import '../repository/nft_repository.dart';

class NFTBloc extends Bloc<NFTEvent, NFTState> {
  final NFTRepository repository;

  NFTBloc(this.repository) : super(NFTInitial()) {
    on<LoadNFTs>((event, emit) async {
      emit(NFTLoading());
      try {
        final nfts = await repository.fetchUserNFTs(event.userId);
        emit(NFTLoaded(nfts));
      } catch (e) {
        print("❌ Error loading NFTs: $e");
        emit(NFTError("Failed to load NFTs"));
      }
    });
  }
}
