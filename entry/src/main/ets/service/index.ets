import { CommonService } from './common';
import { SingerService } from './singer';
import { SongService } from './song';
import { PlaylistService } from './playlist';
import { SearchService } from './search';
import { UserService } from './user';
import { AlbumService } from './album';

export const commonService = new CommonService();
export const singerService = new SingerService();
export const songService = new SongService();
export const playlistService = new PlaylistService();
export const searchService = new SearchService();
export const userService = new UserService();
export const albumService = new AlbumService();