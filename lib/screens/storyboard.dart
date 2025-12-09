// ignore_for_file: deprecated_member_use

// packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// widgets - adjust paths if needed
import '/widgets/storyboard/customcard.dart';

class StoryboardScreen extends StatefulWidget {
  final String storyboardId;

  const StoryboardScreen({super.key, required this.storyboardId});

  @override
  State<StoryboardScreen> createState() => _StoryboardScreenState();
}

class _StoryboardScreenState extends State<StoryboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  // -------------------------
  // Firestore helpers
  // -------------------------
  CollectionReference listsRef() => _firestore
      .collection('storyboards')
      .doc(widget.storyboardId)
      .collection('lists');

  CollectionReference listCardsRef(String listId) =>
      listsRef().doc(listId).collection('cards');

  Future<void> createList(String title) async {
    await listsRef().add({
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createCardOnList(
    String listId,
    Map<String, dynamic> cardData,
  ) async {
    final docRef = await listCardsRef(listId).add({
      ...cardData,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'storyboardId': widget.storyboardId,
      'listId': listId,
    });

    // add history entry
    await docRef.collection('history').add({
      'userId': 'system',
      'username': 'You',
      'avatarUrl': '',
      'action': 'Created card',
      'meta': {'title': cardData['title']},
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateCard(
    String listId,
    String cardId,
    Map<String, dynamic> data, {
    String? historyAction,
  }) async {
    final docRef = listCardsRef(listId).doc(cardId);
    await docRef.update({...data, 'updatedAt': FieldValue.serverTimestamp()});

    if (historyAction != null) {
      await docRef.collection('history').add({
        'userId': 'system',
        'username': 'You',
        'avatarUrl': '',
        'action': historyAction,
        'meta': data,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> deleteCard(String listId, String cardId) async {
    final docRef = listCardsRef(listId).doc(cardId);
    // write a final history entry before delete (optional - stored under the doc so will be deleted with it)
    try {
      await docRef.collection('history').add({
        'userId': 'system',
        'username': 'You',
        'avatarUrl': '',
        'action': 'Deleted card',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
    await docRef.delete();
  }

  /// Move card from sourceList -> targetList: copy doc into target subcollection and delete original.
  Future<void> moveCard({
    required String fromListId,
    required String toListId,
    required String cardId,
  }) async {
    final sourceRef = listCardsRef(fromListId).doc(cardId);
    final sourceSnap = await sourceRef.get();
    if (!sourceSnap.exists) return;

    final data = sourceSnap.data() as Map<String, dynamic>;

    // Add new doc to destination
    final destRef = await listCardsRef(toListId).add({
      ...data,
      'listId': toListId,
      'updatedAt': FieldValue.serverTimestamp(),
      'movedFrom': fromListId,
    });

    // add history to new doc
    await destRef.collection('history').add({
      'userId': 'system',
      'username': 'You',
      'avatarUrl': '',
      'action': 'Moved card from list $fromListId to $toListId',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // delete original (including its subcollections)
    await sourceRef.delete();
  }

  // -------------------------
  // UI actions
  // -------------------------
  void showCreateListDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create new list'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'List name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.trim().isEmpty) return;
                  await createList(controller.text.trim());
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  void showCreateCardDialog(String listId) {
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create new card'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  await createCardOnList(listId, {
                    'title': titleCtrl.text.trim(),
                    'description': descCtrl.text.trim(),
                    'brand': '',
                    'labels': [],
                    'assignees': [],
                    'attachments': [],
                    'dueDate': null,
                  });
                  Navigator.pop(context);
                },
                child: const Text('Add Card'),
              ),
            ],
          ),
    );
  }

  Future<void> showEditCardDialog({
    required String listId,
    required String cardId,
    required Map<String, dynamic> currentData,
  }) async {
    // Try to use existing CardDetailsDialog if you have it; otherwise use a simple dialog here.
    // We'll use a simple inline editor for clarity.
    final titleCtrl = TextEditingController(text: currentData['title'] ?? '');
    final descCtrl = TextEditingController(
      text: currentData['description'] ?? '',
    );
    final dueController = TextEditingController(
      text:
          currentData['dueDate'] != null
              ? DateFormat(
                'yyyy-MM-dd',
              ).format((currentData['dueDate'] as Timestamp).toDate())
              : '',
    );
    final labelsController = TextEditingController(
      text: (currentData['labels'] as List<dynamic>? ?? [])
          .map((l) => '${l['name']}|${l['color']}')
          .join(','),
    );
    final assigneesController = TextEditingController(
      text: (currentData['assignees'] as List<dynamic>? ?? [])
          .map((a) => '${a['name']}|${a['userId']}|${a['avatarUrl'] ?? ''}')
          .join(','),
    );

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Card'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: dueController,
                    decoration: const InputDecoration(
                      labelText: 'Due date (YYYY-MM-DD)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: labelsController,
                    decoration: const InputDecoration(
                      labelText: 'Labels (comma separated, name|0xffRRGGBB)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: assigneesController,
                    decoration: const InputDecoration(
                      labelText:
                          'Assignees (comma separated, name|userId|avatarUrl)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // parse fields
                  final Map<String, dynamic> updatePayload = {
                    'title': titleCtrl.text.trim(),
                    'description': descCtrl.text.trim(),
                  };

                  if (dueController.text.trim().isNotEmpty) {
                    try {
                      final parsed = DateTime.parse(dueController.text.trim());
                      updatePayload['dueDate'] = Timestamp.fromDate(parsed);
                    } catch (e) {
                      // ignore parse error (could show validation)
                    }
                  } else {
                    updatePayload['dueDate'] = null;
                  }

                  // labels
                  final labelsRaw = labelsController.text.trim();
                  if (labelsRaw.isNotEmpty) {
                    final labels =
                        labelsRaw.split(',').map((s) {
                          final parts = s.split('|');
                          final name = parts[0].trim();
                          final color =
                              parts.length > 1 ? parts[1].trim() : '0xff000000';
                          return {'name': name, 'color': color};
                        }).toList();
                    updatePayload['labels'] = labels;
                  } else {
                    updatePayload['labels'] = [];
                  }

                  // assignees
                  final assRaw = assigneesController.text.trim();
                  if (assRaw.isNotEmpty) {
                    final ass =
                        assRaw.split(',').map((s) {
                          final parts = s.split('|');
                          return {
                            'name': (parts.isNotEmpty ? parts[0].trim() : ''),
                            'userId': (parts.length > 1 ? parts[1].trim() : ''),
                            'avatarUrl':
                                (parts.length > 2 ? parts[2].trim() : ''),
                          };
                        }).toList();
                    updatePayload['assignees'] = ass;
                  } else {
                    updatePayload['assignees'] = [];
                  }

                  await updateCard(
                    listId,
                    cardId,
                    updatePayload,
                    historyAction: 'Edited card',
                  );
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void showCardContextMenu(
    BuildContext ctx,
    Offset globalPos, {
    required String listId,
    required String cardId,
    required Map<String, dynamic> cardData,
  }) async {
    final items = <PopupMenuEntry<int>>[
      const PopupMenuItem(value: 0, child: Text('Edit')),
      const PopupMenuItem(value: 1, child: Text('Delete')),
      const PopupMenuItem(value: 2, child: Text('Move')),
    ];

    final selected = await showMenu<int>(
      context: ctx,
      position: RelativeRect.fromLTRB(
        globalPos.dx,
        globalPos.dy,
        globalPos.dx,
        globalPos.dy,
      ),
      items: items,
    );

    if (selected == null) return;

    if (selected == 0) {
      // Edit
      await showEditCardDialog(
        listId: listId,
        cardId: cardId,
        currentData: cardData,
      );
    } else if (selected == 1) {
      // Delete
      final confirm = await showDialog<bool>(
        context: ctx,
        builder:
            (c) => AlertDialog(
              title: const Text('Delete card?'),
              content: const Text('This will remove the card permanently.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(c, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
      );
      if (confirm == true) {
        await deleteCard(listId, cardId);
      }
    } else if (selected == 2) {
      // Move -> show simple target list picker
      final listsSnap = await listsRef().orderBy('createdAt').get();
      final listOptions =
          listsSnap.docs
              .map(
                (d) => {
                  'id': d.id,
                  'title': (d.data() as Map)['title'] ?? d.id,
                },
              )
              .toList();

      await showDialog(
        context: ctx,
        builder: (c) {
          return SimpleDialog(
            title: const Text('Move to list'),
            children:
                listOptions.map((opt) {
                  return SimpleDialogOption(
                    child: Text(opt['title']),
                    onPressed: () async {
                      Navigator.pop(c);
                      if (opt['id'] != listId) {
                        await moveCard(
                          fromListId: listId,
                          toListId: opt['id'],
                          cardId: cardId,
                        );
                      }
                    },
                  );
                }).toList(),
          );
        },
      );
    }
  }

  // -------------------------
  // UI build
  // -------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 50.h),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: listsRef().orderBy('createdAt').snapshots(),
            builder: (context, listSnapshot) {
              if (listSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (listSnapshot.hasError) {
                return const Center(child: Text('Error loading lists'));
              }

              final lists = listSnapshot.data?.docs ?? [];

              if (lists.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No lists yet',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: showCreateListDialog,
                        child: const Text('Create First List'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...lists.map((listDoc) {
                      final listId = listDoc.id;
                      final listData = listDoc.data() as Map<String, dynamic>;
                      return buildListColumn(listId, listData);
                    }).toList(),
                    addListButton(),
                  ],
                ),
              );
            },
          ),
        ),
        Container(height: 75.h),
      ],
    );
  }

  Widget buildListColumn(String listId, Map<String, dynamic> listData) {
    return Container(
      width: 280,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xfff8f4ff),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: DragTarget<Map<String, dynamic>>(
        onWillAccept: (data) => data != null && data['fromListId'] != listId,
        onAccept: (data) async {
          // when receiving a dropped card; move it
          final fromList = data['fromListId'] as String;
          final cardId = data['cardId'] as String;
          await moveCard(
            fromListId: fromList,
            toListId: listId,
            cardId: cardId,
          );
        },
        builder: (context, _, __) {
          return Column(
            children: [
              // header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      listData['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => showCreateCardDialog(listId),
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // cards stream for this list
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: listCardsRef(listId).orderBy('createdAt').snapshots(),
                  builder: (context, cardSnapshot) {
                    if (cardSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final cards = cardSnapshot.data?.docs ?? [];
                    if (cards.isEmpty) {
                      return Center(
                        child: Text(
                          'No cards',
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final doc = cards[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final cardId = doc.id;

                        // Build small data for card rendering and drag payload
                        final cardPayload = {
                          'cardId': cardId,
                          'fromListId': listId,
                          'data': data,
                        };

                        // Show card with right-click menu and draggable support
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onSecondaryTapDown:
                                (details) => showCardContextMenu(
                                  context,
                                  details.globalPosition,
                                  listId: listId,
                                  cardId: cardId,
                                  cardData: data,
                                ),
                            child: LongPressDraggable<Map<String, dynamic>>(
                              data: cardPayload,
                              feedback: Material(
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: 230,
                                  child: buildCardWidget(data, cardId, listId),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.4,
                                child: buildCardWidget(data, cardId, listId),
                              ),
                              child: buildCardWidget(data, cardId, listId),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCardWidget(
    Map<String, dynamic> data,
    String cardId,
    String listId,
  ) {
    // Parse labels and assignees defensively
    final labels =
        (data['labels'] as List<dynamic>?)
            ?.map(
              (l) => CardLabel(
                name: l['name'] ?? '',
                color: _parseColorFromString(l['color'] ?? '0xff888888'),
              ),
            )
            .toList() ??
        [];

    final assignees =
        (data['assignees'] as List<dynamic>?)
            ?.map((a) => a['name'] ?? '')
            .cast<String>()
            .toList() ??
        [];

    final plannedDate =
        data['dueDate'] != null
            ? (data['dueDate'] as Timestamp).toDate()
            : null;

    return GestureDetector(
      onTap: () async {
        // open details (use your CardDetailsDialog if available)
        await showEditCardDialog(
          listId: listId,
          cardId: cardId,
          currentData: data,
        );
      },
      child: Container(
        // wrap the CustomCard but also show small labels row + due date
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // labels (small)
            if (labels.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    labels
                        .map(
                          (lbl) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: lbl.color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              lbl.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            const SizedBox(height: 6),
            // actual card (custom widget)
            CustomCard(
              id: cardId,
              title: data['title'] ?? '',
              description: data['description'] ?? '',
              width: 230,
              height: 100,
              color: Colors.white,
              fontColor: Colors.black,
              titleFontSize: 14,
              descriptionFontSize: 12,
              labels: labels,
              assignees: assignees,
              plannedDate: plannedDate,
              // ensure other params exist in your CustomCard constructor
              listtitle: '',
              bucketcolor: Colors.orange,
              bucket: data['brand'] ?? '',
            ),
            const SizedBox(height: 6),
            // due date + assignee small row
            Row(
              children: [
                if (plannedDate != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM').format(plannedDate),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                // assignee avatars simplified as initials
                ...assignees.take(3).map((a) {
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    child: CircleAvatar(
                      radius: 10,
                      child: Text(
                        a.isNotEmpty ? a[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColorFromString(String raw) {
    try {
      // allow '0xffRRGGBB' or hex without 0x
      if (raw.startsWith('0x')) return Color(int.parse(raw));
      if (raw.startsWith('#')) {
        return Color(int.parse('0xff' + raw.substring(1)));
      }
      return Color(int.parse(raw));
    } catch (_) {
      return const Color(0xff888888);
    }
  }

  Widget addListButton() {
    return GestureDetector(
      onTap: showCreateListDialog,
      child: Container(
        width: 180,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: const Center(
          child: Text(
            '+ Add List',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
