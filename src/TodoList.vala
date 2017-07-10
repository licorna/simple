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

using OrgManager;

namespace SimpleTodo {
	private const string ORG_FILE = "/home/rvalin/.simple/todo.org";
	public class TodoList : Gtk.TreeView {
		private Gtk.ListStore store;
		private Gtk.TreeIter store_iter;

		private OrgManager.OrgDocument org_document;

		public TodoList() {
			var file  = getTodoFile();
			store = getStoreFromFile(file);
			set_model(store);

			Gtk.CellRendererText cell = new Gtk.CellRendererText ();
			insert_column_with_attributes (-1, "TODO", cell, "text", 0);
		}

		private GLib.File getTodoFile() {
			var home_dir = File.new_for_path (Environment.get_home_dir());
			return home_dir.get_child(".simple").get_child("todo.org");
		}

		private Gtk.ListStore getStoreFromFile(GLib.File file) {
			org_document = OrgManager.OrgDocument.fromFile(file);

			Gtk.ListStore store = new Gtk.ListStore(1, typeof(string));
			foreach (var entry in org_document.getNodes().entries) {
				store.append (out store_iter);
				store.set (store_iter, 0, entry.value.name);
				foreach (OrgManager.OrgNode child in entry.value.getChildren()) {
					var name = "<level: %i; name: %s>".printf(
						child.level, child.name);
					store.append (out store_iter);
					store.set (store_iter, 0, name);
				}
			}

			return store;
		}

	}
}
