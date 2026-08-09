import React, { createContext, useState, useEffect, useContext } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

const AuthContext = createContext();

const DEFAULT_USER = {
  id: 1,
  email: 'local@growthbox.app',
  name: 'Local User',
  isVip: true,
  authMode: 'local',
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    (async () => {
      try {
        const mode = await AsyncStorage.getItem('auth_mode');
        if (mode === 'local') {
          const savedUser = await AsyncStorage.getItem('local_user');
          setUser(savedUser ? JSON.parse(savedUser) : DEFAULT_USER);
        }
      } catch (e) {
      } finally {
        setIsLoading(false);
      }
    })();
  }, []);

  const loginWithLocalStorage = async () => {
    try {
      await AsyncStorage.setItem('auth_mode', 'local');
      await AsyncStorage.setItem('local_user', JSON.stringify(DEFAULT_USER));
      setUser(DEFAULT_USER);
    } catch (e) {}
  };

  const logout = async () => {
    try {
      await AsyncStorage.removeItem('auth_mode');
      setUser(null);
    } catch (e) {}
  };

  return (
    <AuthContext.Provider value={{ user, isLoading, isAuthenticated: !!user, loginWithLocalStorage, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
