import { Service } from './_base';
import { GetPlaylistDetailRes, GetPlaylistSongsRes } from '../model';

export class PlaylistService extends Service {
  getPlaylistDetail(id: number): Promise<GetPlaylistDetailRes> {
    return this.get<GetPlaylistDetailRes>(`/playlist/detail?id=${id}`);
  }

  getPlaylistSongs(id: number): Promise<GetPlaylistSongsRes> {
    return this.get<GetPlaylistSongsRes>(`/playlist/track/all?id=${id}`);
  }
}