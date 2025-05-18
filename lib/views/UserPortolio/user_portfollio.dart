import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/views/UserPortolio/repository/nft_repository.dart';

import 'bloc/nft_bloc.dart';
import 'bloc/nft_event.dart';
import 'bloc/nft_state.dart';


class NFTScreen extends StatelessWidget {
  const NFTScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NFTBloc(NFTRepository())..add(LoadNFTs(67)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Your NFTs')),
        body: BlocBuilder<NFTBloc, NFTState>(
          builder: (context, state) {
            if (state is NFTLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NFTLoaded) {
              return ListView.builder(
                itemCount: state.nfts.length,
                itemBuilder: (context, index) {
                  final nft = state.nfts[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Text(nft.nftName[0].toUpperCase()),
                      ),
                      title: Text(nft.nftName),
                      subtitle: Text('Amount: \$${nft.amount}'),
                      trailing: Text(
                        nft.createdAt.split(' ').first,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              );
            } else if (state is NFTError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
