import 'dart:async';

/// This is a simplified version of my pomodoro timer.

class SetPauseTimer {
  /// holds timer and periodicTimer
  /// Timer is the actual clock, while periodicTimer updates the currentTimeSeconds variable
  Timer? timer; // keeps track of time for current phase
  Timer?
      periodicTimer; // counts seconds for callbacks each second (for example to update ui)
  final int focusTime; // length of focus phase in seconds
  num currentTimeSeconds = 0; // counts down to 0 every second
  Function? callback; // called every second (for example to update ui)

  SetPauseTimer({this.focusTime = 30 * 60 }) {
    /// focusTime: Time for each focus phase in seconds
    currentTimeSeconds = focusTime;
  }

  void start({bool skip = false, required callback}) {
    /// start / restart the timer
    /// callback: Function that is called each time the timer updates. Needs one parameter for currentTimeSeconds
    this.callback = callback;
    num remainingTime;

    // if skip is true or currentTimeSeconds is 0, start new full session, else resume the running session
    if (skip || currentTimeSeconds == 0) {
        remainingTime = focusTime;
    } else {
      // in this case the timer is just restarted after it has been stopped
      remainingTime = currentTimeSeconds;
    }
    currentTimeSeconds = remainingTime;

    // set new timers just in case the old one has not ended yet
    timer?.cancel();
    timer = Timer(Duration(seconds: remainingTime.toInt()), _timersUp);
    periodicTimer?.cancel();
    periodicTimer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void pause({bool skip = false}) {
    /// pause the timer
    /// if skip is true, switches to the other phase but does not start the new phase
    if (skip) {
        currentTimeSeconds = focusTime;
    }
    // timer is canceled so that callback is not called anymore
    // new timers are set by start()
    timer?.cancel();
    periodicTimer?.cancel();
  }

  void _timersUp() {
    /// called when the current session terminates
    periodicTimer?.cancel();
    currentTimeSeconds = 0;

    callback!(false);
  }

  void _tick(_) {
    /// called every second
    currentTimeSeconds--;
    callback!(true);
  }

  num getCurrentTimeSeconds() {
    return currentTimeSeconds;
  }
}
