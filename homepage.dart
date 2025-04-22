import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';
import 'supabase_service.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  final SupabaseService _service = SupabaseService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();

  List<Task> _tasks = [];
  bool _isLoading = true;

  final List<String> _tabs = ["All", "Completed"];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    _tasks = await _service.getTasks();
    setState(() => _isLoading = false);
  }

  Future<void> _addTask(String title) async {
    await _service.addTask(title);
    _taskController.clear();
    _loadTasks();
  }

  Future<void> _deleteTask(String id) async {
    await _service.deleteTask(id);
    _loadTasks();
  }

  Future<void> _toggleCompleted(Task task) async {
    await _service.toggleComplete(task.id, !task.isCompleted);
    _loadTasks();
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Create New Task",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _taskController,
              autofocus: true,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: "Enter task title",
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final text = _taskController.text.trim();
                if (text.isNotEmpty) {
                  _addTask(text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                "Add Task",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: GestureDetector(
          onTap: () => _toggleCompleted(task),
          child: Icon(
            task.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: task.isCompleted ? Colors.green : Colors.black,
            size: 28,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: task.isCompleted ? Colors.black : Colors.black,
          ),
        ),
        trailing: task.isCompleted
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Completed",
                  style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              )
            : null,
        onLongPress: () => _deleteTask(task.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _tabController.index == 1
        ? _tasks.where((task) => task.isCompleted).toList()
        : _tasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        
        title: const Text("TaskFlow", style: TextStyle(color: Colors.black, fontSize: 22)),
        centerTitle: true,
        
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
         Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: TextField(
    controller: _searchController,
    onChanged: (query) {
      // Optional search filtering
    },
    decoration: InputDecoration(
      hintText: "Search tasks...",
      hintStyle: TextStyle(color: Colors.grey[600]),  // Light gray hint text
      prefixIcon: const Icon(Icons.search, color: Colors.grey),
      suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
              },
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),  // Rounded corners
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blueGrey, width: 2),  // Highlight on focus
      ),
      isDense: true,
    ),
  ),
)
,

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            indicatorColor: Colors.teal,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),

          const SizedBox(height: 10),

          // Task List
          _isLoading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : filteredTasks.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text("No tasks yet. Add one!", style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) => _buildTaskCard(filteredTasks[index]),
                      ),
                    ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: Colors.indigo[500],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
