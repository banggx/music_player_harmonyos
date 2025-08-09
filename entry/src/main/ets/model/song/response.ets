import { CommonRes } from '../common'
import { SongItem, SongURLInfo, LyricInfo } from './common';

interface RecommendSongData {
  dailySongs: SongItem[];
}
export interface RecommendSongsRes extends CommonRes {
  data: RecommendSongData;
}

export interface GetSongDetailRes extends CommonRes {
  songs: SongItem[];
}

export interface GetSongURLRes extends CommonRes {
  data: SongURLInfo[];
}

export interface GetSongLyricRes extends CommonRes {
  lrc: LyricInfo;
}