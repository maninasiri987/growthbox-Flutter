import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/notes_provider.dart';
import '../providers/todos_provider.dart';
import '../theme/colors.dart';
import '../widgets/stat_card.dart';
import 'note_editor_screen.dart';
import 'todo_editor_screen.dart';

class DashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notesProvider = Provider.of<NotesProvider>(context);
    final todosProvider = Provider.of<TodosProvider>(context);

    final notes = notesProvider.notes;
    final todos = todosProvider.todos;

    final activeNotes = notes.where((n) => !n.isArchived).length;
    final archivedNotes = notes.where((n) => n.isArchived).length;
    final completedTodos = todos.where((t) => t.isCompleted).length;
    final activeTodos = todos.where((t) => !t.isCompleted).length;

    final totalTodos = todos.length;
    final todoCompletionRate = totalTodos > 0 ? (completedTodos / totalTodos * 100).toStringAsFixed(0) : '0';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner / Welcome Slogan
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.amber500.withOpacity(0.18),
                  AppColors.red500.withOpacity(0.12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.amber400.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unlock Potential',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Manage your notes and todos with AI.\nSimple, fast, and intelligent.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.amber400.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: AppColors.amber400, size: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Statistics Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
            children: [
              StatCard(
                title: 'Active Notes',
                value: '$activeNotes',
                icon: Icons.note_alt_outlined,
                iconColor: AppColors.amber400,
                subtitle: '$archivedNotes archived',
                onTap: () => onNavigate(1),
              ),
              StatCard(
                title: 'Pending Todos',
                value: '$activeTodos',
                icon: Icons.pending_actions_outlined,
                iconColor: AppColors.red400,
                subtitle: '$completedTodos completed',
                onTap: () => onNavigate(2),
              ),
              StatCard(
                title: 'Completion Rate',
                value: '$todoCompletionRate%',
                icon: Icons.task_alt_outlined,
                iconColor: AppColors.emerald500,
                subtitle: 'Of $totalTodos todos',
                onTap: () => onNavigate(2),
              ),
              StatCard(
                title: 'Total Items',
                value: '${notes.length + todos.length}',
                icon: Icons.insights_outlined,
                iconColor: AppColors.blue500,
                subtitle: 'Local storage sync',
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Productivity Charts Section
          Text(
            'Productivity Charts',
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Todo completion pie chart
              Expanded(
                child: Container(
                  height: 210,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Todo Completion',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 28,
                            sections: [
                              PieChartSectionData(
                                color: AppColors.emerald500,
                                value: completedTodos.toDouble() == 0 && activeTodos.toDouble() == 0
                                    ? 1
                                    : completedTodos.toDouble(),
                                title: '$completedTodos',
                                radius: 24,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: AppColors.red400,
                                value: activeTodos.toDouble() == 0 && completedTodos.toDouble() == 0
                                    ? 0
                                    : activeTodos.toDouble(),
                                title: '$activeTodos',
                                radius: 24,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegend('Done', AppColors.emerald500),
                          const SizedBox(width: 14),
                          _buildLegend('Active', AppColors.red400),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Notes distribution bar chart
              Expanded(
                child: Container(
                  height: 210,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Notes Overview',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: (activeNotes > archivedNotes ? activeNotes : archivedNotes).toDouble() + 2,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (val, _) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        val == 0 ? 'Active' : 'Archived',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: theme.textTheme.bodySmall?.color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: activeNotes.toDouble(),
                                    color: AppColors.amber400,
                                    width: 22,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: archivedNotes.toDouble(),
                                    color: AppColors.blue500,
                                    width: 22,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('New Note', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber400,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TodoEditorScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('New Todo', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
