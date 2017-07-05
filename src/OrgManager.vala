/**
 *  OrgManger is a org-mode manager to read and write org files.
 *
 * Author: Rodrigo Valin <licorna@gmail.com>
 */

using Gee;

namespace OrgManager {
	public enum NodeState {
		TODO,
		DONE,
		NOT_STARTED
	}
	
	public class OrgNode : GLib.Object {
		private string _name;
		private int _priority; // 0, 1, 2 (urgent, high, normal)
		private int _level; // amount of asterisks
		private NodeState _state;
		private string _deadline;
		private string _text_content;
		private ArrayList<string> tags;

		private ArrayList<OrgNode> children;

		public string text_content {
			get { return _text_content; }
			set { _text_content = value; }
		}

		public string deadline {
			get { return _deadline; }
			set { _deadline = value; }
		}
		
		public string name {
			get { return _name; }
			set { _name = value; }
		}

		public string state {
			get { return nameOfState(_state); }
		}

		public int priority {
			get { return _priority; }
			set { _priority = value; }
			default = 2;
		}

		public int level {
			get { return _level; }
			set { _level = value; }
			default = 1;
		}

		private unowned string nameOfState(NodeState state) {
			switch (state) {
			case NodeState.TODO: return "TODO";
			case NodeState.DONE: return "DONE";
			}
			return "NOT_STARTED";
		}
		
		public OrgNode(string name) {
			_name = name;
			tags = new ArrayList<string> ();
			children = new ArrayList<OrgNode> ();
			level = OrgNode.nodeLevel(name);

			if ("* TODO" in name) {
				_state = NodeState.TODO;
			} else if ("* DONE" in name) {
				_state = NodeState.DONE;
			} else {
				_state = NodeState.NOT_STARTED;
			};
		}

		public void addChild(OrgNode child) {
			children.add(child);
		}

		public ArrayList<OrgNode> getChildren() {
			return children;
		}

		public string to_string() {
			return "<name: %s; state: %s; deadline: %s; childs: %i>".printf(
				name, state, deadline, children.size);
		}

		/**
		 * Initializes a Node from a list of lines. The first one should
		 * be the title (some amount of asterisks then a title).
		 * The rest of the lines can be the DEADLINE and then some text.
		 */
		public static OrgNode from_strings(ArrayList<string> lines) {
			var node = new OrgNode(lines[0]);
			ArrayList<string> content = new ArrayList<string> ();
			for (int c = 1; c < lines.size; c++) {
				if (c == 1 && lines[c].has_prefix("DEADLINE: ")) {
					node.deadline = lines[1].slice(11, lines[1].length);
				} else {
					content.add (lines[c]);
				}
			}
			node.text_content = OrgNode.join(content);

			return node;
		}

		public static string join(ArrayList<string> lines) {
			if (lines.size == 0) return "";
			
			var builder = new StringBuilder();
			var size = lines.size;
			for (int i = 0; i < size; i++) {
				builder.append(lines[i]);
				if (i != size - 1) {
					builder.append_unichar('\n');
				}
			}
			return builder.str;
		}

		public static int nodeLevel(string line) {
			/**
		     * I don't know how to add a proper "count" from line start.
             */
			int asteriskCount = 0;
			for (var c = 0; c < line.length; c++) {
				if (line[c] != '*') break;
				asteriskCount += 1;
			}
			return asteriskCount;
		}

	}

	public class OrgDocument : Object {
		// HashMap keeps track of nodes in the file.
		// the key represents the line number
		private HashMap<int, OrgNode> nodes;
		public string fileName;

		/**
		 * Constructor
		 */
		public OrgDocument() {
			this.nodes = new HashMap<int, OrgNode> ();
		}

		public void addNode(int lineNumber, OrgNode node) {
			nodes.set(lineNumber, node);
		}

		public HashMap<int, OrgNode> getNodes() {
			return nodes;
		}

		/**
		 * Factory method, create OrgDocument from File.
		 */
		public static OrgDocument fromFile(string fileName) {
			var doc = new OrgDocument();

			doc.fileName = fileName;
			var file = File.new_for_path(fileName);

			try {
				var dis = new DataInputStream(file.read());
				string line;
				int lineNo = 0;
				ArrayList<string> nodeLines = new ArrayList<string> ();

				// FIXME: this will not work with multiple levels
				// it has to be changed for a stack.
				OrgNode lastNode = null;
		
				while ((line = dis.read_line(null)) != null) {
					var nodeLevel = OrgNode.nodeLevel(line);
					if (nodeLevel > 0) {
						// found new task
						if (nodeLines.size > 0) {
							// we have captured a TASK so far
							var node = OrgNode.from_strings(nodeLines);
							nodeLines.clear();

							if (lastNode != null && node.level > lastNode.level) {
								lastNode.addChild(node);
								lastNode = node;
							} else {
								doc.addNode(lineNo, node);
								lastNode = node;
							}
						}
					}
					nodeLines.add(line);
					lineNo += 1;
				}

				if (nodeLines.size > 0) {
					// FIXME: This code is repeated inside the loop
					var node = OrgNode.from_strings(nodeLines);
					nodeLines.clear();

					if (lastNode != null && node.level > lastNode.level) {
						lastNode.addChild(node);
					} else {
						doc.addNode(lineNo, node);
						lastNode = node;
					}
				}
			} catch (Error e) {
				error ("%s\n", e.message);
			}

			return doc;
		}
	}
}

int main(string[] args) {
	var doc = OrgManager.OrgDocument.fromFile("todosample.org");
	foreach (var entry in doc.getNodes().entries) {
		stdout.printf("%s\n", entry.value.to_string());
		stdout.printf("Getting children now\n");
		foreach (OrgManager.OrgNode child in entry.value.getChildren()) {
			stdout.printf("\t%s\n", child.to_string());
		}
	}
	
	return 0;
}
