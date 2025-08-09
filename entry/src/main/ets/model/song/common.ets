export interface SongItem {
  name:                 string;
  mainTitle:            null;
  additionalTitle:      null;
  id:                   number;
  pst:                  number;
  t:                    number;
  ar:                   Ar[];
  artists?:             Ar[];
  alia:                 string[];
  alias?:               string[];
  pop:                  number;
  st:                   number;
  rt:                   string;
  fee:                  number;
  v:                    number;
  crbt:                 null;
  cf:                   string;
  al:                   Al;
  album?:               Al;
  dt:                   number;
  h:                    H;
  m:                    H;
  l:                    H;
  sq:                   null;
  hr:                   null;
  a:                    null;
  cd:                   string;
  no:                   number;
  rtUrl:                null;
  ftype:                number;
  rtUrls:               string[];
  djId:                 number;
  copyright:            number;
  s_id:                 number;
  mark:                 number;
  originCoverType:      number;
  originSongSimpleData: null;
  tagPicList:           null;
  resourceState:        boolean;
  version:              number;
  songJumpInfo:         null;
  entertainmentTags:    null;
  awardTags:            null;
  displayTags:          null;
  single:               number;
  noCopyrightRcmd:      null;
  rtype:                number;
  rurl:                 null;
  mst:                  number;
  cp:                   number;
  mv:                   number;
  publishTime:          number;
  reason:               null;
  videoInfo:            VideoInfo;
  recommendReason:      null;
  recommendText?:       string;
  alg:                  string;
}

export interface Al {
  id:      number;
  name:    string;
  picUrl:  string;
  tns:     [];
  pic_str: string;
  pic:     number;
}

export interface Ar {
  id:    number;
  name:  string;
  tns:   [];
  alias: [];
}

export interface H {
  br:   number;
  fid:  number;
  size: number;
  vd:   number;
  sr:   number;
}

export interface VideoInfo {
  moreThanOne: boolean;
  video:       null;
}

export interface SongURLInfo {
  id:                     number;
  url:                    string;
  br:                     number;
  size:                   number;
  md5:                    string;
  code:                   number;
  expi:                   number;
  type:                   string;
  gain:                   number;
  peak:                   number;
  closedGain:             number;
  closedPeak:             number;
  fee:                    number;
  uf:                     null;
  payed:                  number;
  flag:                   number;
  canExtend:              boolean;
  freeTrialInfo:          FreeTrialInfo;
  level:                  string;
  encodeType:             string;
  channelLayout:          null;
  freeTrialPrivilege:     FreeTrialPrivilege;
  freeTimeTrialPrivilege: FreeTimeTrialPrivilege;
  urlSource:              number;
  rightSource:            number;
  podcastCtrp:            null;
  effectTypes:            null;
  time:                   number;
  message:                null;
  levelConfuse:           null;
  musicId:                string;
  accompany:              null;
  sr:                     number;
  auEff:                  null;
}

export interface FreeTimeTrialPrivilege {
  resConsumable:  boolean;
  userConsumable: boolean;
  type:           number;
  remainTime:     number;
}

export interface FreeTrialInfo {
  fragmentType: number;
  start:        number;
  end:          number;
  algData:      AlgData;
}

export interface AlgData {
  fragSource: string;
}

export interface FreeTrialPrivilege {
  resConsumable:      boolean;
  userConsumable:     boolean;
  listenType:         null;
  cannotListenReason: null;
  playReason:         null;
  freeLimitTagType:   null;
}

export interface LyricInfo {
  version: number;
  lyric: string;
}

export interface FormatLyricItem {
  time: number;
  text: string;
}
