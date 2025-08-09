import { SongItem } from "../model";

export function formatSongModel(song: SongItem) {
  if (song.artists && !song.ar) {
    song.ar = song.artists;
  }
  if (song.album && !song.al) {
    song.al = song.album;
  }
  if (song.alias && !song.alia) {
    song.alia = song.alias;
  }
  return song;
}