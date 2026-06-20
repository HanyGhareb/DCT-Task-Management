/**
 * profile.ts — read/update the signed-in user + raw-binary photo upload.
 */
import { api } from './client';
import type { Session } from './types';

export interface UserProfile {
  userId: number;
  displayName?: string;
  displayNameAr?: string;
  email?: string;
  orgName?: string;
  rolesCsv?: string;
  photoUrl?: string;
}

export async function getUser(userId: number): Promise<UserProfile> {
  return api.get<UserProfile>(`/users/${userId}`);
}

export async function updateUser(userId: number, fields: Partial<UserProfile>): Promise<void> {
  await api.put(`/users/${userId}`, fields);
}

/**
 * Upload a profile photo as raw bytes (no base64), mirroring api.putBinary →
 * PUT /dct/users/:id/photo. `file` is a Blob fetched from the image-picker URI.
 */
export async function uploadPhoto(userId: number, file: Blob, name: string, mime: string): Promise<void> {
  // Raw-binary endpoint (db/v2/29). The legacy /photo PUT is base64 (~24 KB cap);
  // /photobin reads :body as a BLOB so real phone photos upload uncapped.
  await api.putBinary(`/users/${userId}/photobin`, file, { mime, query: { name, mime } });
}

export function sessionToProfile(s: Session): UserProfile {
  return {
    userId: s.userId ?? 0,
    displayName: s.displayName,
    displayNameAr: s.displayNameAr,
    email: s.email,
    orgName: s.orgName,
    rolesCsv: s.rolesCsv,
    photoUrl: s.photoUrl,
  };
}
