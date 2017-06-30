/*
* -*- compile-command: "make" -*-
*
* Copyright (c) 2017 Rodrigo Valin
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Rodrigo Valin <licorna@gmail.com>
*/

namespace SimpleTodo {
	public class Application : Granite.Application {
		public Application() {
			Object (application_id: "com.github.licorna.simpletodo",
					flags: ApplicationFlags.FLAGS_NONE);
		}

		protected override void activate () {
			var app_window = new Gtk.ApplicationWindow (this);
			app_window.title = "Simple TODO";
			app_window.set_default_size (600, 500);
		
			var grid = new Gtk.Grid ();
			grid.orientation = Gtk.Orientation.VERTICAL;
			grid.row_spacing = 6;

			var title_label = new Gtk.Label (_("Notifications"));
			var show_button = new Gtk.Button.with_label (_("Show"));

			show_button.clicked.connect ( () => {
					var notification = new Notification (_("Hello world"));
					notification.set_body (_("This is my first notification"));
					this.send_notification ("notify.app", notification);
				});

			grid.add (title_label);
			grid.add (show_button);

			app_window.add (grid);

			app_window.show_all ();
		}

		public static int main (string[] args) {
			var app = new Application ();
			return app.run (args);
		}
	}
}
