part of '../surah_index_screen.dart';

class SurahTile extends StatelessWidget {
  final Chapter? chapter;

  const SurahTile({
    super.key,
    this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetAnimator(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PageScreen(
                chapter: chapter,
              ),
            ),
          );
        },
        onLongPress: () => showDialog(
          context: context,
          builder: (context) => _SurahInformation(
            chapterData: chapter,
          ),
        ),
        child: Padding(
          padding: Space.all(1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(chapter!.number!.toString(),style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),),
              Space.x1!,
              Space.x1!,
              Text(
                chapter!.englishName!,
                style: AppText.b1?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.amber,
                ),
              ),
              Expanded(
                child: Text(
                  chapter!.name!,
                  style: AppText.b1?.copyWith(
                    fontSize: 20,
                    fontFamily: "Amiri",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),                   textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
