import { registerRootComponent } from 'expo';
import App from './App';
import { initializeMonitoring, Sentry } from './src/services/monitoring';

initializeMonitoring();

// registerRootComponent calls AppRegistry.registerComponent('main', () => App)
// and ensures the environment is set up appropriately for Expo (Expo Go + native builds).
registerRootComponent(Sentry.wrap(App));
