    # sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
    {
      # services.flatpak.overrides = {
      #   "global" = {
      #     Context = {
      #       filesystems = [
      #         "xdg-config/gtk-4.0:ro"
      #         "xdg-config/gtk-3.0:ro"
      #       ];
      #     };
      #   };
      # };
      services.flatpak.packages = [
        # libadwaita theme on gtk3
        "org.gtk.Gtk3theme.adw-gtk3-dark"
        "org.gtk.Gtk3theme.adw-gtk3"
      ];
    }
