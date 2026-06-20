import type { PendingApproval } from '@/api/types';

export type RootStackParamList = {
  Tabs: undefined;
  ApprovalDetail: { approval: PendingApproval };
  NewDelegation: undefined;
  Outbox: undefined;
  AtdJobs: undefined;
  AtdRuns: undefined;
  AtdRunDetail: { runId: number };
};

export type TabParamList = {
  Approvals: undefined;
  Notifications: undefined;
  Delegations: undefined;
  Analytics: undefined;
  Profile: undefined;
};
