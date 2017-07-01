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
	public class TodoList : Gtk.TreeView {
		private Gtk.ListStore store;
		private Gtk.TreeIter store_iter;

		public TodoList() {
			store = new Gtk.ListStore(2, typeof(string), typeof(int));

			store.append (out store_iter);
			store.set (store_iter, 0, "Batman", 1, 13);
			store.append (out store_iter);
			store.set (store_iter, 0, "Superman", 1, 17);

			set_model(store);

			Gtk.CellRendererText cell = new Gtk.CellRendererText ();
			insert_column_with_attributes (-1, "State", cell, "text", 0);
			insert_column_with_attributes (-1, "Cities", cell, "text", 1);
		}
	}
}
