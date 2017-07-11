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

			Gtk.CellRendererText name = new Gtk.CellRendererText ();
			Gtk.CellRendererText deadline = new Gtk.CellRendererText ();
			insert_column_with_attributes (-1, "TODO_col", name, "markup", 0);
			insert_column_with_attributes (-1, "DEADLINE_col", deadline, "markup", 1);

			set_headers_visible (false);
			set_model(store);
		}

		private string getStyledNodeText(OrgNode node) {
			var builder = new StringBuilder ();
			switch (node.priority) {
			    case 0: builder.append ("[<b>Urgent</b>]"); break;
			    case 1: builder.append ("[<i>high</i>]"); break;
			}
			switch (node.state) {
			    case OrgManager.NodeState.DONE:
					builder.append ("[DONE]"); break;
			    case OrgManager.NodeState.TODO:
					builder.append ("[<b>TODO</b>]"); break;				
			}

			builder.append(node.name);

			return builder.str;
		}

		private string getStyledDeadlineText(OrgNode node) {
			var builder = new StringBuilder ();
			if (node.deadline != null) {
				builder.append ("[<span foreground=\"red\">%s</span>]".
								printf (node.deadline));
			}
			return builder.str;
		}

		private GLib.File getTodoFile() {
			var home_dir = File.new_for_path (Environment.get_home_dir());
			return home_dir.get_child(".simple").get_child("todo.org");
		}

		/**
		 * Returns a `Gtk.ListStore` from an Org Document.
		 */
		private Gtk.ListStore getStoreFromFile(GLib.File file) {
			org_document = OrgManager.OrgDocument.fromFile(file);

			Gtk.ListStore store = new Gtk.ListStore(2, typeof(string),
													typeof(string));
			foreach (var entry in org_document.getNodes().entries) {
				store.append (out store_iter);
				string entry_text = getStyledNodeText(entry.value);
				string entry_deadline = getStyledDeadlineText(entry.value);

				store.set (store_iter, 0, entry_text, 1, entry_deadline);
			}

			return store;
		}

		/**
		 * `addChildrent` will add `OrgNode`s to the `Gtk.ListStore` store.
		 * I will not use this yet, as the main TreeView will contain just
		 * one list of TODO items.
		 */
		private void addChildren(Gtk.ListStore store, OrgManager.OrgNode node) {
			foreach (OrgManager.OrgNode child in node.getChildren()) {
				if (child.getChildren().size > 0) {
					addChildren(store, child);
				}
				var name = "<level: %i; name: %s>".printf(
					child.level, child.name);
				store.append (out store_iter);
				store.set (store_iter, 0, name);
			}
		}
	}
}
