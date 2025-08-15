import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/views/Nft/ChipFilter/bloc.dart';


class ChipFilterBar extends StatelessWidget {
  final List<Map<String, dynamic>> filters = [
    {"icon": Icons.layers_outlined, "label": "Blockchain"},
    {"icon": Icons.grid_view_outlined, "label": "Category"},
    {"icon": Icons.library_books_outlined, "label": "Collections"},
    {"icon": Icons.trending_up, "label": "Trending"},
    {"icon": Icons.new_releases, "label": "New"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChipFilterBloc, ChipFilterState>(
      builder: (context, state) {
        return SizedBox(
  height: 35, // kam height
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    itemCount: filters.length,
    separatorBuilder: (_, __) => const SizedBox(width: 6),
    itemBuilder: (context, index) {
      final isSelected = state.selectedIndex == index;
      return GestureDetector(
        onTap: () {
          context.read<ChipFilterBloc>().add(ChipSelected(index));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // kam padding
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                filters[index]["icon"],
                size: 16, // chhoti icon size
                color: isSelected ? Colors.white : Colors.black87,
              ),
              const SizedBox(width: 4),
              Text(
                filters[index]["label"],
                style: TextStyle(
                  fontSize: 12, // chhoti text size
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
);
      },
    );
  }
}
