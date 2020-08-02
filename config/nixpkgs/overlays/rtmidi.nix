self: super: {
  rtmidi = super.rtmidi.overrideAttrs (old: {
    name = "foo";
  });
}
