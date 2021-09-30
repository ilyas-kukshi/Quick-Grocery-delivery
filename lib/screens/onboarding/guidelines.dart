import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quickgrocerydelivery/screens/onboarding/guideline_titles.dart';

class Guidelines extends StatefulWidget {
  const Guidelines({Key? key}) : super(key: key);

  @override
  _GuidelinesState createState() => _GuidelinesState();
}

class _GuidelinesState extends State<Guidelines> {
  List<String> guidelineImages = [
    'assets/images/guidelines/guideline1.png',
    'assets/images/guidelines/guideline2.png',
    'assets/images/guidelines/guideline3.png',
    'assets/images/guidelines/guideline4.png',
    'assets/images/guidelines/guideline5.png'
  ];
  PageController pageController = new PageController();
  int currentPageNo = 0;

  @override
  void initState() {
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized();
    // Firebase.initializeApp();
    if (FirebaseAuth.instance.currentUser != null) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        Navigator.popAndPushNamed(context, '/dashboardMain');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            child: PageView.builder(
                controller: pageController,
                onPageChanged: (page) {
                  setState(() {
                    currentPageNo = page;
                  });
                },
                itemCount: guidelineImages.length,
                itemBuilder: (context, page) {
                  return guideline(page);
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  if (currentPageNo == guidelineImages.length - 1) {
                    Navigator.pushNamed(context, '');
                  } else {
                    pageController.jumpToPage(++currentPageNo);
                  }
                },
                child: CircularPercentIndicator(
                  radius: 70,
                  percent: currentPageNo / 4,
                  progressColor: Color(0xff209AA1),
                  center: Icon(Icons.arrow_forward_outlined),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget guideline(int page) {
    return SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              GuidelineTitles.getGuidelineTitle(page),
              textAlign: TextAlign.center,
              maxLines: 3,
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(fontSize: 28, color: Colors.black),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Image.asset(
                    guidelineImages[page],
                    fit: BoxFit.fill,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
