import 'dart:async';

import 'package:barometer_plugin_n/barometer_plugin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double density = 1.1644; // 1.1644 --> 30c, 1.1455 --> 35c ,1.2250 --> 15c
  double? _bottomReading = 0.0;
  double? _topReading = 0.0;
  double? _homeLevelReading = 0.0;
  double? homeLevelHeight = 0.0;
  double fciHight = 0.0;
  double? fciLevelHeight = 0.0;

  double? _bottomReading2 = 0.0;
  double? _topReading2 = 0.0;
  double hight = 0.0;
  String comp = "------------";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      final bottomReading = await BarometerPlugin.initialize();
      final topReading = await BarometerPlugin.initialize();
      final homeLevelReading = await BarometerPlugin.initialize();

      final bottomReading2 = await BarometerPlugin.initialize();
      final topReading2 = await BarometerPlugin.initialize();

      print(bottomReading);
      print(topReading);
      print(homeLevelReading);
      print(bottomReading2);
      print(topReading2);
    } on Exception {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 2, 197, 171),
            appBar: AppBar(
              toolbarHeight: 15,
              backgroundColor: const Color.fromARGB(255, 4, 237, 206),
              bottom: const TabBar(
                indicatorColor: Colors.red,
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.home,
                    color: Colors.red,
                    size: 30,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.height_rounded,
                    color: Colors.red,
                    size: 40,
                  )),
                ],
              ),
            ),
            body: TabBarView(children: [
              IntrinsicWidth(
                  child: Column(children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                          left: 20,
                        ),
                        child: SharedROW(
                          text: 'Bottom Reading',
                          reading: '$_bottomReading hPa',
                          padding: const EdgeInsets.only(left: 64),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, left: 20),
                        child: SharedROW(
                          text: 'Top Reading',
                          reading: '$_topReading hPa',
                          padding: const EdgeInsets.only(left: 97),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10),
                        child: SharedROW(
                          text: 'FCI Height',
                          reading: '$fciHight m',
                          padding: const EdgeInsets.only(left: 115),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 4,
                  color: Colors.white,
                  thickness: 2,
                ),
                Container(
                    child: Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 5, left: 20, top: 10),
                    child: SharedROW(
                      text: 'Sea-level Pressure',
                      reading: '1013.25 hPa',
                      padding: const EdgeInsets.only(left: 40),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
                    child: SharedROW(
                      text: 'Home-level Pressure',
                      reading: '$_homeLevelReading hPa',
                      padding: const EdgeInsets.only(left: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
                    child: SharedROW(
                      text: 'Home-level Height',
                      reading: '$homeLevelHeight m',
                      padding: const EdgeInsets.only(left: 40),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      bottom: 5,
                    ),
                    child: SharedROW(
                      text: 'FCI-level Height',
                      reading: '$fciLevelHeight',
                      padding: const EdgeInsets.only(left: 63),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "FCI-level  $comp  Home-level",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ])),
                const Divider(
                  height: 2,
                  color: Colors.white,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(220, 20),
                              primary: const Color.fromARGB(255, 0, 223, 12)),
                          onPressed: sharedPreferences!
                                      .getDouble("bottomReading") ==
                                  null
                              ? () async {
                                  final bottomReading =
                                      await BarometerPlugin.reading;
                                  setState(() {
                                    _bottomReading = bottomReading;
                                    // _bottomReading = 1006.314208984375;
                                    // _bottomReading = 1003.5771484375;
                                    fciLevelHeight =
                                        (((1013.25 - _bottomReading!) / 10) *
                                                1000) /
                                            (9.8 * density);
                                  });
                                  sharedPreferences!.setDouble(
                                      "fciLevelHight", fciLevelHeight!);
                                  sharedPreferences!.setDouble(
                                      "bottomReading", _bottomReading!);
                                }
                              : () {},
                          child: const Text(
                            "Bottom Reading",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(220, 20),
                              primary: const Color.fromARGB(255, 0, 223, 12)),
                          onPressed:
                              sharedPreferences!.getDouble("topReading") == null
                                  ? () async {
                                      final topReading =
                                          await BarometerPlugin.reading;
                                      setState(() {
                                        _topReading = topReading;
                                        // _topReading = 1006.0979003933775;
                                        // _topReading = 1003.37255859375;
                                      });
                                      sharedPreferences!.setDouble(
                                          "topReading", _topReading!);
                                    }
                                  : () {},
                          child: const Text(
                            "Top Reading",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(220, 20),
                              primary: const Color.fromARGB(255, 0, 223, 12)),
                          child: const Text(
                            "FCI Hight",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          onPressed: () async {
                            setState(() {
                              fciHight =
                                  (((_bottomReading! - _topReading!) / 10) *
                                          1000) /
                                      (9.8 * density);
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(220, 20),
                              primary: const Color.fromARGB(255, 0, 223, 12)),
                          onPressed: sharedPreferences!
                                      .getDouble("homeLevelReading") ==
                                  null
                              ? () async {
                                  final homeLevelReading =
                                      await BarometerPlugin.reading;

                                  setState(() {
                                    _homeLevelReading = homeLevelReading;
                                    // _homeLevelReading = 1006.314208984375;
                                    homeLevelHeight =
                                        (((1013.25 - _homeLevelReading!) / 10) *
                                                1000) /
                                            (9.8 * density);
                                  });
                                  sharedPreferences!.setDouble(
                                      "HOMELEVELHIGHT", homeLevelHeight!);
                                  sharedPreferences!.setDouble(
                                      "homeLevelReading", _homeLevelReading!);
                                }
                              : () {},
                          child: const Text(
                            "Home Level Height",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(130, 30),
                                primary: const Color.fromARGB(255, 0, 223, 12)),
                            onPressed: () {
                              setState(() {
                                fciLevelHeight = sharedPreferences!
                                    .getDouble("fciLevelHight");
                                _bottomReading = sharedPreferences!
                                    .getDouble("bottomReading");
                                _topReading =
                                    sharedPreferences!.getDouble("topReading");
                              });
                            },
                            child: const Text(
                              "Get FCI",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(130, 30),
                                primary: const Color.fromARGB(255, 0, 223, 12)),
                            onPressed: () {
                              setState(() {
                                homeLevelHeight = sharedPreferences!
                                    .getDouble("HOMELEVELHIGHT");
                                _homeLevelReading = sharedPreferences!
                                    .getDouble("homeLevelReading");
                              });
                            },
                            child: const Text(
                              "Get Home",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(130, 30),
                                primary: const Color.fromARGB(255, 0, 223, 12)),
                            onPressed: () {
                              setState(() {
                                if (fciLevelHeight! > homeLevelHeight!) {
                                  comp = "greater than";
                                } else if (fciLevelHeight! < homeLevelHeight!) {
                                  comp = "less than";
                                } else {}
                              });
                            },
                            child: const Text(
                              "Compared",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(130, 30),
                                primary: Color.fromARGB(255, 235, 21, 5)),
                            onPressed: () {
                              sharedPreferences!.clear();
                            },
                            child: const Text(
                              "Clear",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ])),
              IntrinsicWidth(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 5,
                              left: 20,
                            ),
                            child: SharedROW(
                              text: 'Bottom Reading',
                              reading: '$_bottomReading2 hPa',
                              padding: const EdgeInsets.only(left: 64),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, left: 20),
                            child: SharedROW(
                              text: 'Top Reading',
                              reading: '$_topReading2 hPa',
                              padding: const EdgeInsets.only(left: 97),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20, bottom: 20),
                            child: SharedROW(
                              text: 'Height',
                              reading: '$hight m',
                              padding: const EdgeInsets.only(left: 150),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 4,
                      color: Colors.white,
                      thickness: 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(220, 20),
                                primary: const Color.fromARGB(255, 0, 223, 12)),
                            onPressed: () async {
                              final bottomReading2 =
                                  await BarometerPlugin.reading;
                              setState(() {
                                _bottomReading2 = bottomReading2;
                                // _bottomReading2 = 1006.314208984375;
                              });
                            },
                            child: const Text(
                              "Bottom Reading",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(220, 20),
                              primary: const Color.fromARGB(255, 0, 223, 12)),
                          onPressed: () async {
                            final topReading2 = await BarometerPlugin.reading;
                            setState(() {
                              _topReading2 = topReading2;
                              // _topReading2 = 1006.0979003933775;
                            });
                          },
                          child: const Text(
                            "Top Reading",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(220, 20),
                              primary: const Color.fromARGB(255, 0, 223, 12)),
                          child: const Text(
                            "Height",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          onPressed: () async {
                            setState(() {
                              hight =
                                  (((_bottomReading2! - _topReading2!) / 10) *
                                          1000) /
                                      (9.8 * density);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          )),
    );
  }
}

class SharedROW extends StatelessWidget {
  String text;
  String reading;
  EdgeInsetsGeometry padding;
  SharedROW({
    Key? key,
    required this.text,
    required this.reading,
    required this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: padding,
          child: Container(
            height: 50,
            width: 145,
            color: Colors.white,
            child: Center(
              child: Text(
                reading,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
