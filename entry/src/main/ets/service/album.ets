import { Service } from './_base';
import { GetAlbumInfoRes } from '../model';

export class AlbumService extends Service {
  getAlbumInfo(id: number): Promise<GetAlbumInfoRes> {
    return this.get<GetAlbumInfoRes>(`/album?id=${id}`);
  }
}