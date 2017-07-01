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
	public class TodoAddPopover {
		public static Gtk.Popover build(Gtk.Button relative_to) {
			Gtk.Popover self = new Gtk.Popover (relative_to);
			self.set_size_request (300, 250);

			// Content Grid
			var content_grid = new Gtk.Grid ();
			content_grid.set_border_width (12);
			content_grid.row_spacing = 18;
			content_grid.column_spacing = 24;

			// TODO: Set this to <strong>
			var title = new Gtk.Label (null);
			title.set_markup ("<b>New TODO Item</b>");
			title.set_use_markup (true);
			// DEPRECATED: set_alignment
			title.set_alignment (0, 0.5f);
			content_grid.attach (title, 0, 0, 2, 1);

			// What label & entry
			var what_label = new Gtk.Label (_("What"));
			var what_entry = new Gtk.Entry ();
			var ex_label01 = new Gtk.Label (_("Ex: Pay rent next monday"));
			var ex_label02 = new Gtk.Label (_("Ex: Buy milk"));
			ex_label01.set_alignment (0, 0.5f);  // DEPRECATED
			ex_label02.set_alignment (0, 0.5f);  // DEPRECATED

			var what_entry_grid = new Gtk.Grid ();
			what_entry_grid.orientation = Gtk.Orientation.VERTICAL;
			what_entry_grid.add (what_entry);
			what_entry_grid.add (ex_label01);
			what_entry_grid.add (ex_label02);
			what_entry_grid.show_all ();

			content_grid.attach (what_label, 0, 1, 1, 1);
			content_grid.attach_next_to(what_entry_grid, what_label, 
										Gtk.PositionType.RIGHT, 2, 1);

			// When label & entry
			var when_label = new Gtk.Label (_("When"));
			var when_entry = new Gtk.Entry ();
			var calendar_entry = new Gtk.Button.with_label (_("Select"));
			content_grid.attach (when_label, 0, 2, 1, 1);
			content_grid.attach_next_to (when_entry, when_label,
										 Gtk.PositionType.RIGHT, 1, 1);
			content_grid.attach_next_to (calendar_entry, when_entry,
										 Gtk.PositionType.RIGHT, 1, 1);

			var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
			var add_button = new Gtk.Button.with_label (_("Add"));
			content_grid.attach (separator, 0, 3, 4, 1);
			content_grid.attach (add_button, 2, 4, 1, 1);
				
			content_grid.show_all ();
			self.add (content_grid);

			relative_to.clicked.connect( () => {
					self.set_visible (true);
				});

			return self;
		}
	}
}
