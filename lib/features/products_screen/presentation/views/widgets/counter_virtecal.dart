// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../../../../../constant.dart';
// // import '../../provider/counter_provider.dart';
// //
// // class CounterVertical extends StatefulWidget {
// //  final int index;
// //
// //  final  item;
// //    CounterVertical({
// //    required this.index,
// //      required this.item,
// //
// //     super.key,
// //   });
// //
// //   @override
// //   State<CounterVertical> createState() => _CounterWidgetState();
// // }
// //
// // class _CounterWidgetState extends State<CounterVertical> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<CounterProvider>(
// //         builder: (context, CounterProvider counterProvider, child) {
// //       return Row(
// //         children: [
// //           InkWell(
// //             onTap: (){
// //               counterProvider.incrementCounter(widget.index);
// //             },
// //             child: Container(
// //                 width: 35,
// //                 height: 35,
// //                 decoration: BoxDecoration(
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.grey.withOpacity(0.5),
// //                       spreadRadius: .5,
// //                       blurRadius: .5,
// //                       offset: const Offset(0, 0), // changes position of shadow
// //                     ),
// //                   ],
// //                   color: Colors.white,
// //                   borderRadius: const BorderRadius.all(Radius.circular(15)),
// //                 ),
// //                 child: const Icon(
// //                   Icons.add,
// //                   color: darkOrange,
// //                 )),
// //           ),
// //           const SizedBox(
// //             width: 12,
// //           ),
// //           Text('${widget.item.counter}',
// //               style: const TextStyle(fontSize: 18, color: Colors.black)),
// //           const SizedBox(
// //             width: 12,
// //           ),
// //           InkWell(
// //             onTap: ()=> counterProvider.decrementCounter(widget.index),
// //             child: Container(
// //                 width: 35,
// //                 height: 35,
// //                 decoration: BoxDecoration(
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.grey.withOpacity(0.5),
// //                       spreadRadius: .5,
// //                       blurRadius: .5,
// //                       offset: const Offset(0, 0), // changes position of shadow
// //                     ),
// //                   ],
// //                   color: Colors.white,
// //                   borderRadius: const BorderRadius.all(Radius.circular(15)),
// //                 ),
// //                 child: const Icon(
// //                   Icons.remove,
// //                   color: brownDark,
// //                 )),
// //           ),
// //         ],
// //       );
// //     });
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../model/product_model.dart';
// import '../../provider/counter_provider.dart';
// class CounterVertical extends StatelessWidget {
//   final Products product;
//
//   const CounterVertical({
//     required this.product,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CounterProvider>(
//       builder: (context, counterProvider, child) {
//         return Row(
//           children: [
//             InkWell(
//               onTap: () => counterProvider.incrementCounter(product),
//               child: Container(
//                 width: 35,
//                 height: 35,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(15)),
//                 ),
//                 child: const Icon(Icons.add, color: Colors.green),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text('${product.counter}', style: const TextStyle(fontSize: 18)),
//             const SizedBox(width: 12),
//             InkWell(
//               onTap: () => counterProvider.decrementCounter(product),
//               child: Container(
//                 width: 35,
//                 height: 35,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(15)),
//                 ),
//                 child: const Icon(Icons.remove, color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:awlad_khedr/constant.dart';

class AddToCartButton extends StatefulWidget {
  const AddToCartButton({super.key});

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return selectedIndex == 0
        ? InkWell(
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: mainColor),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'أضف للسلة',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          )
        : Row(
            children: [
              InkWell(
                onTap: () {
                  // counterProvider.incrementCounter(widget.index);
                },
                child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: .5,
                          blurRadius: .5,
                          offset:
                              const Offset(0, 0),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: darkOrange,
                    )),
              ),
              const SizedBox(
                width: 12,
              ),
              // Text('${widget.item.counter}',
              //     style: const TextStyle(fontSize: 18, color: Colors.black)),
              const SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: .5,
                          blurRadius: .5,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: brownDark,
                    )),
              ),
            ],
          );
  }
}
