import { songService } from '../service';
import { MusicPlayer } from '../utils/player';
import { SongItem } from '../model';
import { PlayMode } from '../constants';

interface SongInfo {
  song: SongItem;
  url: string;
}

@ObservedV2
export class PlayerStore {
  @Trace
  songs: number[] = [];
  @Trace
  current: SongInfo | null = null;
  @Trace
  currentIndex: number = 0;
  @Trace
  songCache: Record<number, SongInfo> = {};
  @Trace
  prepareSongs: Map<number, Promise<void>> = new Map();
  @Trace
  playMode: PlayMode = PlayMode.linear;
  // 当前已经播放过的音乐id
  @Trace
  visitedSongs: number[] = [];
  musicPlayer = new MusicPlayer();

  release() {
    this.musicPlayer.player?.release();
    this.songs = [];
    this.songCache = {};
    this.prepareSongs.clear();
  }

  addSongs(songs: number[]) {
    this.songs.push(...songs);
    this.prepareSong(songs);
  }

  removeSongs(songs: number[]) {
    this.songs = this.songs.filter(song => !songs.includes(song));
    this.visitedSongs = this.visitedSongs.filter(song => !songs.includes(song));
  }

  clearSongs() {
    this.songs = [];
    this.songCache = {};
    this.prepareSongs.clear();
  }

  updatePlayMode(mode: PlayMode) {
    this.playMode = mode;
  }

  playSong(song: number) {
    let songIndex = this.songs.indexOf(song);
    if (songIndex === -1) {
      songIndex = this.songs.push(song);
    }
    return new Promise<void>(async (resolve, reject) => {
      if (!this.songCache[song]) {
        await this.prepareSong([song]);
      }
      const songInfo = this.songCache[song];
      if (!songInfo) {
        reject(new Error('准备数据失败'))
        return;
      };
      await this.musicPlayer.player?.reset();
      this.current = songInfo;
      this.currentIndex = songIndex;
      this.visitedSongs.push(song);
      this.musicPlayer.init(songInfo.url, () => {
        resolve();
      });
    });
  }

  prepareSong(songs: number[]) {
    const newSongs = songs.filter((song: number) => !this.songCache[song] && !this.prepareSongs.has(song));
    if (newSongs.length) {
      const promise: Promise<void> = new Promise(async (resolve) => {
        const res = await songService.getSongDetail(newSongs);
        const playRes = await songService.getSongURL(newSongs);
        if (res.code === 200 && playRes.code === 200) {
          const songInfoMap = res.songs.reduce<Record<number, SongItem>>((map, item) => {
            map[item.id] = item;
            return map;
          }, {});
          playRes.data.forEach(item => {
            if (songInfoMap[item.id]) {
              this.songCache[item.id] = {
                song: songInfoMap[item.id],
                url: item.url
              };
            }
          })
        }
        newSongs.forEach((id) => {
          this.prepareSongs.delete(id);
        });
        resolve();
      });
      newSongs.forEach((id) => {
        this.prepareSongs.set(id, promise);
      });
    }
    const prepareSet = new Set<Promise<void>>();
    songs.forEach((song) => {
      if (this.prepareSongs.has(song)) {
        prepareSet.add(this.prepareSongs.get(song)!);
      }
    });
    return Promise.all(Array.from(prepareSet))
  }

  getNextSong(): number | undefined {
    if (!this.songs.length) return;
    switch (this.playMode) {
      case PlayMode.linear:
        return this.songs[(this.currentIndex + 1) % this.songs.length];
      case PlayMode.random: {
        let songList = this.songs.filter(song => !this.visitedSongs.includes(song));
        if (!songList.length) {
          this.visitedSongs = [];
          songList = this.songs;
        }
        return songList[Math.floor(Math.random() * songList.length)];
      }
      case PlayMode.circle:
        return this.current?.song.id;
    }
  }

  getPrevSong(): number | undefined {
    if (!this.songs.length) return;
    switch (this.playMode) {
      case PlayMode.linear:
        const index = this.currentIndex - 1 >= 0 ? this.currentIndex - 1 : this.songs.length - 1;
        return this.songs[index];
      case PlayMode.random: {
        let songList = this.songs.filter(song => !this.visitedSongs.includes(song));
        if (!songList.length) {
          this.visitedSongs = [];
          songList = this.songs;
        }
        return songList[Math.floor(Math.random() * songList.length)];
      }
      case PlayMode.circle:
        return this.current?.song.id;
    }
  }

  updateSeek(ms: number) {
    this.musicPlayer.player?.seek(ms);
  }
}