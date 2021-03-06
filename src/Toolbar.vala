/*
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
	public class Toolbar : Gtk.HeaderBar {
		public Gtk.Button add_button;
		public Gtk.Window parent_window;
		public TodoAddPopover add_popover;

		public Toolbar (Gtk.ActionGroup main_actions, Gtk.Window parent) {
			// the add_class() line will not allow add_button Button
			// to be displayed :(
			// get_style_context ().add_class ("primary-toolbar");

			parent_window = parent;
			title = "Toolbar";
			show_close_button = true;

			add_button = new Gtk.Button
				                .from_icon_name ("add",
												 Gtk.IconSize.LARGE_TOOLBAR);
			TodoAddPopover.build (add_button);

			pack_start (add_button);
			show_all();
		}
	}
}
