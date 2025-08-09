import { CommonRes } from '../common';
import { AlbumItem } from './common';
import { SongItem } from '../song';

export interface GetAlbumInfoRes extends CommonRes {
  songs: SongItem[];
  album: AlbumItem;
}