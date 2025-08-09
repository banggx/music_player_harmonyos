import { CommonRes } from '../common';
import { UserAccount } from './common';

export interface GetLoginStatusRes extends CommonRes {
  account: UserAccount;
  profile: null;
}