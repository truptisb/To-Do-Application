// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Task>> getTasks() async {
    final response = await supabase.from('tasks').select();
    return (response as List)
        .map((json) => Task.fromJson(json))
        .toList();
  }

  Future<void> addTask(String title) async {
    await supabase.from('tasks').insert({'title': title, 'is_completed': false});
  }

  Future<void> deleteTask(String id) async {
    await supabase.from('tasks').delete().eq('id', id);
  }

  Future<void> toggleComplete(String id, bool isDone) async {
    await supabase.from('tasks').update({'is_completed': isDone}).eq('id', id);
  }
}
