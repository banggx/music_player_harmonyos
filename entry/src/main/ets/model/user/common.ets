export interface UserAccount {
  id:                 number;
  userName:           string;
  type:               number;
  status:             number;
  whitelistAuthority: number;
  createTime:         number;
  tokenVersion:       number;
  ban:                number;
  baoyueVersion:      number;
  donateVersion:      number;
  vipType:            number;
  anonimousUser:      boolean;
  paidFee:            boolean;
}