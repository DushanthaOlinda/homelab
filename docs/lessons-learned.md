# Lessons learned

- **Clock drift breaks apt.** Installed offline with a wrong BIOS clock; chrony fixed it once online.
- **Multi-line pastes + interactive commands = surprises.** Lines after `tmux` or `ssh` queue up and run
  later in the wrong shell. This produced two concurrent `f3write` runs and commands run on the wrong host.
  Paste interactive commands one at a time.
- **`echo ... >> /etc/fstab` with a failing `$(...)`** appended `UUID= ` with an empty value. Always
  `tail` fstab after editing and test with `mount -a`.
- **`/dev/sdX` names are not stable.** The two USB drives swapped between plug-ins → always use UUIDs.
- **Bus power limits.** Two 2.5" HDDs on one laptop caused USB reset loops; a different port fixed it.
- **macOS DNS is interface-wide**, not per network like iOS. Setting it on a laptop that travels breaks DNS on every other network.
- **ntfs3 won't remount rw with an unreplayed journal**, which turned out to reinforce the read-only decision.
- **Folder names matter to Jellyfin.** Cryptic release names caused shows to be scanned as movies; searching
  for `SxxEyy` *file* names was far more reliable than guessing from folder names.
- **Browsers lack many codecs**: no audio until transcoding was configured. Native clients direct-play far more.
- **Secrets pasted into chat count as exposed**, so the API token was rotated straight away.
