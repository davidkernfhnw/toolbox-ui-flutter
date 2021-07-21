class RecommendationModel {
  String? header;
  String? body;
  bool isExpanded;

  RecommendationModel({this.header, this.body, this.isExpanded = false});
  static List<RecommendationModel> recommendations() {
    return [
      RecommendationModel(
        header: "E-mail filtering and Blocking",
        body:
            "Be wary of any unsolicited e-mails you receive. Particularly trustworthy companies are often used as false sender addresses.",
      ),
      RecommendationModel(
        header: "E-mail filtering and Blocking",
        body:
            "Be wary of any unsolicited e-mails you receive. Particularly trustworthy companies are often used as false sender addresses.",
      )
    ];
  }
}
