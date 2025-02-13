part of '../surah/surah_index_screen.dart';

class PageScreen extends StatefulWidget {
  final Juz? juz;
  final Chapter? chapter;

  const PageScreen({
    super.key,
    this.chapter,
    this.juz,
  });

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  Alignment _focalPoint = Alignment.center; // Initial focal point
  bool _isLightVisible = true; // Controls the light visibility

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final String firstVerses =
    (widget.chapter == null ? widget.juz!.ayahs! : widget.chapter!.ayahs!)
        .asMap()
        .entries
        .where((entry) => entry.key == 0)
        .map((entry) => "${entry.value?.text} (${entry.key + 1})")
        .join();

    final String allVerses =
    (widget.chapter == null ? widget.juz!.ayahs! : widget.chapter!.ayahs!)
        .asMap()
        .entries
        .where((entry) => entry.key > 0)
        .map((entry) => "${entry.value?.text} ﴿${entry.key + 1}﴾")
        .join(" ");

    return Scaffold(
      appBar: DAppBar(
        actions: [
          if (widget.juz == null)
            BlocBuilder<BookmarkCubit, BookmarkState>(
              builder: (context, state) {
                final bookmarkCubit = BookmarkCubit.cubit(context);
                return IconButton(
                  onPressed: () {
                    final isBookmarked = bookmarkCubit.state.isBookmarked!;
                    bookmarkCubit.updateBookmark(
                        widget.chapter!, !isBookmarked);
                  },
                  icon: Icon(
                    bookmarkCubit.state.isBookmarked!
                        ? Icons.bookmark_added
                        : Icons.bookmark_add_outlined,
                    color: Colors.white,
                  ),
                );
              },
            ),
          IconButton(
            onPressed: () {
              setState(() {
                _isLightVisible = !_isLightVisible; // Toggle light visibility
              });
            },
            icon: Icon(
              _isLightVisible ? Icons.lightbulb : Icons.lightbulb_outline,
              color: Colors.white,
            ),
          ),
        ],
        enableGradient: false,
        widgetTitle: Text(
          widget.chapter?.name ?? widget.juz?.number.toString() ?? "",
          style: AppText.h1b!.copyWith(
            fontFamily: 'Amiri',
            height: 1.5,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        bgColor: Colors.transparent,
        showBackArrow: true,
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onPanUpdate: (details) {
          if (_isLightVisible) {
            setState(() {
              final size = MediaQuery.of(context).size;
              _focalPoint = Alignment(
                (details.localPosition.dx / size.width) * 2 - 1,
                (details.localPosition.dy / size.height) * 2 - 1,
              );
            });
          }
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: _isLightVisible
                ? RadialGradient(
              focal: _focalPoint, // Dynamic focal point
              radius: 0.8,
              colors: [

                // Color(0xFFFFC107), // Bright Yellow
                Color(0xFF100D0D), // Bright Yellow

                Colors.black
              ],
            )
                : LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
                colors: [
                  // Color(0xFF0F2027), // Deep Teal (Top)
                  Color(0xFF203A43), // Dark Blue-Gray (Middle)
                  Color(0xFF203A43), // Dark Blue-Gray (Middle)
                ], // No gradient when light is off
          ),),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        firstVerses,
                        textAlign: firstVerses.length < 48
                            ? TextAlign.center
                            : TextAlign.right,
                        style: TextStyle(
                          // color: Color(0xFFFDF5E6), // Off-White for text
                          color: Color(0xFFBD9E63), // Off-White for text
                          fontFamily:
                          firstVerses.length < 48 ? 'Amiri' : 'Amiri',
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          height: 2.3,
                        ),
                      ),
                      Text(
                        allVerses,
                        textAlign: allVerses.length < 600
                            ? TextAlign.center
                            : TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFFBD9E63), // Off-White for text
                          // color: Color(0xFFFDF5E6), // Off-White for text
                          fontFamily: "Amiri",
                          // fontFamily: _isLightVisible?'Amiri':"Amiri",
                          fontSize: MediaQuery.of(context).size.height * 0.027,
                          height: 2.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
