import { Playlist, PlaylistSearchRes } from "../../model";
import { searchService } from "../../service";
import { SearchType } from '../../constants';
import { PlaylistCell } from "../playlist/PlaylistCell";
import { LoadMore } from '../common/LoadMore'

@ComponentV2
export struct PlaylistResult {
  @Param @Require searchKey: string;
  @Local playlists: Playlist[] = [];
  @Local count: number = 0;
  @Local loading: boolean = false;

  async searchPlaylist() {
    this.loading = true;
    const offset = this.playlists.length;
    const res = await searchService.search<PlaylistSearchRes>(this.searchKey, SearchType.playlist, 30, offset);
    if (res.code === 200) {
      this.playlists.push(...res.result.playlists);
      this.count = res.result.playlistCount;
    }
    this.loading = false;
  }

  async aboutToAppear() {
    this.searchPlaylist();
  }

  build() {
    Column() {
      List({ space: 24 }) {
        ForEach(this.playlists, (playlist: Playlist) => {
          ListItem() {
            PlaylistCell({ playlist })
          }
        })
        ListItem() {
          LoadMore({ loading: this.loading })
        }
      }
      .layoutWeight(1)
      .onScrollIndex((_: number, end: number) => {
        if (end >= this.playlists.length - 1 && this.playlists.length < this.count) {
          this.searchPlaylist();
        }
      })
    }.width('100%')
    .height('100%')
  }
}