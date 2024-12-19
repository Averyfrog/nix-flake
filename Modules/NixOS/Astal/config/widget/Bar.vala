public Gtk.Label MaterialIcon(string icon, int size, string className) {
    // Gets a google icon as a label!
    Astal.Label googleicon = new Astal.Label() { label = icon };
    Astal.widget_set_class_names(googleicon, {"material-symbols-rounded", className});
    Astal.widget_set_css(googleicon, @"font-size: $(size)px;");
    return googleicon;
}

class Workspaces : Gtk.Box {
    AstalHyprland.Hyprland hypr = AstalHyprland.get_default();
    public Workspaces() {
        Astal.widget_set_class_names(this, {"Workspaces"});
        for (int ws = 1; ws <= 9; ws++) {
            add(button(ws));
        }
        
        //hypr.notify["workspaces"].connect(sync);
        //sync();
    }

    //void sync() {
    //     print("AAAA");
    // }

    void focusedWorkspaceCheck(Gtk.Button btn, int ws) {
        var focused = hypr.focused_workspace.id == ws;
        if (focused) {
            Astal.widget_toggle_class_name(btn, "focused", true);
        } else {
            Astal.widget_toggle_class_name(btn, "focused", false);
        }
    }

    Gtk.Button button(int ws) {
        Gtk.Button btn = new Gtk.Button() {
            visible = true,
            //label = ws.to_string()

        };

        Gtk.Box bx = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1) {
            visible = true,
            vexpand = false,
            hexpand = false
            //label = ws.to_string()

        };
        Astal.widget_set_class_names(bx, {"wsIndicator"});
        btn.add(bx);
        Astal.widget_set_class_names(btn, {"Workspace", @"ws$(ws)"});      
        
        hypr.notify["focused-workspace"].connect(() => {
            focusedWorkspaceCheck(btn, ws);
        });
        focusedWorkspaceCheck(btn, ws);
        
        btn.clicked.connect(() => {
            AstalIO.Process.exec_async(@"hyprctl dispatch workspace $(ws)");
        });
        
        return btn;
    }
}

class FocusedClient : Gtk.Box {

    public FocusedClient() {
        Astal.widget_set_class_names(this, {"Focused"});
        AstalHyprland.get_default().notify["focused-client"].connect(sync);
        sync();
    }

    void sync() {
        foreach (var child in get_children())
            child.destroy();

        var client = AstalHyprland.get_default().focused_client;
        if (client == null)
            return;

        var label = new Gtk.Label(client.title) { visible = true };
        client.bind_property("title", label, "label", BindingFlags.SYNC_CREATE);
        add(label);
    }
}

class Media : Gtk.Button {
    Gtk.Box mediaBox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

    AstalMpris.Mpris mpris = AstalMpris.get_default();

    public Media() {
        Astal.widget_set_class_names(this, {"Media"});
        mpris.notify["players"].connect(sync);
        sync();

        add(mediaBox);

        this.clicked.connect(() => {
            mpris.players.nth_data(0).play_pause();
        });
    }

    void sync() {
        foreach (var child in mediaBox.get_children())
            child.destroy();

        if (mpris.players.length() == 0) {
            mediaBox.add(new Gtk.Label("Nothing Playing"));
            return;
        }

        var player = mpris.players.nth_data(0);
        var artistLabel = new Gtk.Label(null) { max_width_chars = 25, ellipsize = 3 };
        var titleLabel = new Gtk.Label(null) { max_width_chars = 20, ellipsize = 3 };
        var cover = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0) {
            valign = Gtk.Align.CENTER
        };


        Astal.widget_set_class_names(cover, {"Cover"});
        player.bind_property("title", titleLabel, "label", BindingFlags.SYNC_CREATE, (_, src, ref trgt) => {
            var title = player.title;
            trgt.set_string(@"$(title)");
            return true;
        });

        player.bind_property("artist", artistLabel, "label", BindingFlags.SYNC_CREATE, (_, src, ref trgt) => {
            var artist = player.artist;
            trgt.set_string(@" / $(artist)");
            return true;
        });
        //mediaBox.add(cover);
        mediaBox.add(titleLabel);
        mediaBox.add(artistLabel);
    }
}

class Wifi : Astal.Icon {
    public Wifi() {
        Astal.widget_set_class_names(this, {"Wifi"});
        var wifi = AstalNetwork.get_default().wifi;
        wifi.bind_property("ssid", this, "tooltip-text", BindingFlags.SYNC_CREATE);
        wifi.bind_property("icon-name", this, "icon", BindingFlags.SYNC_CREATE);
    }
}

class AudioSlider : Gtk.Box {
    Astal.Icon icon = new Astal.Icon();
    Astal.Slider slider = new Astal.Slider() { hexpand = true };

    public AudioSlider() {
        add(icon);
        add(slider);
        Astal.widget_set_class_names(this, {"AudioSlider"});
        Astal.widget_set_css(this, "min-width: 140px");

        var speaker = AstalWp.get_default().audio.default_speaker;
        speaker.bind_property("volume-icon", icon, "icon", BindingFlags.SYNC_CREATE);
        speaker.bind_property("volume", slider, "value", BindingFlags.SYNC_CREATE);
        slider.dragged.connect(() => speaker.volume = slider.value);
    }
}

class Battery : Gtk.Box {
    Astal.Icon icon = new Astal.Icon();
    Astal.Label label = new Astal.Label();

    public Battery() {
        add(icon);
        add(label);
        Astal.widget_set_class_names(this, {"Battery"});

        var bat = AstalBattery.get_default();
        bat.bind_property("is-present", this, "visible", BindingFlags.SYNC_CREATE);
        bat.bind_property("battery-icon-name", icon, "icon", BindingFlags.SYNC_CREATE);
        bat.bind_property("percentage", label, "label", BindingFlags.SYNC_CREATE, (_, src, ref trgt) => {
            var p = Math.floor(src.get_double() * 100);
            trgt.set_string(@"$p%");
            return true;
        });
    }
}

class ClockBox : Gtk.Box {

    Astal.Label timeHours = new Astal.Label();
    Astal.Label timeMins = new Astal.Label();
    AstalIO.Time interval;

    void sync() {
        timeHours.label = new DateTime.now_local().format("%H");
        timeMins.label = new DateTime.now_local().format("%M");
    }

    public ClockBox() {
        Astal.widget_set_class_names(this, {"ClockBox"});

        add(MaterialIcon("schedule", 16, "ClockIcon"));
        add(timeHours);
        add(timeMins);

        interval = AstalIO.Time.interval(1000, null);
        interval.now.connect(sync);
        destroy.connect(interval.cancel);
    }
}

class Clock : Gtk.Button {

    public Clock() {
        
        Astal.widget_set_class_names(this, {"Clock"});

        add(new ClockBox());
    }

}



class Left : Gtk.Box {
    public Left() {
        Object(hexpand: true, halign: Gtk.Align.START);
        add(new Workspaces());
        //add(new FocusedClient());
    }
}

class Center : Gtk.Box {
    public Center() {
        add(new Media());
    }
}

class Right : Gtk.Box {
    public Right() {
        Object(hexpand: true, halign: Gtk.Align.END);
        //add(new Wifi());
        add(new AudioSlider());
        //add(new Battery());
        add(new Clock());
    }
}

class Bar : Astal.Window {
    public Bar() {
        Object(
            anchor: Astal.WindowAnchor.TOP
                | Astal.WindowAnchor.LEFT
                | Astal.WindowAnchor.RIGHT,
            exclusivity: Astal.Exclusivity.EXCLUSIVE,
            //gdkmonitor: monitor,
            name: "Bar"
            //application = App
        );

        Astal.widget_set_class_names(this, {"Bar"});

        add(new Astal.CenterBox() {
            start_widget = new Left(),
            center_widget = new Center(),
            end_widget = new Right(),
        });

        show_all();
    }
}
