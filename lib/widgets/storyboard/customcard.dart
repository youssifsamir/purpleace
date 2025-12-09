// ignore_for_file: must_be_immutable

// packages
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purpleace/widgets/storyboard/carddialog.dart';

class CardLabel {
  String name;
  Color color;

  CardLabel({required this.name, required this.color});
}

class CustomCard extends StatefulWidget {
  final String id;
  final String bucket;
  final Color bucketcolor;
  final String listtitle;
  final double width;
  final double height;
  final Color color;
  final Color fontColor;
  final double titleFontSize;
  final double descriptionFontSize;

  String title;
  String description;
  DateTime? plannedDate;
  List<dynamic> assignees;
  List<CardLabel> labels;

  int attachments;
  bool completed;

  CustomCard({
    super.key,
    this.width = 250,
    required this.id,
    this.height = 150,
    this.color = Colors.white,
    required this.listtitle,
    required this.bucketcolor,
    this.fontColor = Colors.black,
    this.titleFontSize = 16,
    this.descriptionFontSize = 14,
    required this.title,
    required this.bucket,
    required this.description,
    this.plannedDate,
    List<dynamic>? assignees,
    List<CardLabel>? labels,
    this.attachments = 0,
    this.completed = false,
  }) : assignees = assignees ?? [],
       labels = labels ?? [];

  final List<CardLabel> predefinedLabels = [
    CardLabel(name: "Bug", color: Colors.redAccent),
    CardLabel(name: "Feature", color: Colors.blue),
    CardLabel(name: "Improvement", color: Colors.green),
    CardLabel(name: "High Priority", color: Colors.orange),
    CardLabel(name: "Low Priority", color: Colors.grey),
  ];

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isCompleted = false;
  bool isHovered = false;

  /// Right-click menu state
  bool showAddLabelMenu = false;
  CardLabel? selectedPredefinedLabel;
  Color chosenColor = Colors.blue;
  TextEditingController customLabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isCompleted = widget.completed;
  }

  void openCardDialog() async {
    final result = await showDialog(
      context: context,
      builder:
          (context) => CardDetailsDialog(
            title: widget.title,
            listtitle: widget.listtitle,
            bucket: widget.bucket,
            bucketcolor: widget.bucketcolor,
            description: widget.description,
            plannedDate: widget.plannedDate,
            assignees: widget.assignees,
            labels: widget.labels,
            attachments: widget.attachments,
          ),
    );

    if (result != null) {
      setState(() {
        widget.title = result['title'];
        widget.description = result['description'];
      });
    }
  }

  void showRightClickMenu(Offset position) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(onTap: openCardDialog, child: const Text("Edit Card")),
        PopupMenuItem(
          child: const Text("Mark Complete"),
          onTap: () => setState(() => isCompleted = !isCompleted),
        ),
        PopupMenuItem(
          child: StatefulBuilder(
            builder: (context, setStateMenu) {
              if (showAddLabelMenu) {
                return SizedBox(
                  width: 350,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Predefined dropdown
                      DropdownButton<CardLabel>(
                        isExpanded: true,
                        hint: const Text("Select predefined label"),
                        value: selectedPredefinedLabel,
                        items:
                            widget.predefinedLabels.map((lbl) {
                              return DropdownMenuItem(
                                value: lbl,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: lbl.color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(lbl.name),
                                  ],
                                ),
                              );
                            }).toList(),
                        onChanged: (val) {
                          setStateMenu(() {
                            selectedPredefinedLabel = val;
                            chosenColor = val!.color;
                          });
                        },
                      ),

                      const SizedBox(height: 8),

                      /// New label input
                      TextField(
                        controller: customLabelController,
                        decoration: const InputDecoration(
                          hintText: "New label name",
                        ),
                        onSubmitted: (_) {
                          _addLabel();
                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 8),

                      /// Color picker
                      Wrap(
                        spacing: 6,
                        children:
                            Colors.primaries.take(12).map((c) {
                              return GestureDetector(
                                onTap:
                                    () => setStateMenu(() => chosenColor = c),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: c,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color:
                                          chosenColor == c
                                              ? Colors.black
                                              : Colors.black26,
                                      width: chosenColor == c ? 2 : 1,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 6),

                      ElevatedButton(
                        onPressed: () {
                          _addLabel();
                          Navigator.pop(context);
                        },
                        child: const Text("Add Label"),
                      ),
                    ],
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () => setState(() => showAddLabelMenu = true),
                  child: const Text("Add Label"),
                );
              }
            },
          ),
        ),
        if (widget.labels.isNotEmpty)
          PopupMenuItem(child: const Text("Remove Label"), onTap: removeLabel),
      ],
    );
  }

  void _addLabel() {
    if (selectedPredefinedLabel != null) {
      widget.labels.add(
        CardLabel(
          name: selectedPredefinedLabel!.name,
          color: selectedPredefinedLabel!.color,
        ),
      );
    } else if (customLabelController.text.trim().isNotEmpty) {
      widget.labels.add(
        CardLabel(name: customLabelController.text.trim(), color: chosenColor),
      );
    }

    // Reset menu state
    showAddLabelMenu = false;
    selectedPredefinedLabel = null;
    customLabelController.clear();
    setState(() {});
  }

  void removeLabel() {
    if (widget.labels.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Remove Label"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.labels.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.labels[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() => widget.labels.removeAt(index));
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: openCardDialog,
        onSecondaryTapDown:
            (details) => showRightClickMenu(details.globalPosition),
        child: Draggable<CustomCard>(
          data: widget,
          feedback: Material(
            color: Colors.transparent,
            child: IntrinsicHeight(
              child: SizedBox(
                width: widget.width,
                // height: widget.height,
                child: buildCard(),
              ),
            ),
          ),
          childWhenDragging: Opacity(opacity: 0.5, child: buildCard()),
          child: buildCard(),
        ),
      ),
    );
  }

  Widget buildCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: widget.width,
      // height: widget.height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isHovered ? widget.color.withOpacity(0.92) : widget.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHovered ? Colors.deepPurple : Colors.transparent,
          width: isHovered ? 2 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: isHovered ? Colors.black26 : Colors.black12,
            blurRadius: isHovered ? 8 : 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Labels
          if (widget.labels.isNotEmpty)
            Wrap(
              spacing: 4,
              children:
                  widget.labels
                      .map(
                        (lbl) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: lbl.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lbl.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          Row(
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: (val) => setState(() => isCompleted = val!),
              ),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: widget.titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.fontColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: widget.descriptionFontSize,
              color: widget.fontColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
