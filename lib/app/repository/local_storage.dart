import 'package:geiger_dummy_data/geiger_dummy_data.dart';
import 'package:geiger_localstorage/geiger_localstorage.dart';

class LocalStorage {
  StorageController? storageController;

  LocalStorage({required this.storageController});

  //getCurrentUser
  User get getCurrentUser {
    GeigerUser _geigerUser = GeigerUser(storageController!);
    return _geigerUser.getUserInfo;
  }

  //getCurrentDevice
  Device get getCurrentDevice {
    GeigerDevice _geigerDevice = GeigerDevice(storageController!);
    return _geigerDevice.getDeviceInfo;
  }

  List<Threat> get getThreats {
    GeigerThreat _geigerUser = GeigerThreat(storageController!);
    return _geigerUser.getThreats();
  }

  //aggreThreatScore
  List<ThreatScore> getAggregateThreatScore() {
    List<ThreatScore> t = [];

    try {
      GeigerUser _geigerUser = GeigerUser(storageController!);
      return _geigerUser.getGeigerScoreAggregateThreatScore();
    } catch (e) {
      return t;
    }
  }

  //UserThreatScore
  List<ThreatScore> getGeigerScoreUserThreatScore() {
    List<ThreatScore> t = [];

    try {
      GeigerUser _geigerUser = GeigerUser(storageController!);
      return _geigerUser.getGeigerScoreUserThreatScores();
    } catch (e) {
      return t;
    }
  }

  //DeviceThreatScore
  List<ThreatScore> getGeigerScoreDeviceThreatScore() {
    List<ThreatScore> t = [];
    GeigerDevice _geigerDevice = GeigerDevice(storageController!);
    try {
      return _geigerDevice.getGeigerDeviceThreatScores();
    } catch (e) {
      return t;
    }
  }

  //-----//UserData---///
  String _userJson =
      '{"firstName":"John", "lastName":"Doe", "role":{ "name":"CEO"}}';
  // ------//End ----///
  void setUserInfo() {
    GeigerUser _geigerUser = GeigerUser(storageController!);
    _geigerUser.setUserInfo = User.convertUserFromJson(_userJson);
  }

  //setDeviceInfo
  void setDeviceInfo() {
    GeigerDevice _geigerDevice = GeigerDevice(storageController!);
    _geigerDevice.setCurrentDeviceInfo =
        Device(owner: getCurrentUser, name: "Samsung", type: "Mobile");
  }

  //-----//ThreatData---///
  String _threatJson =
      '[{"name":"Malware"},{"name":"Phishing"},{"name":"web Attacks"}]';
  // --- //End ------///

  void setThreat() {
    GeigerThreat _geigerThreat = GeigerThreat(storageController!);
    _geigerThreat.setGlobalThreatsNode(
        threats: Threat.convertFromJson(_threatJson));
  }

  // set GeigerUserScore
  void setGeigerUserScore() {
    GeigerUser _geigerUser = GeigerUser(storageController!);
    List<ThreatScore> threatScore = <ThreatScore>[];
    List<Threat> threats = getThreats;
    List<String> scores = ["25", "45", "60"];

    for (int i = 0; i < threats.length; i++) {
      threatScore.add(ThreatScore(threat: threats[i], score: scores[i]));
    }
    _geigerUser.setGeigerUserScore(
        geigerScore: "70", threatScores: threatScore);
  }

  //set GeigerDeviceScore
  void setGeigerDeviceScoreThreatScore() {
    GeigerDevice _geigerDevice = GeigerDevice(storageController!);
    List<ThreatScore> threatScore = <ThreatScore>[];
    List<Threat> threats = getThreats;
    List<String> scores = ["54", "50", "30"];

    for (int i = 0; i < threats.length; i++) {
      threatScore.add(ThreatScore(threat: threats[i], score: scores[i]));
    }
    _geigerDevice.setGeigerScoreDevice(
        geigerScore: "60", threatScores: threatScore);
  }

  //set AggregateThreatScore
  void setAggregateThreatScore() {
    GeigerUser _geigerUser = GeigerUser(storageController!);
    List<ThreatScore> threatScore = <ThreatScore>[];
    List<Threat> threats = getThreats;
    List<String> scores = ["50", "50", "50"];

    for (int i = 0; i < threats.length; i++) {
      threatScore.add(ThreatScore(threat: threats[i], score: scores[i]));
    }
    _geigerUser.setGeigerScoreAggregate(
        geigerScore: "50", threatScores: threatScore);
  }

  void clearDatabase() {
    storageController!.flush();
  }
}
