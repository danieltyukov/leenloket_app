class Feedback {
  final int feedbackID;
  final int userID;
  final int itemID;
  final int rating;
  final String text;

  Feedback({
    required this.feedbackID,
    required this.userID,
    required this.itemID,
    required this.rating,
    required this.text,
  });

  Map<String, dynamic> toJson() => {
        'FeedbackID': feedbackID,
        'UserID': userID,
        'ItemID': itemID,
        'Rating': rating,
        'Text': text,
      };

  static Feedback fromJson(Map<String, dynamic> json) => Feedback(
        feedbackID: json['FeedbackID'],
        userID: json['UserID'],
        itemID: json['ItemID'],
        rating: json['Rating'],
        text: json['Text'],
      );
}
