import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, ScrollView } from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useNotes } from '../context/NotesContext';
import { useTodos } from '../context/TodosContext';
import { StatCard } from '../components/StatCard';

export const DashboardScreen = ({ onNavigate, onNewNote, onNewTodo }) => {
  const { theme } = useTheme();
  const { notes } = useNotes();
  const { todos } = useTodos();

  const activeNotes = notes.filter((n) => !n.isArchived).length;
  const archivedNotes = notes.filter((n) => n.isArchived).length;
  const completedTodos = todos.filter((t) => t.isCompleted).length;
  const activeTodos = todos.filter((t) => !t.isCompleted).length;
  const completionRate =
    todos.length > 0 ? Math.round((completedTodos / todos.length) * 100) : 0;

  return (
    <ScrollView
      style={[styles.container, { backgroundColor: theme.bgPrimary }]}
      contentContainerStyle={styles.content}
    >
      <View style={[styles.banner, { borderColor: '#FCBB0050' }]}>
        <View style={styles.bannerInfo}>
          <Text style={[styles.bannerTitle, { color: theme.textPrimary }]}>
            Unlock Potential
          </Text>
          <Text style={[styles.bannerSub, { color: theme.textSecondary }]}>
            Manage your notes and todos with AI.{'\n'}Simple, fast, and intelligent.
          </Text>
        </View>
        <View style={styles.badge}>
          <Text style={{ color: '#FCBB00', fontSize: 18, fontWeight: '800' }}>✦</Text>
        </View>
      </View>

      <View style={styles.grid}>
        <View style={styles.row}>
          <StatCard
            title="Active Notes"
            value={`${activeNotes}`}
            subtitle={`${archivedNotes} archived`}
            icon="📝"
            iconColor="#FCBB00"
            onPress={() => onNavigate('notes')}
          />
          <StatCard
            title="Pending Todos"
            value={`${activeTodos}`}
            subtitle={`${completedTodos} completed`}
            icon="🎯"
            iconColor="#FB2C36"
            onPress={() => onNavigate('todos')}
          />
        </View>
        <View style={styles.row}>
          <StatCard
            title="Completion Rate"
            value={`${completionRate}%`}
            subtitle={`Of ${todos.length} total tasks`}
            icon="⚡"
            iconColor="#10B981"
            onPress={() => onNavigate('todos')}
          />
          <StatCard
            title="Total Items"
            value={`${notes.length + todos.length}`}
            subtitle="Local storage sync"
            icon="💾"
            iconColor="#3B82F6"
          />
        </View>
      </View>

      <View style={[styles.chartCard, { backgroundColor: theme.bgSecondary, borderColor: theme.borderPrimary }]}>
        <Text style={[styles.chartTitle, { color: theme.textSecondary }]}>
          TODO COMPLETION OVERVIEW
        </Text>
        <View style={styles.progressRow}>
          <View style={styles.statItem}>
            <Text style={[styles.statNum, { color: '#10B981' }]}>{completedTodos}</Text>
            <Text style={[styles.statLabel, { color: theme.textTertiary }]}>Done</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={[styles.statNum, { color: '#FB2C36' }]}>{activeTodos}</Text>
            <Text style={[styles.statLabel, { color: theme.textTertiary }]}>Active</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={[styles.statNum, { color: '#FCBB00' }]}>{activeNotes}</Text>
            <Text style={[styles.statLabel, { color: theme.textTertiary }]}>Notes</Text>
          </View>
        </View>
      </View>

      <View style={styles.btnRow}>
        <TouchableOpacity style={[styles.fab, { backgroundColor: '#FCBB00' }]} onPress={onNewNote}>
          <Text style={styles.fabTextDark}>+ New Note</Text>
        </TouchableOpacity>
        <TouchableOpacity style={[styles.fab, { backgroundColor: '#FB2C36' }]} onPress={onNewTodo}>
          <Text style={styles.fabTextLight}>+ New Todo</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    padding: 16,
    paddingBottom: 40,
  },
  banner: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 18,
    borderRadius: 16,
    borderWidth: 1,
    backgroundColor: 'rgba(252, 187, 0, 0.1)',
    marginBottom: 16,
  },
  bannerInfo: {
    flex: 1,
  },
  bannerTitle: {
    fontSize: 18,
    fontWeight: '800',
    marginBottom: 4,
  },
  bannerSub: {
    fontSize: 12,
    lineHeight: 18,
  },
  badge: {
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: 'rgba(252, 187, 0, 0.2)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  grid: {
    marginBottom: 16,
  },
  row: {
    flexDirection: 'row',
  },
  chartCard: {
    padding: 18,
    borderRadius: 16,
    borderWidth: 1,
    marginBottom: 18,
  },
  chartTitle: {
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 0.5,
    marginBottom: 14,
  },
  progressRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  statItem: {
    alignItems: 'center',
  },
  statNum: {
    fontSize: 24,
    fontWeight: '800',
  },
  statLabel: {
    fontSize: 11,
    marginTop: 2,
  },
  btnRow: {
    flexDirection: 'row',
    gap: 12,
  },
  fab: {
    flex: 1,
    paddingVertical: 14,
    borderRadius: 12,
    alignItems: 'center',
  },
  fabTextDark: {
    color: '#000',
    fontSize: 14,
    fontWeight: '700',
  },
  fabTextLight: {
    color: '#FFF',
    fontSize: 14,
    fontWeight: '700',
  },
});
