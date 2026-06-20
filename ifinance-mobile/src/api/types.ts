/**
 * types.ts — typed shapes of the ORDS responses the MVP consumes.
 * Field names match the APEX_JSON keys in db/v2/11_dct_ords.sql exactly.
 * APEX_JSON omits NULL keys, so every nullable field is optional here.
 */

export interface Session {
  sessionId: string;
  userId?: number;
  displayName?: string;
  displayNameAr?: string;
  email?: string;
  orgName?: string;
  rolesCsv?: string;
  roles?: string[];
  photoUrl?: string;
}

/** GET /approvals/pending → { items: PendingApproval[] } */
export interface PendingApproval {
  instanceId: number;
  requestRef: string;
  module: string; // source_module discriminator (PETTY_CASH, TRAVEL_REQUEST, …)
  templateName: string;
  requestedBy: string;
  requestedAt: string; // 'YYYY-MM-DD HH24:MI'
  amount: number;
  currentStep: number;
  totalSteps: number;
  currentStepName: string;
  actingFor?: string | null; // present when acting via delegation
}

export type ApprovalAction = 'APPROVED' | 'REJECTED' | 'RETURNED';

/** GET /notifications/ → { items: Notification[] } */
export interface AppNotification {
  notifId: number;
  title: string;
  body?: string;
  type?: string;
  isRead: 'Y' | 'N';
  createdAt: string; // ISO
}

/** GET /delegations/?mine=Y → { items: Delegation[] } */
export interface Delegation {
  delegationId: number;
  delegatorId: number;
  delegatorName: string;
  delegateId: number;
  delegateName: string;
  scope: 'ALL_ROLES' | 'SPECIFIC_ROLE' | 'MODULE';
  roleCode?: string;
  roleName?: string;
  moduleCode?: string;
  moduleName?: string;
  startDate: string;
  endDate: string;
  reason?: string;
  status: 'ACTIVE' | 'EXPIRED' | 'CANCELLED';
  createdAt?: string;
}

export interface CreateDelegationInput {
  delegateId: number;
  scope?: 'ALL_ROLES' | 'SPECIFIC_ROLE' | 'MODULE';
  roleId?: number;
  moduleCode?: string;
  startDate?: string; // YYYY-MM-DD
  endDate: string; // YYYY-MM-DD
  reason?: string;
}

/** Normalized API error surfaced to UI. */
export interface ApiError {
  status: number;
  message: string;
}
