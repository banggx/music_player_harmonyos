import { AlbumItem, AlbumSearchRes } from "../../model";
import { searchService } from "../../service";
import { SearchType } from '../../constants';
import { AlbumCell } from "../album/AlbumCell";
import { LoadMore } from '../common/LoadMore'

@ComponentV2
export struct AlbumResult {
  @Param @Require searchKey: string;
  @Local albums: AlbumItem[] = [];
  @Local count: number = 0;
  @Local loading: boolean = false;

  async searchAlbum() {
    this.loading = true;
    const offset = this.albums.length;
    const res = await searchService.search<AlbumSearchRes>(this.searchKey, SearchType.album, 30, offset);
    if (res.code === 200) {
      this.albums.push(...res.result.albums);
      this.count = res.result.albumCount;
    }
    this.loading = false;
  }

  async aboutToAppear() {
    this.searchAlbum();
  }

  build() {
    Column() {
      List({ space: 24 }) {
        ForEach(this.albums, (album: AlbumItem) => {
          ListItem() {
            AlbumCell({ album })
          }
        })
        ListItem() {
          LoadMore({ loading: this.loading })
        }
      }
      .layoutWeight(1)
      .onScrollIndex((_: number, end: number) => {
        if (end >= this.albums.length - 1 && this.albums.length < this.count) {
          this.searchAlbum();
        }
      })
    }.width('100%')
    .height('100%')
  }
}