import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, FlatList } from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useTodos } from '../context/TodosContext';
import { TodoItem } from '../components/TodoItem';

export const TodosScreen = ({ onEditTodo, onNewTodo }) => {
  const { theme } = useTheme();
  const { filteredTodos, filter, setFilter, toggleCompleted, deleteTodo } = useTodos();

  return (
    <View style={[styles.container, { backgroundColor: theme.bgPrimary }]}>
      <View style={styles.filters}>
        {['all', 'active', 'completed'].map((f) => {
          const selected = filter === f;
          return (
            <TouchableOpacity
              key={f}
              style={[
                styles.tab,
                selected && { backgroundColor: '#FB2C3625', borderColor: '#FB2C36' },
              ]}
              onPress={() => setFilter(f)}
            >
              <Text
                style={[
                  styles.tabText,
                  { color: selected ? '#FB2C36' : theme.textSecondary },
                  selected && { fontWeight: '700' },
                ]}
              >
                {f.charAt(0).toUpperCase() + f.slice(1)}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>

      <FlatList
        data={filteredTodos}
        keyExtractor={(item) => item.id.toString()}
        contentContainerStyle={styles.list}
        renderItem={({ item }) => (
          <TodoItem
            todo={item}
            onToggle={() => toggleCompleted(item.id)}
            onPress={() => onEditTodo(item)}
            onDelete={() => deleteTodo(item.id)}
          />
        )}
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={{ fontSize: 36, marginBottom: 10 }}>🎯</Text>
            <Text style={[styles.emptyTitle, { color: theme.textSecondary }]}>
              No {filter} todos
            </Text>
            <Text style={[styles.emptySub, { color: theme.textTertiary }]}>
              Tap "+ New Todo" below to add a task
            </Text>
          </View>
        }
      />

      <TouchableOpacity style={styles.fab} onPress={onNewTodo}>
        <Text style={styles.fabText}>+ New Todo</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  filters: {
    flexDirection: 'row',
    paddingHorizontal: 14,
    marginVertical: 12,
    gap: 8,
  },
  tab: {
    flex: 1,
    paddingVertical: 8,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'transparent',
    alignItems: 'center',
  },
  tabText: {
    fontSize: 13,
  },
  list: {
    paddingHorizontal: 14,
    paddingBottom: 80,
  },
  empty: {
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 60,
  },
  emptyTitle: {
    fontSize: 15,
    fontWeight: '700',
  },
  emptySub: {
    fontSize: 12,
    marginTop: 4,
  },
  fab: {
    position: 'absolute',
    bottom: 20,
    right: 20,
    paddingHorizontal: 18,
    paddingVertical: 13,
    borderRadius: 24,
    backgroundColor: '#FB2C36',
    elevation: 4,
  },
  fabText: {
    color: '#FFF',
    fontWeight: '700',
    fontSize: 14,
  },
});
