import 'package:clean_architecture_getx/features/todo/presentation/widgets/circle_container.dart';
import 'package:clean_architecture_getx/features/todo/data/models/todo.dart';
import 'package:clean_architecture_getx/core/app_extension.dart';
import 'package:clean_architecture_getx/core/app_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.items,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  final List<ToDo> items;

  final void Function(ToDo) onEditPressed;
  final void Function(ToDo) onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListBody(
          children: items.mapWithIndex((index, item) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 5),
                CircleContainer(
                  color: colorList[index],
                  isActive: item.status.value,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: headLine3, maxLines: 2),
                      const SizedBox(height: 3),
                      Text(
                        DateFormat("yyyy-MM-dd – kk:mm").format(item.dueOn),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                //  const Spacer(),
                IconButton(
                  splashRadius: 20.0,
                  onPressed: () => onEditPressed(item),
                  icon: const Icon(Icons.edit, color: Color(0xFF4CAF50)),
                ),
                IconButton(
                  splashRadius: 20.0,
                  onPressed: () => onDeletePressed(item),
                  icon: const Icon(Icons.delete, color: Color(0xFFF44336)),
                ),
              ],
            ),
          ),
        );
      }).toList()),
    );
  }
}
