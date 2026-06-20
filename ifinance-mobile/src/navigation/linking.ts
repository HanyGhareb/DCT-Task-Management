/**
 * linking.ts — deep-link config so a push tap routes to the right screen.
 * Push payload { module, sourceType, sourceId } maps to an approvals deep link;
 * the Approvals tab opens and (when matched) pushes the detail.
 */
import type { LinkingOptions } from '@react-navigation/native';
import type { RootStackParamList } from './types';

export const linking: LinkingOptions<RootStackParamList> = {
  prefixes: ['ifinance://'],
  config: {
    screens: {
      Tabs: {
        screens: {
          Approvals: 'approvals',
          Notifications: 'notifications',
          Delegations: 'delegations',
          Profile: 'profile',
        },
      },
    },
  },
};
