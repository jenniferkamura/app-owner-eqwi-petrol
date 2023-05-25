class DeliveriesDataModel{
  int? id;
  String? address,dataType,productType,productQty,type,orderId;


  DeliveriesDataModel({
    this.id,
    this.address,
    this.dataType,
    this.productType,
    this.productQty,
    this.type,
    this.orderId,
  });
}
List<DeliveriesDataModel> deliveriesDataModel = [
  DeliveriesDataModel(
      id: 0,
      address: "Vito Carleone,#32,6th main,Nairobi,Sector 34 Kenya,PIN-123456",
      dataType: "Pickup",
      productType: "Petrol",
      orderId: "#KJGFU25499",
      productQty: "2000 Ltr",
      type: 'no'
  ),
  DeliveriesDataModel(
      id: 1,
      address: "Vito Carleone,#32,6th main,Nairobi,Sector 34 Kenya,PIN-123456",
      dataType: "Delivery1",
      productType: "Petrol",
      orderId: "#KJGFU25499",
      productQty: "3000 Ltr",
      type: 'yes'
  ),
  DeliveriesDataModel(
      id: 2,
      address: "Vito Carleone,#32,6th main,Nairobi,Sector 34 Kenya,PIN-123456",
      dataType: "Delivery2",
      productType: "Petrol",
      orderId: "KJGFU25499",
      productQty: "4000 Ltr",
      type: 'yes'
  ),
  DeliveriesDataModel(
      id: 4,
      address: "Vito Carleone,#32,6th main,Nairobi,Sector 34 Kenya,PIN-123456",
      dataType: "Delivery3",
      productType: "Petrol",
      orderId: "KJGFU25499",
      productQty: "2000 Ltr",
      type: 'yes'
  ),
];