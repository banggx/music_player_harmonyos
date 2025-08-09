import { CommonRes } from '../common';
import { SongItem } from '../song';
import { Playlist } from '../playlist';
import { SingerItem } from '../singer';
import { AlbumItem } from '../ablum';
import { HotSearchInfo, SearchSuggest } from './common';

export interface GetSearchHotSongRes extends CommonRes {
  data: HotSearchInfo[];
}

interface SuggestResult {
  allMatch: SearchSuggest[];
}
export interface GetSearchSuggest extends CommonRes {
  result: SuggestResult;
}

interface ComplexSongInfo {
  moreText: string;
  songs: SongItem[];
  more: boolean;
}
interface ComplexPlaylistInfo {
  moreText: string;
  more: boolean;
  playLists: Playlist[];
}
interface ComplexSingerInfo {
  moreText: string;
  more: boolean;
  artists: SingerItem[];
}
interface ComplexAlbumInfo {
  moreText: string;
  more: boolean;
  albums: AlbumItem[];
}
export interface SimQueryItem {
  keyword: string;
  alg: string;
}
interface SimQueryInfo {
  sim_querys: Array<SimQueryItem>;
  more: boolean;
}
export interface ComplexSearchResult {
  code: number;
  song: ComplexSongInfo;
  playList: ComplexPlaylistInfo;
  artist: ComplexSingerInfo;
  album: ComplexAlbumInfo;
  sim_query: SimQueryInfo;
}
export interface ComplexSearchRes extends CommonRes {
  result: ComplexSearchResult;
}

interface SongSearchResult {
  songs: SongItem[];
  hasMore: boolean;
  songCount: 300;
}
export interface SongSearchRes extends CommonRes {
  result: SongSearchResult;
}

interface PlaylistSearchResult {
  playlists: Playlist[];
  hasMore: boolean;
  playlistCount: number;
  hlWords: string[];
}
export interface PlaylistSearchRes extends CommonRes {
  result: PlaylistSearchResult;
}

interface AlbumSearchResult {
  hlWords: string[];
  albums: AlbumItem[];
  albumCount: number;
}
export interface AlbumSearchRes extends CommonRes {
  result: AlbumSearchResult;
}

interface SingerSearchResult {
  hasMore: boolean;
  artistCount: number;
  artists: SingerItem[];
  hlWords: string[];
}
export interface SingerSearchRes extends CommonRes {
  result: SingerSearchResult;
}