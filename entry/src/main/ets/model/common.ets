export interface CommonRes {
  code: number;
  name: string;
}

export interface PrivateContent {
  id: number;
  url: string;
  picUrl: string;
  sPicUrl: string;
  type: number;
  copywriter: string;
  name: string;
  alg: string;
}

export interface PrivateContentRes extends CommonRes {
  result: PrivateContent[];
}

