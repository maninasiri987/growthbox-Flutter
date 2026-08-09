import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, SafeAreaView } from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { CustomAppBar } from '../components/CustomAppBar';
import { NavDrawer } from '../components/NavDrawer';
import { DashboardScreen } from './DashboardScreen';
import { NotesScreen } from './NotesScreen';
import { TodosScreen } from './TodosScreen';
import { NoteEditorModal } from './NoteEditorModal';
import { TodoEditorModal } from './TodoEditorModal';

export const HomeScreen = () => {
  const { theme } = useTheme();
  const [currentTab, setCurrentTab] = useState('dashboard');
  const [drawerOpen, setDrawerOpen] = useState(false);

  // Modals
  const [noteModalVisible, setNoteModalVisible] = useState(false);
  const [editingNote, setEditingNote] = useState(null);
  const [todoModalVisible, setTodoModalVisible] = useState(false);
  const [editingTodo, setEditingTodo] = useState(null);

  const openNewNote = () => {
    setEditingNote(null);
    setNoteModalVisible(true);
  };

  const openEditNote = (note) => {
    setEditingNote(note);
    setNoteModalVisible(true);
  };

  const openNewTodo = () => {
    setEditingTodo(null);
    setTodoModalVisible(true);
  };

  const openEditTodo = (todo) => {
    setEditingTodo(todo);
    setTodoModalVisible(true);
  };

  const getTitle = () => {
    switch (currentTab) {
      case 'notes':
        return 'Notes';
      case 'todos':
        return 'Todos';
      default:
        return 'Dashboard';
    }
  };

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.bgPrimary }]}>
      <CustomAppBar
        title={getTitle()}
        showLogo={currentTab === 'dashboard'}
        onOpenDrawer={() => setDrawerOpen(true)}
      />

      <NavDrawer
        visible={drawerOpen}
        onClose={() => setDrawerOpen(false)}
        currentTab={currentTab}
        onSelectTab={setCurrentTab}
      />

      <View style={styles.body}>
        {currentTab === 'dashboard' && (
          <DashboardScreen
            onNavigate={setCurrentTab}
            onNewNote={openNewNote}
            onNewTodo={openNewTodo}
          />
        )}
        {currentTab === 'notes' && (
          <NotesScreen onEditNote={openEditNote} onNewNote={openNewNote} />
        )}
        {currentTab === 'todos' && (
          <TodosScreen onEditTodo={openEditTodo} onNewTodo={openNewTodo} />
        )}
      </View>

      <View
        style={[
          styles.bottomBar,
          {
            backgroundColor: theme.bgPrimary,
            borderTopColor: theme.borderPrimary,
          },
        ]}
      >
        {[
          { id: 'dashboard', label: 'Dashboard', icon: '📊' },
          { id: 'notes', label: 'Notes', icon: '📝' },
          { id: 'todos', label: 'Todos', icon: '🎯' },
        ].map((item) => {
          const selected = currentTab === item.id;
          return (
            <TouchableOpacity
              key={item.id}
              style={styles.navItem}
              onPress={() => setCurrentTab(item.id)}
            >
              <Text style={{ fontSize: 18 }}>{item.icon}</Text>
              <Text
                style={[
                  styles.navLabel,
                  { color: selected ? '#FCBB00' : theme.textSecondary },
                  selected && { fontWeight: '700' },
                ]}
              >
                {item.label}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>

      <NoteEditorModal
        visible={noteModalVisible}
        note={editingNote}
        onClose={() => {
          setNoteModalVisible(false);
          setEditingNote(null);
        }}
      />

      <TodoEditorModal
        visible={todoModalVisible}
        todo={editingTodo}
        onClose={() => {
          setTodoModalVisible(false);
          setEditingTodo(null);
        }}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  body: {
    flex: 1,
  },
  bottomBar: {
    height: 58,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-around',
    borderTopWidth: 1,
  },
  navItem: {
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1,
  },
  navLabel: {
    fontSize: 10,
    marginTop: 2,
  },
});
