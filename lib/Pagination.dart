import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'ApiService.dart';

// Events
abstract class NftEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNfts extends NftEvent {}

// States
abstract class NftState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NftInitial extends NftState {}

class NftLoading extends NftState {}

class NftLoaded extends NftState {
  final List<Map<String, dynamic>> nfts;
  final bool hasMore;
  final String? nextPageKey;

  NftLoaded(this.nfts, this.hasMore, this.nextPageKey);

  @override
  List<Object?> get props => [nfts, hasMore, nextPageKey];
}

class NftError extends NftState {
  final String message;
  NftError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class NftBloc extends Bloc<NftEvent, NftState> {
  final NftService nftService;
  List<Map<String, dynamic>> nfts = [];
  String? nextPageKey;
  bool hasMore = true;

  NftBloc(this.nftService) : super(NftInitial()) {
    on<FetchNfts>((event, emit) async {
      if (!hasMore) return;

      emit(NftLoading());

      try {
        final response = await nftService.fetchCollections(pageKey: nextPageKey);

        final List<Map<String, dynamic>> newNfts = List<Map<String, dynamic>>.from(response['collections']);
        final String? newPageKey = response['next']; // Next page key

        if (newNfts.isNotEmpty) {
          nfts.addAll(newNfts);
          nextPageKey = newPageKey;
        } else {
          hasMore = false;
        }

        emit(NftLoaded(nfts, hasMore, nextPageKey));
      } catch (e) {
        emit(NftError(e.toString()));
      }
    });
  }
}
