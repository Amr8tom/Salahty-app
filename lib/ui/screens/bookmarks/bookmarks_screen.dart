import 'package:al_quran/configs/app.dart';
import 'package:al_quran/configs/app_dimensions.dart';
import 'package:al_quran/configs/app_theme.dart';
import 'package:al_quran/configs/app_typography.dart';
import 'package:al_quran/cubits/bookmarks/cubit.dart';
import 'package:al_quran/providers/app_provider.dart';
import 'package:al_quran/ui/screens/surah/surah_index_screen.dart';
import 'package:al_quran/utils/assets.dart';
import 'package:al_quran/ui/widgets/button/app_back_button.dart';
import 'package:al_quran/ui/widgets/custom_image.dart';
import 'package:al_quran/ui/widgets/loader/loading_shimmer.dart';
import 'package:al_quran/ui/widgets/app/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../comman/AppBar.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  void initState() {
    final bookmarkCubit = BookmarkCubit.cubit(context);
    bookmarkCubit.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final bookmarkCubit = BookmarkCubit.cubit(context);

    return Scaffold(
      appBar: DAppBar(
        actions: [],
        enableGradient: false,
        bgColor: Colors.transparent,
        showBackArrow: true,
        title: "الإشارات المرجعية",
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027), // Deep Teal
              Color(0xFF203A43), // Teal
              Color(0xFF3A5963), // Teal
              Color(0xFFF3CA40), // Golden Yellow
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                child: BlocBuilder<BookmarkCubit, BookmarkState>(
                  builder: (context, state) {
                    if (state is BookmarkFetchLoading) {
                      return const Center(
                        child: LoadingShimmer(
                          text: 'Getting your bookmarks...',
                        ),
                      );
                    } else if (state is BookmarkFetchSuccess &&
                        state.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No Bookmarks yet!',
                          style: AppText.b1b!.copyWith(
                            color: AppTheme.c!.text,
                          ),
                        ),
                      );
                    } else if (state is BookmarkFetchSuccess) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Color(0xffee8f8b),
                        ),
                        itemCount: bookmarkCubit.state.data!.length,
                        itemBuilder: (context, index) {
                          final chapter = bookmarkCubit.state.data![index];
                          return SurahTile(
                            chapter: chapter,
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        state.message!,
                        style: AppText.b1b!.copyWith(
                          color: AppTheme.c!.text,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
