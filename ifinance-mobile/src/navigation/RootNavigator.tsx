/**
 * RootNavigator — bottom tabs (≤5, ui-ux-pro-max bottom-nav-limit) + a native
 * stack for detail/modal routes. Badge on Approvals (pending) and Notifications
 * (unread), polled cheaply.
 */
import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { useQuery } from '@tanstack/react-query';
import { Ionicons } from '@expo/vector-icons';
import { getPending } from '@/api/approvals';
import { getUnreadCount } from '@/api/notifications';
import { useHasRole } from '@/state/session';
import { config } from '@/config';
import { useTheme } from '@/theme/ThemeProvider';
import { useI18n } from '@/i18n/I18nProvider';
import type { RootStackParamList, TabParamList } from './types';
import { ApprovalsScreen } from '@/screens/ApprovalsScreen';
import { ApprovalDetailScreen } from '@/screens/ApprovalDetailScreen';
import { NotificationsScreen } from '@/screens/NotificationsScreen';
import { DelegationsScreen } from '@/screens/DelegationsScreen';
import { ProfileScreen } from '@/screens/ProfileScreen';
import { NewDelegationScreen } from '@/screens/NewDelegationScreen';
import { OutboxScreen } from '@/screens/OutboxScreen';
import { AtdDashboardScreen } from '@/screens/atd/AtdDashboardScreen';
import { AtdJobsScreen } from '@/screens/atd/AtdJobsScreen';
import { AtdRunsScreen } from '@/screens/atd/AtdRunsScreen';
import { AtdRunDetailScreen } from '@/screens/atd/AtdRunDetailScreen';
import { AtdQueueScreen } from '@/screens/atd/AtdQueueScreen';
import { AtdEnvironmentsScreen } from '@/screens/atd/AtdEnvironmentsScreen';
import { AtdTargetsScreen } from '@/screens/atd/AtdTargetsScreen';
import { AtdRunnerSettingsScreen } from '@/screens/atd/AtdRunnerSettingsScreen';
import { AtdDiscoveryScreen } from '@/screens/atd/AtdDiscoveryScreen';

const Tab = createBottomTabNavigator<TabParamList>();
const Stack = createNativeStackNavigator<RootStackParamList>();

function Tabs() {
  const { palette } = useTheme();
  const { t } = useI18n();
  const isAtdAdmin = useHasRole('SYS_ADMIN');

  const { data: pending } = useQuery({
    queryKey: ['approvals', 'pending'],
    queryFn: getPending,
    select: (items) => items.length,
    refetchInterval: config.notifPollMs,
  });
  const { data: unread } = useQuery({
    queryKey: ['notifications', 'count'],
    queryFn: getUnreadCount,
    refetchInterval: config.notifPollMs,
  });

  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: palette.brand,
        tabBarInactiveTintColor: palette.textMuted,
        tabBarStyle: { backgroundColor: palette.surface, borderTopColor: palette.border },
      }}
    >
      <Tab.Screen
        name="Approvals"
        component={ApprovalsScreen}
        options={{
          title: t('tab.approvals'),
          tabBarBadge: pending ? pending : undefined,
          tabBarIcon: ({ color, size }) => <Ionicons name="checkbox" color={color} size={size} />,
        }}
      />
      <Tab.Screen
        name="Notifications"
        component={NotificationsScreen}
        options={{
          title: t('tab.notifications'),
          tabBarBadge: unread ? unread : undefined,
          tabBarIcon: ({ color, size }) => <Ionicons name="notifications" color={color} size={size} />,
        }}
      />
      <Tab.Screen
        name="Delegations"
        component={DelegationsScreen}
        options={{
          title: t('tab.delegations'),
          tabBarIcon: ({ color, size }) => <Ionicons name="people" color={color} size={size} />,
        }}
      />
      {isAtdAdmin ? (
        <Tab.Screen
          name="Analytics"
          component={AtdDashboardScreen}
          options={{
            title: t('tab.analytics'),
            tabBarIcon: ({ color, size }) => <Ionicons name="analytics" color={color} size={size} />,
          }}
        />
      ) : null}
      <Tab.Screen
        name="Profile"
        component={ProfileScreen}
        options={{
          title: t('tab.profile'),
          tabBarIcon: ({ color, size }) => <Ionicons name="person-circle" color={color} size={size} />,
        }}
      />
    </Tab.Navigator>
  );
}

export function RootNavigator() {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="Tabs" component={Tabs} />
      <Stack.Screen name="ApprovalDetail" component={ApprovalDetailScreen} />
      <Stack.Screen name="NewDelegation" component={NewDelegationScreen} options={{ presentation: 'modal' }} />
      <Stack.Screen name="Outbox" component={OutboxScreen} />
      <Stack.Screen name="AtdJobs" component={AtdJobsScreen} />
      <Stack.Screen name="AtdRuns" component={AtdRunsScreen} />
      <Stack.Screen name="AtdRunDetail" component={AtdRunDetailScreen} />
      <Stack.Screen name="AtdQueue" component={AtdQueueScreen} />
      <Stack.Screen name="AtdEnvironments" component={AtdEnvironmentsScreen} />
      <Stack.Screen name="AtdTargets" component={AtdTargetsScreen} />
      <Stack.Screen name="AtdRunnerSettings" component={AtdRunnerSettingsScreen} />
      <Stack.Screen name="AtdDiscovery" component={AtdDiscoveryScreen} />
    </Stack.Navigator>
  );
}
