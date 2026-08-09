import React from 'react';
import { View, Text, Image, StyleSheet } from 'react-native';

export const Logo = ({ size = 36, showText = true, textColor = '#FAFAFA' }) => {
  return (
    <View style={styles.container}>
      <Image
        source={require('../../assets/icon.png')}
        style={{ width: size, height: size, borderRadius: size * 0.25 }}
      />
      {showText && (
        <Text style={[styles.text, { fontSize: size * 0.55, color: textColor }]}>
          growthBox
        </Text>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  text: {
    fontWeight: '700',
    marginLeft: 10,
    letterSpacing: -0.5,
  },
});
