import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:untitled/views/UserPortolio/repository/nft_repository.dart';

import '../../SaveUser/cubit/user_cubit.dart';
import '../../SaveUser/services/user_storage.dart';
import 'bloc/nft_bloc.dart';
import 'bloc/nft_event.dart';
import 'bloc/nft_state.dart';

class NFTScreen extends StatelessWidget {
   NFTScreen({super.key});
   Future<void> _onRefresh(BuildContext context) async {
     final user = context.read<UserCubit>().state;
     if (user == null) return;
     context.read<NFTBloc>().add(LoadNFTs(user.userId));
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.white10),
      body:  BlocBuilder<NFTBloc, NFTState>(
            builder: (context, state) {
              if (state is NFTLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NFTLoaded) {
                final nftResponse = state.nftResponse;

                if (nftResponse.data.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => _onRefresh(context),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 200.h),
                        Center(child: Text("No NFTs found", style: TextStyle(fontSize: 16.sp))),
                      ],
                    ),
                  );
                }

return RefreshIndicator(
  onRefresh: () => _onRefresh(context),
  child: SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: EdgeInsets.all(12.w),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height, // 🔑 This ensures full height
      ),
      child: Align( // 🔑 Important: replaces IntrinsicHeight
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your NFT portfolio",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  "\$${nftResponse.totalValue.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "${nftResponse.growthRate >= 0 ? '+' : ''}${nftResponse.growthRate.toStringAsFixed(2)}%",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: nftResponse.growthRate >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // keep this for inside scroll
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (1.sw / 1.8) / (1.sh * 0.35),
              ),
              itemCount: nftResponse.data.length,
              itemBuilder: (context, index) {
                final nft = nftResponse.data[index];
                return NFTCard(nft: nft);
              },
            ),
          ],
        ),
      ),
    ),
  ),
);

              } else if (state is NFTError) {
                return Center(child: Text(state.message, style: TextStyle(fontSize: 16.sp)));
              }
              return const SizedBox();
            },
          ),
    );
  }
}

class NFTCard extends StatelessWidget {
  final dynamic nft;
  const NFTCard({Key? key, required this.nft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = "https://dev.appezio.com/uploads/1741705923_hand-drawn-nft-style-ape-illustration_23-2149611051.jpg";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0.2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                imageUrl,
                height: 100.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 4.h),
            SmartTextByCharLength(
              text: nft.nftName,
              style: TextStyle(fontSize: 18.sp),
              maxChars: 7,
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price", style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                    Row(
                      children: [
                        Icon(Icons.monetization_on, color: Colors.green, size: 16.sp),
                        SizedBox(width: 2.w),
                        Text(
                          nft.amount,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Volume", style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                    Row(
                      children: [
                        Icon(Icons.monetization_on, color: Colors.green, size: 16.sp),
                        SizedBox(width: 2.w),
                        Text(
                          nft.amount,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SmartTextByCharLength extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxChars;

  const SmartTextByCharLength({
    super.key,
    required this.text,
    required this.style,
    this.maxChars = 20,
  });

  @override
  Widget build(BuildContext context) {
    final shouldScroll = text.length > maxChars;

    return SizedBox(
      height: (style.fontSize ?? 20).h * 1.5,
      child: shouldScroll
          ? Marquee(
        text: text,
        style: style,
        velocity: 25.0,
        blankSpace: 20.0,
        pauseAfterRound: const Duration(seconds: 1),
      )
          : Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}