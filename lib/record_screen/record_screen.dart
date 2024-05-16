import 'dart:io';
import 'dart:async';
import 'package:canvas_image/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key, this.sidebarWidth});
  final double? sidebarWidth;
  @override
  State<StatefulWidget> createState() {
    return _RecordScreenState();
  }
}

class _RecordScreenState extends State<RecordScreen> {
  EdScreenRecorder? screenRecorder;
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  bool inProgress = false;
  bool isPaused = false; // Pause durumu için bir state değişkeni ekleyin
  late String _fileName;
  Timer? _timer;
  int _start = 0;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _start++;
        });
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      _start = 0;
    });
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    screenRecorder = EdScreenRecorder();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    if (!await Permission.storage.request().isGranted) {
      await openAppSettings();
    }
    if (!await Permission.microphone.request().isGranted) {
      await openAppSettings();
    }
  }

  Future<void> startRecord(
      {required double width, required double height}) async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    try {
      setState(() {
        isPaused = false;
      });
      stopTimer();
      startTimer();
      final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}';
      String dirPath = (await getTemporaryDirectory()).path;
      if (await Permission.storage.request().isGranted) {
        await screenRecorder?.startRecordScreen(
          fileName: fileName,
          audioEnable: true,
          width: width.toInt(),
          height: height.toInt(),
          dirPathToSave: dirPath,
        );
        setFileName(fileName);
        setState(() {
          inProgress = true;
        });
      }
    } on PlatformException catch (e) {
      printError("An error occurred while starting the recording: $e");
    }
  }

  void setFileName(String fileName) {
    setState(() {
      _fileName = fileName;
    });
  }

  Future<void> stopRecord() async {
    try {
      var stopResponse = await screenRecorder?.stopRecord();
      if (stopResponse != null) {
        stopTimer(); // Timer'ı durdur
        File file = File(stopResponse.file.path);
        if (!await file.exists()) {
          debugPrint("File does not exist.");
          return;
        }

        Directory? directory = await getExternalStorageDirectory();
        if (directory == null) {
          printError("External storage directory is null.");
          return;
        }

        final String outputPath = '${directory.path}/$_fileName.mp4';
        double cropY = toolbarHeight;
        double cropWidth = MediaQuery.of(context).size.width;
        double cropHeight = MediaQuery.of(context).size.height - cropY;
        cropVideo(file.path, outputPath, cropWidth.toInt(), cropHeight.toInt(),
            0, cropY);
        setState(() {
          inProgress = false;
          isPaused = false;
        });
      } else {
        debugPrint("Error: File does not exist.");
      }
    } on PlatformException catch (e) {
      printError("An error occurred while stopping the recording: $e");
    }
  }

  Future<void> pauseRecord() async {
    try {
      await screenRecorder?.pauseRecord();
      pauseTimer(); // Timer'ı durdur
      setState(() {
        isPaused = true;
      });
    } on PlatformException catch (e) {
      kDebugMode
          ? debugPrint("Error: An error occurred while pause recording: $e")
          : null;
    }
  }

  Future<void> resumeRecord() async {
    try {
      await screenRecorder?.resumeRecord();
      startTimer(); // Timer'ı yeniden başlat
      setState(() {
        isPaused = false;
      });
    } on PlatformException catch (e) {
      kDebugMode
          ? debugPrint("Error: An error occurred while resume recording: $e")
          : null;
    }
  }

  void printError(String message) {
    if (kDebugMode) {
      debugPrint("Error: $message");
    }
  }

  void cropVideo(String inputPath, String outputPath, int cropWidth,
      int cropHeight, int videoCropX, double videoCropY) async {
    String command =
        '-i $inputPath -vf "crop=$cropWidth:$cropHeight:$videoCropX:$videoCropY" -c:v mpeg4 -b:v 1M -pix_fmt yuv420p $outputPath';

    int returnCode = await _flutterFFmpeg.execute(command);

    if (returnCode == 0) {
      OpenFile.open(outputPath);
    } else {
      debugPrint('Video kırpma işlemi sırasında bir hata oluştu.');
    }
  }

  Widget buildTimerText(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;

    return Text(
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (!inProgress)
          IconButton(
            icon: const Icon(Icons.mic),
            color: Colors.red,
            onPressed: () {
              startRecord(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height);
            },
          ),
        if (inProgress)
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.green,
            onPressed: () {
              startRecord(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height);
            },
          ),
        if (inProgress && !isPaused)
          IconButton(
            icon: const Icon(Icons.pause),
            color: Colors.blue,
            onPressed: pauseRecord,
          ),
        if (inProgress && isPaused)
          IconButton(
            icon: const Icon(Icons.play_arrow),
            color: Colors.blue,
            onPressed: resumeRecord,
          ),
        if (inProgress)
          IconButton(
            icon: const Icon(Icons.stop),
            color: Colors.red,
            onPressed: stopRecord,
          ),
        if (_start != 0) buildTimerText(_start),
      ],
    );
  }
}
