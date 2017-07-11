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

using Gee;

namespace OrgManager {
    /**
	 * Simple Stack class to help us build the org-document tree.
	 */
	public class Stack {
		private ArrayList<OrgNode> stack;
		public Stack() {
			stack = new ArrayList<OrgNode> ();
		}

		public OrgNode? pop() {
			if (stack.size == 0) return null;

			return stack.remove_at(stack.size - 1);
		}

		public void push(OrgNode node) {
			stack.insert(stack.size, node);
		}

		public OrgNode? top() {
			if (stack.size == 0) return null;

			return stack.get(stack.size - 1);
		}

		public bool empty() {
			return stack.size == 0;
		}

		public int size() {
			return stack.size;
		}
	}
}
