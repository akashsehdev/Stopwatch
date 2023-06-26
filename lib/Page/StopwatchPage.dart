import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch/Widget/Txt.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  Stopwatch? _stopwatch;
  String? _stopwatchText;
  List<String>? _lapTimes;
  SharedPreferences? _prefs;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _stopwatchText = '00:00.00';
    _lapTimes = [];
    _initSharedPreferences();
  }

  //Storing Laps in Local Storage
  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _lapTimes = _prefs?.getStringList('lapTimes') ?? [];
    });
  }

  //Start Stopwatch Function
  void _startStopwatch() {
    setState(() {
      _stopwatch?.start();
      _stopwatchText = '00:00.00';
      isLoading = false;
    });
    _updateStopwatch();
  }

  //Stop Stopwatch Function
  void _stopStopwatch() {
    setState(() {
      _stopwatch?.stop();
      isLoading = true;
    });
  }

  //Reset Stopwatch Function
  void _resetStopwatch() {
    setState(() {
      _stopwatch!.reset();
      _stopwatchText = '00:00.00';
      _lapTimes?.clear();
      isLoading = true;
    });
    _prefs?.setStringList('lapTimes', []);
  }

  //Updating Stopwatch Function
  void _updateStopwatch() {
    if (_stopwatch!.isRunning) {
      setState(() {
        _stopwatchText = StopwatchUtil.formatTime(_stopwatch!.elapsed);
      });
      Future.delayed(const Duration(milliseconds: 10), _updateStopwatch);
    }
  }

//Storing Lap Time Function
  void _storeLapTime() {
    final lapTime = StopwatchUtil.formatTime(_stopwatch!.elapsed);
    setState(() {
      _lapTimes!.insert(0, lapTime);
      isLoading = false;
    });
    _prefs!.setStringList('lapTimes', _lapTimes!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Txt(
            heading: "Stopwatch",
            clr: Colors.black,
            fWeight: FontWeight.w600,
            fsize: 25),
        centerTitle: true,
        toolbarHeight: 70,
        elevation: 1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Watch
          Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Txt(
                  heading: _stopwatchText!,
                  clr: Colors.black,
                  fWeight: FontWeight.w700,
                  fsize: 48)),
          const SizedBox(
            height: 20,
          ),
          const Txt(
              heading: "Lap Times",
              clr: Colors.black,
              fWeight: FontWeight.w500,
              fsize: 24),
          const SizedBox(
            height: 20,
          ),

          //Lap Time
          Expanded(
            child: ListView.builder(
              itemCount: _lapTimes?.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Txt(
                    heading: _lapTimes![index],
                    clr: Colors.green,
                    fWeight: FontWeight.w400,
                    fsize: 20),
                leading: Txt(
                    heading: "${index + 1}",
                    clr: Colors.black,
                    fWeight: FontWeight.w300,
                    fsize: 18),
              ),
            ),
          ),

          //Play, Pause, Reset and Store Lap Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Play and Pause Button
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 80,
                      child: IconButton(
                          onPressed: () {
                            isLoading ? _startStopwatch() : _stopStopwatch();
                          },
                          icon: isLoading
                              ?
                              //Play Icon
                              Column(
                                  children: const [
                                    Expanded(
                                        child: Icon(
                                      Icons.play_arrow,
                                      size: 30,
                                    )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                        child: Txt(
                                            heading: "Play",
                                            clr: Colors.black,
                                            fWeight: FontWeight.w400,
                                            fsize: 16))
                                  ],
                                )
                              :
                              //Pause Icon
                              Column(
                                  children: const [
                                    Expanded(
                                        child: Icon(
                                      Icons.pause,
                                      size: 30,
                                    )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                        child: Txt(
                                            heading: "Pause",
                                            clr: Colors.black,
                                            fWeight: FontWeight.w400,
                                            fsize: 16))
                                  ],
                                )),
                    ),
                  ],
                ),
              ),

              //Reset and Store Lap Button
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 80,
                      child: IconButton(
                          onPressed: () {
                            isLoading ? _resetStopwatch() : _storeLapTime();
                          },
                          icon: isLoading
                              ?
                              //Reset Icon
                              Column(
                                  children: const [
                                    Expanded(
                                        child: Icon(
                                      Icons.restore_sharp,
                                      size: 30,
                                    )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                        child: Txt(
                                            heading: "Reset",
                                            clr: Colors.black,
                                            fWeight: FontWeight.w400,
                                            fsize: 16))
                                  ],
                                )
                              :
                              //Store Lap Icon
                              Column(
                                  children: const [
                                    Expanded(
                                        child: Icon(
                                      Icons.storage_rounded,
                                      size: 30,
                                    )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                        child: Txt(
                                            heading: "Store Lap",
                                            clr: Colors.black,
                                            fWeight: FontWeight.w400,
                                            fsize: 16))
                                  ],
                                )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

//Stop Watch Function
class StopwatchUtil {
  static String formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds.$milliseconds';
  }
}
