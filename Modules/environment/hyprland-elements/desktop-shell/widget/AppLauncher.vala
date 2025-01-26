public void hideLauncher() {
    AstalIO.Process.exec_async(@"astal -i vala -t AppLauncher");
}

class AppEntry : Gtk.Entry {

    public AppEntry() {
        Object(
            visible: true
        );

        //this.set_text ("hello, world!");
        this.set_placeholder_text ("Search...");
        //this.grab_focus();

        Astal.widget_set_class_names(this, {"AppEntry"});
    }
}


public Gtk.Button AppButton(AstalApps.Application app) {

    Gtk.Button btn = new Gtk.Button();

    Astal.Label label = new Astal.Label();

    btn.add(label);
    
    label.label = app.name;

    btn.clicked.connect(() => {
        app.launch();
        hideLauncher();
    });

    return btn;
}

public Gtk.Button AppButton2() {

    Gtk.Button btn = new Gtk.Button();

    Astal.Label label = new Astal.Label();

    btn.add(label);
    
    label.label = "aaa";

    btn.clicked.connect(() => {
        //app.launch();
        hideLauncher();
    });

    return btn;
}

class AppContainer : Astal.Box {
    
    Astal.Label label = new Astal.Label();
    Gtk.Entry appEntry = new AppEntry();

    public AppContainer() {
        Object(
            visible: true,
            vertical: true
        );

        var apps = new AstalApps.Apps() {
            name_multiplier = 2,
            entry_multiplier = 2,
            executable_multiplier = 2,
        };

        this.add(AppButton(apps.fuzzy_query("firefox").nth_data(0)));

        label.label = "test";
        add(appEntry);

        appEntry.activate.connect (() => {
			string str = appEntry.get_text();
			//print("%s\n", str);
            var searchedApps = apps.fuzzy_query(str);

            print(searchedApps.nth_data(0).name);
            searchedApps.nth_data(0).launch();
            hideLauncher();
            appEntry.set_text ("");
		});

        appEntry.changed.connect (() => {
            
            string str = appEntry.get_text();
            var searchedApps = apps.fuzzy_query(str);
			//print("%s\n", str);
            //foreach (var app in apps.fuzzy_query(str)) {
            //    print(app.name);
            //}

            var children = this.get_children();
            foreach (Gtk.Widget element in children)
            if (element != appEntry)
            this.remove (element);

            for (int i = 0; i <= 8; i++) {

                if (i < apps.fuzzy_query(str).length()) {
                    print(searchedApps.nth_data(i).name);
                    add(AppButton(searchedApps.nth_data(i)));
                }
            }
        });


        show_all();
    }
}

class AppLauncher : Astal.Window {

    public AppLauncher() {
        Object(
            //anchor: Astal.WindowAnchor.BOTTOM
            //    | Astal.WindowAnchor.LEFT
            //    | Astal.WindowAnchor.RIGHT,
            //exclusivity: Astal.Exclusivity.EXCLUSIVE,
            visible: false,
            keymode: Astal.Keymode.EXCLUSIVE
        );


        Astal.widget_set_class_names(this, {"AppLauncher"});


        add(new AppContainer());
  
    }
}