// lens_list_screen.dart
import 'package:flutter/material.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LensListScreen extends StatefulWidget {
  final List<Lens> lensList;

  const LensListScreen({super.key, required this.lensList});

  @override
  _LensListScreenState createState() => _LensListScreenState();
}

class _LensListScreenState extends State<LensListScreen> {
  late List<Lens> _lensList;

  @override
  void initState() {
    super.initState();
    _lensList = widget.lensList;
  }

  @override
  void didUpdateWidget(LensListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lensList != oldWidget.lensList) {
      setState(() {
        _lensList = widget.lensList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Nouns AR Lenses',
            style: TextStyle(color: Colors.white)),
      ),
      body: LensListView(lensList: _lensList),
    );
  }
}

class LensListView extends StatefulWidget {
  final List<Lens> lensList;

  const LensListView({super.key, required this.lensList});

  @override
  State<LensListView> createState() => _LensListWidgetState();
}

class _LensListWidgetState extends State<LensListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        widget.lensList.isNotEmpty
            ? Expanded(
                child: ListView.separated(
                    itemCount: widget.lensList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            // nothing to do here
                          },
                          // Make the entire item tappable by wrapping the entire content
                          child: Container(
                            width: double
                                .infinity, // Make container take full width
                            color: Colors
                                .transparent, // Transparent to not affect appearance
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.network(
                                    widget.lensList[index].thumbnail?[0] ?? "",
                                    width: 70,
                                    height: 70,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    widget.lensList[index].name!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // onTap: () {
                          //   final Map<String, dynamic> arguments = {
                          //     'lensId': widget.lensList[index].id ?? "",
                          //     'groupId': widget.lensList[index].groupId ?? ""
                          //   };
                          //   Navigator.of(context).pop(arguments);
                          // },
                        )),
              )
            : Container()
      ],
    );
  }
}
