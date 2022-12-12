import 'package:flutter/material.dart';

List images = [
  'https://upload.wikimedia.org/wikipedia/en/d/d5/A-ha_take_on_me-1stcover.jpg',
  'https://upload.wikimedia.org/wikipedia/en/d/dd/Cheri_Cheri_Lady.jpg',
  'https://upload.wikimedia.org/wikipedia/en/6/63/Making_Love_Out_of_Nothing_at_All.jpg',
  'https://upload.wikimedia.org/wikipedia/en/5/52/Ballbreaker.jpg',
  'https://upload.wikimedia.org/wikipedia/en/4/48/Mamma_Mia_Intermezzo_No_1.jpg',
  'https://upload.wikimedia.org/wikipedia/en/e/ee/The_Beatles%27_While_My_Guitar_Gently_Weeps_sheet_music_cover.jpg',
  'https://upload.wikimedia.org/wikipedia/en/a/a8/Nw171.jpg',
  'https://upload.wikimedia.org/wikipedia/en/e/e3/Baby_Its_You_sheet_music.jpg',
  'https://upload.wikimedia.org/wikipedia/en/9/9a/Anythinggoes.jpeg',
];
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        body: IPod(),
      ),
    );
  }
}

class IPod extends StatefulWidget {
  @override
  State<IPod> createState() => _IPodState();
}

class _IPodState extends State<IPod> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.6);

  double currentPage = 0.0;

  @override
  void initState() {
    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Container(
          height: 300,
          color: Colors.black,
          child: PageView.builder(
              controller: _pageCtrl,
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              itemBuilder: (context, int currentIdx) {
                return AlbumCard(
                  color: Colors.accents[currentIdx],
                  currentIdx: currentIdx,
                  currentPage: currentPage,
                );
              }),
        ),
        Spacer(),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onPanUpdate: _panHandler,
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Stack(children: [
                    Container(
                      child: Text(
                        'MENU',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 36),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.fast_forward),
                        iconSize: 40,
                        onPressed: () => _pageCtrl.animateToPage(
                          (_pageCtrl.page! + 1).toInt(),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        ),
                      ),
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 30),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.fast_rewind),
                        iconSize: 40,
                        onPressed: () => _pageCtrl.animateToPage(
                          (_pageCtrl.page! - 1).toInt(),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 30),
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.play_arrow),
                          iconSize: 40,
                          onPressed: () {}),
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: 30),
                    ),
                  ]),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  void _panHandler(DragUpdateDetails d) {
    double radius = 150;
    bool onTop = d.localPosition.dy <= 150;
    bool onLeftSide = d.localPosition.dx <= 150;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panDown = !panUp;
    bool panRight = !panLeft;

    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    double rotationChange =
        (verticalRotation + horizontalRotation) * (d.delta.distance * 0.2);

    _pageCtrl.jumpTo(_pageCtrl.offset + rotationChange);
  }
}

class AlbumCard extends StatelessWidget {
  final Color color;
  final int currentIdx;
  final double currentPage;
  AlbumCard(
      {required this.color,
      required this.currentIdx,
      required this.currentPage});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double relativePosition = currentIdx - currentPage;

    return Container(
      width: 250,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003)
          ..scale((1 - relativePosition.abs()).clamp(0.2, 0.6) + 0.4)
          ..rotateY(relativePosition),
        alignment: relativePosition >= 0
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(images[currentIdx]),
            ),
          ),
        ),
      ),
    );
  }
}
