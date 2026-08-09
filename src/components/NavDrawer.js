import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Modal } from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useAuth } from '../context/AuthContext';
import { Logo } from './Logo';

export const NavDrawer = ({ visible, onClose, currentTab, onSelectTab }) => {
  const { theme, isDarkMode, toggleTheme } = useTheme();
  const { user, logout } = useAuth();

  if (!visible) return null;

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={styles.overlay}>
        <TouchableOpacity style={styles.backdrop} activeOpacity={1} onPress={onClose} />
        <View style={[styles.drawer, { backgroundColor: theme.sidebarBg }]}>
          <View style={[styles.header, { borderBottomColor: theme.borderPrimary }]}>
            <Logo size={32} showText={true} textColor={theme.textPrimary} />
            <TouchableOpacity onPress={onClose}>
              <Text style={{ color: theme.textSecondary, fontSize: 18 }}>✕</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.menu}>
            {[
              { id: 'dashboard', label: 'Dashboard', icon: '📊' },
              { id: 'notes', label: 'Notes', icon: '📝' },
              { id: 'todos', label: 'Todos', icon: '🎯' },
            ].map((item) => {
              const selected = currentTab === item.id;
              return (
                <TouchableOpacity
                  key={item.id}
                  style={[
                    styles.menuItem,
                    selected && { backgroundColor: 'rgba(252, 187, 0, 0.18)' },
                  ]}
                  onPress={() => {
                    onSelectTab(item.id);
                    onClose();
                  }}
                >
                  <Text style={styles.menuIcon}>{item.icon}</Text>
                  <Text
                    style={[
                      styles.menuLabel,
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

          <View style={[styles.footer, { borderTopColor: theme.borderPrimary }]}>
            <View style={styles.userRow}>
              <View style={styles.avatar}>
                <Text style={styles.avatarText}>L</Text>
              </View>
              <View style={styles.userInfo}>
                <Text style={[styles.userName, { color: theme.textPrimary }]}>
                  {user?.name || 'Local User'}
                </Text>
                <Text style={[styles.userEmail, { color: theme.textTertiary }]}>
                  {user?.email || 'local@growthbox.app'}
                </Text>
              </View>
            </View>

            <View style={styles.actions}>
              <TouchableOpacity
                onPress={toggleTheme}
                style={[styles.actionBtn, { borderColor: theme.borderPrimary }]}
              >
                <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
                  {isDarkMode ? '☀️ Light' : '🌙 Dark'}
                </Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => {
                  onClose();
                  logout();
                }}
                style={[styles.actionBtn, { borderColor: '#FB2C36' }]}
              >
                <Text style={{ color: '#FB2C36', fontSize: 12, fontWeight: '700' }}>
                  Logout
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </View>
    </Modal>
  );
};

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    flexDirection: 'row',
  },
  backdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.6)',
  },
  drawer: {
    width: 280,
    height: '100%',
    padding: 16,
    justifyContent: 'space-between',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingBottom: 16,
    borderBottomWidth: 1,
  },
  menu: {
    flex: 1,
    paddingVertical: 16,
    gap: 8,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 12,
    paddingHorizontal: 14,
    borderRadius: 12,
    gap: 12,
  },
  menuIcon: {
    fontSize: 16,
  },
  menuLabel: {
    fontSize: 14,
    fontWeight: '500',
  },
  footer: {
    paddingTop: 16,
    borderTopWidth: 1,
  },
  userRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    marginBottom: 14,
  },
  avatar: {
    width: 38,
    height: 38,
    borderRadius: 19,
    backgroundColor: 'rgba(252, 187, 0, 0.2)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    color: '#FCBB00',
    fontWeight: '800',
    fontSize: 16,
  },
  userInfo: {
    flex: 1,
  },
  userName: {
    fontWeight: '700',
    fontSize: 13,
  },
  userEmail: {
    fontSize: 11,
  },
  actions: {
    flexDirection: 'row',
    gap: 10,
  },
  actionBtn: {
    flex: 1,
    paddingVertical: 10,
    borderRadius: 10,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
