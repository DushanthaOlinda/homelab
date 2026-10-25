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
- **Long transfers over Wi-Fi drop.** A 64 GB rsync died halfway with "broken pipe". Fixed with
  SSH keepalives (`ServerAliveInterval 30` in `~/.ssh/config`) and a retry loop
  (`until rsync ...; do sleep 15; done`); `--partial` meant nothing was lost.
- **Phone photos carry GPS coordinates.** Strip location data before publishing any photo of the setup.
- **A loose Ethernet cable is a single point of failure.** A bumped cable dropped the server for
  3 seconds, which also means DNS for every device using AdGuard. Seat cables firmly; plan for a fallback.
- **Mac-to-Mac at home: SSH + Universal Control, not Screen Sharing/AirPlay.**
  SSH (key-only, `from=` home LAN, `!192.168.1.200` to block the Tailscale
  subnet-router path, `AddressFamily inet`) handles git and files. Screen Sharing
  and AirPlay-as-extended-display were slow over Wi-Fi, and a half-closed Screen
  Sharing session locked the display brightness until a reboot. Both turned off.
- **A bus-powered drive on a USB 2.0 port dropped off after spin-down.** SMART
  polling woke it, spin-up drew too much power, the bridge crashed. Moved to
  USB 3.0; SMART timer disabled until it can skip sleeping drives.
- **Debian's node-exporter hides `/mnt` and `/media` by default.** The
  "drive missing" alert saw nothing until the exclude flag was overridden in
  `/etc/default/prometheus-node-exporter`. Check `--help` for real defaults.
- **Building views isn't enough, the libraries must use them.** Movies still
  pointed at raw `/media/wd`, so every episode became a "movie" (2,731 → 666
  after fixing). Check `/var/lib/jellyfin/root/default/*/*.mblink`.
- **Jellyfin's A–Z filter uses the sort title.** Watch-order sort titles hid
  Iron Man under "M"; ordered playlists are the right tool.
- **`count()` of nothing is "No data", not 0.** Append `or vector(0)`.
- **macOS `scp` doesn't expand `{a,b}` on the remote side.** Use `tar` over ssh.
- **SSH `from=` restrictions are address-family specific.** A Bonjour `.local`
  name connected over IPv6 link-local and the IPv4-only `from=` rejected the
  key. Fixed with `AddressFamily inet`.
- **Caddy 2.6.2 swapped in its own root when it rotated the intermediate.** A
  week after setup, the auto-renewed intermediate was signed by a Caddy-generated
  "Olinda Homelab CA - 2026 ECC Root" instead of our name-constrained root, so every
  device saw ERR_CERT_AUTHORITY_INVALID. Found by comparing the intermediate's
  Authority Key Identifier with the trusted root's Subject Key Identifier. Fix: our
  own 2-year intermediate (also name-constrained) passed to Caddy via
  `pki { ca { intermediate { ... } } }`, so Caddy never generates one.
