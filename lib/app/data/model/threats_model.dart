class ThreatsModel {
  String? title;
  String? titleIcon;
  String? score;

  ThreatsModel({this.title, this.titleIcon, this.score});
  static List<ThreatsModel> threatList() {
    return [
      ThreatsModel(title: "Phishing", titleIcon: "Phishing", score: "44"),
      ThreatsModel(title: "Malware", titleIcon: "Malware", score: "20"),
      ThreatsModel(title: "Web Attacks", titleIcon: "Web Attack", score: "60"),
      ThreatsModel(title: "Spam", titleIcon: "Spam", score: "44"),
    ];
  }
}
