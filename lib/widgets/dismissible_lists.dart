import 'package:flutter/material.dart';

class DismissibleLists extends StatefulWidget {
  const DismissibleLists({super.key});

  @override
  State<DismissibleLists> createState() => _DismissibleListsState();
}

class _DismissibleListsState extends State<DismissibleLists> {
  final List<String> items = ["Task 1", "Task 2", "Task 3", "Task 4"];

  late List<bool> checked;

  String? _lastDeletedItem;
  int? _lastDeletedIndex;

  @override
  void initState() {
    super.initState();
    checked = List.generate(items.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final element = items.removeAt(oldIndex);
          items.insert(newIndex, element);
        });
      },
      children: [
        for (int i = 0; i < items.length; i++)
          Dismissible(
            key: ValueKey(items[i]),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Confirm Delete"),
                  content: Text(
                    "Are you sure you want to delete ${items[i]} ?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text("Delete"),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              setState(() {
                _lastDeletedItem = items[i];
                _lastDeletedIndex = items.indexOf(items[i]);
                items.remove(items[i]);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${items[i]} deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        if (_lastDeletedItem != null &&
                            _lastDeletedIndex != null) {
                          items.insert(_lastDeletedIndex!, _lastDeletedItem!);
                        }
                      });
                    },
                  ),
                ),
              );
            },
            child: ListTile(
              key: ValueKey("tile_${items[i]}"),
              title: Text(
                items[i],
                style: TextStyle(
                  decoration: checked[i]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              leading: const Icon(Icons.drag_handle),
              trailing: Checkbox(
                value: checked[i],
                onChanged: (value) {
                  setState(() {
                    checked[i] = value ?? false;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }
}
