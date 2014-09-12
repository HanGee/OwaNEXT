import QtQuick 2.0

Item {
	id: selection;

	property var source: null;

	states: [
		State {
			name: 'pick';

			ParentChange {
				target: source;
				parent: selection;
			}
		}
	]

	function pick(item) {
		selection.source = item;
		selection.state = 'pick';
	}

	function drop() {
		selection.source = null;
		selection.state = '';
	}
}
