export interface SingerDetailInfo {
  videoCount:             number;
  identify:               SingerIdentify;
  artist:                 Artist;
  blacklist:              boolean;
  preferShow:             number;
  showPriMsg:             boolean;
  secondaryExpertIdentiy: SecondaryExpertIdentiy[];
}

export interface Artist {
  id:          number;
  cover:       string;
  avatar:      string;
  name:        string;
  transNames:  string[];
  alias:       string[];
  identities:  string[];
  identifyTag: null;
  briefDesc:   string;
  rank:        SingerRank;
  albumSize:   number;
  musicSize:   number;
  mvSize:      number;
}

export interface SingerRank {
  rank: number;
  type: number;
}

export interface SingerIdentify {
  imageUrl:  null;
  imageDesc: string;
  actionUrl: string;
}

export interface SecondaryExpertIdentiy {
  expertIdentiyId:    number;
  expertIdentiyName:  string;
  expertIdentiyCount: number;
}

export interface SingerItem {
  name: string;
  id: number;
  picId: number;
  img1v1Id: number;
  briefDesc: string;
  picUrl: string;
  img1v1Url: string;
  albumSize: number;
  mvSize?: number;
  alias: string[];
  trans: string;
  musicSize: number;
  topicPerson: number;
  picId_str: string;
  img1v1Id_str: string;
  followed: boolean;
  identityIconUrl?: string;
}