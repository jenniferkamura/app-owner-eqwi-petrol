import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/edit_profile_controller.dart';

class Pizza extends StatefulWidget {
  CartItem cartItem;
  int index;

  Pizza({required this.cartItem, required this.index});
  @override
  _PizzaState createState() => _PizzaState();
}

class _PizzaState extends State<Pizza> {
  String _value = "";
  EditProfileController profileController = Get.put(EditProfileController());
  @override
  void initState() {
    super.initState();
    _value = widget.cartItem.itemName;

    print('value');
    print(_value);
  }

  @override
  void didUpdateWidget(Pizza oldWidget) {
    if (oldWidget.cartItem.itemName != widget.cartItem.itemName) {
      _value = widget.cartItem.itemName;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        isExpanded: true,
        value: _value,
        underline: SizedBox(
          height: 0,
          width: 0,
        ),
        items: const [
          DropdownMenuItem(
            value: "1000",
            child: Text("1000 ltr"),
          ),
          DropdownMenuItem(
            value: "2000",
            child: Text("2000 ltr"),
          ),
          DropdownMenuItem(
            value: "3000",
            child: Text("3000 ltr"),
          ),
          DropdownMenuItem(
            value: "4000",
            child: Text("4000 ltr"),
          ),
          DropdownMenuItem(
            value: "5000",
            child: Text("5000 ltr"),
          ),
          DropdownMenuItem(
            value: "6000",
            child: Text("6000 ltr"),
          ),
        ],
        onChanged: (value) {
          // if(this.mounted)
          setState(() {
            _value = value!;
            widget.cartItem.itemName = value;
            profileController.addDataToSelectedDropdown(widget.index, value);
            // print(_value);
            // print(widget.cartItem.itemName);
          });
        });
  }
}

// class MyDropDown extends StatefulWidget {
//   final String numberOfCompartments;

//   MyDropDown({super.key, required this.numberOfCompartments});
//   @override
//   _MyDropDownState createState() => _MyDropDownState();

// }

class MyDropDown extends StatefulWidget {
  final String numberOfCompartments;
  const MyDropDown({super.key, required this.numberOfCompartments});

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

// class _MyDropDownState extends State<MyDropDown> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(widget.numberOfCompartments);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
//}

class CartItem {
  String productType;
  String itemName;


  CartItem({required this.productType, required this.itemName});
}

class CartWidget extends StatefulWidget {
  List<CartItem> cart;
  int index;
  VoidCallback callback;

  CartWidget(
      {super.key,
      required this.cart,
      required this.index,
      required this.callback});
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
            width: 0,
          ),
          Text('${widget.index + 1}  Compartment Capacity'),
          Row(
            children: [

              Expanded(
                  child: Pizza(
                      cartItem: widget.cart[widget.index],
                      index: widget.index)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyDropDownState extends State<MyDropDown> {
  List<CartItem> cart = [];
  String? _selectedBox;
  String? newValue;
  EditProfileController _profileController = Get.put(EditProfileController());
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
   /* print(widget.vehicleDetailsList[0]['compartment_capacity']);
    print(widget.vehicleDetailsList[1]['compartment_capacity']);*/
    // setState(() {
    _selectedBox = widget.numberOfCompartments;
    //  });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setVl(_selectedBox);
    });
    super.initState();
  }
  setVl(String? _selectedBox) async{
    for (var i = 0; i < int.parse(_selectedBox.toString()); i++) {
      cart.add(
          CartItem(productType: "1000", itemName: "1000"));
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 35,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: DropdownButton<String>(
                  value: _selectedBox,
                  isDense: false,
                  hint: Text(
                    'Select count',
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                  // Initial Value
                  //value: dropdownValue,
                  isExpanded: true,
                  underline: const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                  // Down Arrow Icon
                  icon: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.black,
                    size: 18,
                  ),
                  items: ["1", "2", "3", "4", "5", "6"].map(
                    (item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    },
                  ).toList(),
                  // Array list of items
                  // items: ["1", "2", "3", "4", "5", "6"].map((value) {
                  //   return DropdownMenuItem<String>(
                  //     value: _selectedBox.toString(),
                  //     child: Text(
                  //       value.toString(),
                  //       overflow: TextOverflow.ellipsis,
                  //       style: GoogleFonts.baloo2(
                  //           textStyle:
                  //               Theme.of(context).textTheme.displayMedium,
                  //           color: Colors.black,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500),
                  //     ),
                  //   );
                  // }).toList(),

                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (newValue) {
                    _profileController.makeEmptyListSelDropDown();
                    setState(() {
                      _selectedBox = newValue;
                      print('value:$_selectedBox');
                      cart = [];
                      for (var i = 0; i < int.parse(newValue.toString()); i++) {
                        cart.add(
                            CartItem(productType: "1000", itemName: "1000"));
                      }
                      print('cart:$cart');
                     // setState(() {});
                    });
                  },
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  key: UniqueKey(),
                  itemCount: cart.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return CartWidget(
                        cart: cart, index: index, callback: refresh);
                  }),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         cart.add(CartItem(
            //             productType: "1000",
            //             itemName: "1000"));
            //         setState(() {});
            //       },
            //       child: const Text("Add Tank"),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

// To parse this JSON data, do
//
//     final selectedDropDVal = selectedDropDValFromJson(jsonString);

