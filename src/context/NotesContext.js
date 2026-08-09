import React, { createContext, useState, useEffect, useContext, useMemo } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

const NotesContext = createContext();

const SEED_NOTES = [
  {
    id: 1,
    title: 'Welcome to growthBox React Native! (100% Offline)',
    content: 'Your notes and todos management powered by AI. Experience simple, fast, and intelligent productivity anywhere on your Android device without needing any internet connection.',
    tags: ['Welcome', 'Offline', 'ReactNative'],
    isArchived: false,
    updatedAt: new Date(Date.now() - 3600000).toISOString(),
  },
  {
    id: 2,
    title: 'Project Goals & Growth Strategy',
    content: '1. Build consistent daily habits.\n2. Organize ideas into structured offline notes.\n3. Keep track of high-priority todos effortlessly.',
    tags: ['Growth', 'Goals'],
    isArchived: false,
    updatedAt: new Date(Date.now() - 7200000).toISOString(),
  },
];

export const NotesProvider = ({ children }) => {
  const [notes, setNotes] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [showArchived, setShowArchived] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    (async () => {
      try {
        const saved = await AsyncStorage.getItem('local_notes');
        if (saved) {
          setNotes(JSON.parse(saved));
        } else {
          setNotes(SEED_NOTES);
          await AsyncStorage.setItem('local_notes', JSON.stringify(SEED_NOTES));
        }
      } catch (e) {
      } finally {
        setIsLoading(false);
      }
    })();
  }, []);

  const saveToStorage = async (list) => {
    try {
      await AsyncStorage.setItem('local_notes', JSON.stringify(list));
    } catch (e) {}
  };

  const createNote = async (title, content, tags) => {
    const newId = notes.length > 0 ? Math.max(...notes.map((n) => n.id)) + 1 : 1;
    const now = new Date().toISOString();
    const newNote = {
      id: newId,
      title,
      content,
      tags,
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    };
    const updated = [newNote, ...notes];
    setNotes(updated);
    await saveToStorage(updated);
  };

  const updateNote = async (note) => {
    const updated = notes.map((n) =>
      n.id === note.id ? { ...note, updatedAt: new Date().toISOString() } : n
    );
    setNotes(updated);
    await saveToStorage(updated);
  };

  const deleteNote = async (id) => {
    const updated = notes.filter((n) => n.id !== id);
    setNotes(updated);
    await saveToStorage(updated);
  };

  const toggleArchive = async (id) => {
    const updated = notes.map((n) =>
      n.id === id ? { ...n, isArchived: !n.isArchived, updatedAt: new Date().toISOString() } : n
    );
    setNotes(updated);
    await saveToStorage(updated);
  };

  const filteredNotes = useMemo(() => {
    return notes.filter((n) => {
      if (n.isArchived !== showArchived) return false;
      if (!searchQuery.trim()) return true;
      const q = searchQuery.toLowerCase();
      return (
        n.title.toLowerCase().includes(q) ||
        n.content.toLowerCase().includes(q) ||
        (n.tags && n.tags.some((t) => t.toLowerCase().includes(q)))
      );
    });
  }, [notes, showArchived, searchQuery]);

  return (
    <NotesContext.Provider
      value={{
        notes,
        filteredNotes,
        isLoading,
        showArchived,
        setShowArchived,
        searchQuery,
        setSearchQuery,
        createNote,
        updateNote,
        deleteNote,
        toggleArchive,
      }}
    >
      {children}
    </NotesContext.Provider>
  );
};

export const useNotes = () => useContext(NotesContext);
