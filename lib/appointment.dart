class Appointment {
  String clientName;
  String clientID;
  String date;
  String time;
  String productName;
  String productID;
  int price;
  String additions;
  int duration;

  Appointment(
      {this.clientName = '',
      this.clientID = '',
      this.date = '',
      this.time = '',
      this.productName = '',
      this.productID = '',
      this.price = 0,
      this.additions = '',
      this.duration = 0});

  @override
  String toString() {
    return 'ClientName: $clientName, ClientID: $clientID, Date: $date, Time: $time, ProdName: $productName, ProdID: $productID, Price: $price, Additions: $additions, Duration: $duration';
  }

  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'clientID': clientID,
      'date': date,
      'time': time,
      'productName': productName,
      'productID': productID,
      'price': price,
      'additions': additions,
      'duration': duration
    };
  }
}
