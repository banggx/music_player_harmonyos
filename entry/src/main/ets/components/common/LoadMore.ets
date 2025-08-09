@ComponentV2
export struct LoadMore {
  @Param loading: boolean = false;

  build() {
    Row() {
      LoadingProgress().height(32).width(48)
    }.width("100%")
    .height(64)
    .justifyContent(FlexAlign.Center)
    .visibility(this.loading ? Visibility.Visible : Visibility.Hidden)
  }
}