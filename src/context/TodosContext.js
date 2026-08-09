import React, { createContext, useState, useEffect, useContext, useMemo } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

const TodosContext = createContext();

const SEED_TODOS = [
  {
    id: 1,
    title: 'Test growthBox React Native APK',
    description: 'Check out localStorage login and offline data persistence.',
    priority: 3,
    isCompleted: true,
    updatedAt: new Date(Date.now() - 86400000).toISOString(),
  },
  {
    id: 2,
    title: 'Customize theme & organize notes',
    description: 'Try switching between Dark mode and Light mode in the top bar.',
    priority: 2,
    isCompleted: false,
    updatedAt: new Date().toISOString(),
  },
  {
    id: 3,
    title: 'Review productivity charts on Dashboard',
    description: 'Track daily progress and completed tasks offline.',
    priority: 1,
    isCompleted: false,
    updatedAt: new Date().toISOString(),
  },
];

export const TodosProvider = ({ children }) => {
  const [todos, setTodos] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [filter, setFilter] = useState('all'); // 'all', 'active', 'completed'

  useEffect(() => {
    (async () => {
      try {
        const saved = await AsyncStorage.getItem('local_todos');
        if (saved) {
          setTodos(JSON.parse(saved));
        } else {
          setTodos(SEED_TODOS);
          await AsyncStorage.setItem('local_todos', JSON.stringify(SEED_TODOS));
        }
      } catch (e) {
      } finally {
        setIsLoading(false);
      }
    })();
  }, []);

  const saveToStorage = async (list) => {
    try {
      await AsyncStorage.setItem('local_todos', JSON.stringify(list));
    } catch (e) {}
  };

  const createTodo = async (title, description, priority) => {
    const newId = todos.length > 0 ? Math.max(...todos.map((t) => t.id)) + 1 : 1;
    const now = new Date().toISOString();
    const newTodo = {
      id: newId,
      title,
      description,
      priority,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    };
    const updated = [newTodo, ...todos];
    setTodos(updated);
    await saveToStorage(updated);
  };

  const updateTodo = async (todo) => {
    const updated = todos.map((t) =>
      t.id === todo.id ? { ...todo, updatedAt: new Date().toISOString() } : t
    );
    setTodos(updated);
    await saveToStorage(updated);
  };

  const deleteTodo = async (id) => {
    const updated = todos.filter((t) => t.id !== id);
    setTodos(updated);
    await saveToStorage(updated);
  };

  const toggleCompleted = async (id) => {
    const updated = todos.map((t) =>
      t.id === id ? { ...t, isCompleted: !t.isCompleted, updatedAt: new Date().toISOString() } : t
    );
    setTodos(updated);
    await saveToStorage(updated);
  };

  const filteredTodos = useMemo(() => {
    return todos
      .filter((t) => {
        if (filter === 'active') return !t.isCompleted;
        if (filter === 'completed') return t.isCompleted;
        return true;
      })
      .sort((a, b) => b.priority - a.priority);
  }, [todos, filter]);

  return (
    <TodosContext.Provider
      value={{
        todos,
        filteredTodos,
        isLoading,
        filter,
        setFilter,
        createTodo,
        updateTodo,
        deleteTodo,
        toggleCompleted,
      }}
    >
      {children}
    </TodosContext.Provider>
  );
};

export const useTodos = () => useContext(TodosContext);
