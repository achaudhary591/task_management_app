import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/models/task.dart';

class TaskListScreen extends StatelessWidget {

Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Confirm Deletion'),
      content: Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
          child: Text('Delete'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'All':
                  Provider.of<TaskProvider>(context, listen: false).clearFilters();
                  break;
                case 'Completed':
                  Provider.of<TaskProvider>(context, listen: false).filterByCompleted(true);
                  break;
                case 'Pending':
                  Provider.of<TaskProvider>(context, listen: false).filterByCompleted(false);
                  break;
                case 'Sort by Due Date':
                  Provider.of<TaskProvider>(context, listen: false).sortByDueDate();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'All', 'Completed', 'Pending', 'Sort by Due Date'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Text('An error occurred!'),
            );
          } else {
            return Consumer<TaskProvider>(
              builder: (ctx, taskProvider, child) {
                return ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (ctx, index) {
                    Task task = taskProvider.tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          bool? confirm = await showDeleteConfirmationDialog(context);
                          if (confirm == true) {
                            Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id!);
                          }
                        },
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/edit-task', arguments: task);
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/add-task');
        },
      ),
    );
  }
}
