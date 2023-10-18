export interface ISafetyChecker {
     (subId: string, permissions: string[]): Promise<void>;
 }