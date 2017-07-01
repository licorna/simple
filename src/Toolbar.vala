namespace SimpleTodo {
	public class Toolbar : Gtk.HeaderBar {
		public Gtk.ToolButton add_button;

		public Toolbar (Gtk.ActionGroup main_actions) {
			// the add_class() line will not allow add_button Button
			// to be displayed :(
			// get_style_context ().add_class ("primary-toolbar");

			title = "Toolbar";
			show_close_button = true;

			add_button = main_actions.get_action ("AddTodo")
			                         .create_tool_item () as Gtk.ToolButton;
			pack_start (add_button);
			show_all();
		}
	}
}
