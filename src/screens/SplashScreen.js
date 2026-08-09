import React from 'react';
import { View, ActivityIndicator, StyleSheet } from 'react-native';
import { Logo } from '../components/Logo';

export const SplashScreen = () => {
  return (
    <View style={styles.container}>
      <Logo size={68} showText={true} />
      <ActivityIndicator size="small" color="#FCBB00" style={{ marginTop: 24 }} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000000',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
