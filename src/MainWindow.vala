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
	public class MainWindow : Gtk.Window {
		private const string COLOR_PRIMARY = """
        @define-color colorPrimary %s;
        .background,
        .titlebar {
            transition: all 600ms ease-in-out;
        }
        """;
		public Gtk.ActionGroup main_actions;
		public Toolbar toolbar;
		public TodoList todolist;

		public MainWindow (Application simple_app) {
			Object (application: simple_app,
					deletable: true,
					icon_name: "com.github.licorna.simple",
					resizable: true,
					skip_taskbar_hint: true,
					skip_pager_hint: true,
					title: _("Simple"),
					height_request: 450,
					width_request: 500);
		}

		construct {
			set_size_request (450, 400);
			set_hide_titlebar_when_maximized (false);

			// This is White ICE :)
			// http://www.htmlcsscolor.com/hex/D5EDE2
			var toolbar_color = "#D5EDE2";
			var provider = new Gtk.CssProvider();
			try {
				var colored_css = COLOR_PRIMARY.printf (toolbar_color);
				provider.load_from_data (colored_css, colored_css.length);

				Gtk.StyleContext.add_provider_for_screen (
					Gdk.Screen.get_default(),
					provider,
					Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
			} catch (GLib.Error e) {
				critical (e.message);
			}
			
			init_actions ();
			init_layout ();
		}

		private void init_actions () {
			main_actions = new Gtk.ActionGroup ("MainActionGroup");
			main_actions.add_actions (main_entries, this);
		}

		private void init_layout () {
			set_titlebar (new Toolbar (main_actions, this));
			todolist = new TodoList();

			add(todolist);
			show_all ();
		}

		private void action_add_task () {
			// todolist.add("some super heroe", 10);
			stdout.printf("**action_add_task**\n\n");
		}

		private const Gtk.ActionEntry[] main_entries = {
			{"AddTodo", "add",
			 N_("Add Task"), "<Control>a",
			 N_("Add Task"), action_add_task}
		};
	}
}
