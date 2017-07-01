namespace SimpleTodo {
	public class MainWindow : Gtk.Window {
		public MainWindow (Application simple_app) {
			Object (application: simple_app);
			title = "Simple";
		}

		construct {

			set_size_request (450, 400);
			set_hide_titlebar_when_maximized (false);

			init_layout ();
		}

		private void init_layout() {
			var grid = new Gtk.Grid ();
			grid.orientation = Gtk.Orientation.VERTICAL;
			grid.row_spacing = 6;

			var title_label = new Gtk.Label (_("Notifications"));
			var show_button = new Gtk.Button.with_label (_("Show"));

			show_button.clicked.connect ( () => {
					var notification = new Notification (_("Hello world"));
					notification.set_body (_("This is my first notification"));
					this.application.send_notification ("notify.app", notification);
				});

			grid.add (title_label);
			grid.add (show_button);

			this.add (grid);

			this.show_all ();
		}
	}
}
