import { CommonRes } from '../common';
import { Playlist } from './common';
import { SongItem } from '../song';

export interface GetHotPlaylistRes extends CommonRes {
  playlists: Playlist[]
}

export interface GetPlaylistDetailRes extends CommonRes {
  playlist: Playlist;
}

export interface GetPlaylistSongsRes extends CommonRes {
  songs: SongItem[];
}