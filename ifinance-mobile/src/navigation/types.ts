import type { PendingApproval } from '@/api/types';

export type RootStackParamList = {
  Tabs: undefined;
  ApprovalDetail: { approval: PendingApproval };
  NewDelegation: undefined;
  Outbox: undefined;
  AtdJobs: undefined;
  AtdRuns: undefined;
  AtdRunDetail: { runId: number };
  AtdQueue: undefined;
  AtdEnvironments: undefined;
  AtdTargets: undefined;
  AtdRunnerSettings: undefined;
  AtdDiscovery: undefined;
};

export type TabParamList = {
  Approvals: undefined;
  Notifications: undefined;
  Delegations: undefined;
  Analytics: undefined;
  Profile: undefined;
};
