import { CommonRes } from '../common';
import { SingerDetailInfo, SingerItem } from './common';
import { SongItem } from '../song';

export interface GetSingerDetailInfoRes extends CommonRes {
  data: SingerDetailInfo;
}

export interface GetHotSingerRes extends CommonRes {
  artists: SingerItem[];
}

export interface GetSingerSongsRes extends CommonRes {
  songs: SongItem[];
  total: number;
}