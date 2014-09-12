import QtQuick 2.0

Item {
	id: area;
	property int columns: 3;
	property int rows: 2;
	property var model: null;
	property var containers: [];
	property var items: [];
	property var itemMap: {
		return {};
	}
	property bool editing: false;
	property bool iconOnly: false;

	signal subAreaOpened(Item item);
	signal subAreaClosed(Item item);
	signal dropAreaEntered(Item source);
	signal dropAreaExited(Item source);

	Timer {
		id: arrangeItems;
		interval: 400;
		repeat: false;
		running: false;

		property var source;
		property int targetIndex;

		onTriggered: {
			moveItem(source, targetIndex);
		}
	}

	Timer {
		id: openArea;
		interval: 1000;
		repeat: false;
		running: false;

		property var targetItem: null;
		property var source: null;

		onTriggered: {

			// Create directory and put currect icon in it
			var newItem = null;
			if (targetItem.isIcon) {
				newItem = area.createDirectoryItem(targetItem);

				// Reparent source to this directory
				//source.area.editing = false;
				//source.area.removeItem(source);
				//newItem.directory.area.addItem(source);
			}

			area.subAreaOpened(newItem || targetItem);
		}
	}

	GridView {
		id: gridView;
		anchors.fill: parent;
		cellWidth: width / columns;
		cellHeight: height / rows;

		property var hoveredItem: null;

		model: columns * rows;
		delegate: Item {
			id: container;
			width: gridView.cellWidth;
			height: gridView.cellHeight;

			Component.onCompleted: {
				containers.push(container);
			}

			DropArea {
				anchors.fill: parent;
				keys: [ 'iconItem' ];

				property var curItem: null;

				onEntered: {
					curItem = area.getItem(index);

					// This is a external icon item
					var i = items.indexOf(drag.source);
					if (i == -1) {
						drag.source.area.dropAreaExited(drag.source);
						area.dropAreaEntered(drag.source);
					}
				}

				onDropped: {
					if (curItem)
						curItem.hovered = false;

					// Stop timer to avoid triggering sub area
					openArea.running = false;

					if (drag.source.position >= items.length) {
						drag.source.position = items.length - 1;
						itemMap[drag.source.position] = drag.source;
					}
				}

				onExited: {
					if (curItem)
						curItem.hovered = false;

					openArea.running = false;
				}

				onPositionChanged: {

					// Ignore if no need to move
					if (drag.source.position == index)
						return;

					// In gap?
					var obj = getItem(index);
					if (obj) {
						if (container.x < obj.x)
							return;

						if (obj.isGap(drag.x - (obj.x - container.x), drag.y)) {

							// Running already
							if (arrangeItems.running)
								return;

							// It doesn't focus on item
							if (gridView.hoveredItem) {
								gridView.hoveredItem.hovered = false;
								gridView.hoveredItem = null;
								openArea.running = false;
							}

							// Figure out the correct position we want to insert icon
							if (drag.source.position < index) {
								if (drag.x < obj.width * 0.5)
									arrangeItems.targetIndex = index - 1;
								else
									arrangeItems.targetIndex = index;
							} else {
								if (drag.x < obj.width * 0.5)
									arrangeItems.targetIndex = index;
								else
									arrangeItems.targetIndex = index + 1;
							}

							arrangeItems.source = drag.source;

							// Delay for action
							arrangeItems.start();

							return;
						}

						// Set focus and suspect it will be a directory
						openArea.targetItem = obj;
						openArea.source = drag.source;
						openArea.start();

						if (curItem) {
							// Cancel status before
							if (gridView.hoveredItem)
								gridView.hoveredItem.hovered = false;

							// Hover
							gridView.hoveredItem = curItem;
							gridView.hoveredItem.hovered = true;
						}
					}

					// Layout
					arrangeItems.running = false;
				}
			}

		}
	}

	function moveItem(source, index) {

		// Low to high
		if (source.position < index) {
			var low = source.position + 1;
			var high = index;

			for (var i in items) {
				var item = items[i];

				if (item.position >= low && item.position <= high) {
					item.position--;
					itemMap[item.position] = item;
				}
			}

		// High to low
		} else {
			var low = index;
			var high = source.position - 1;

			for (var i in items) {
				var item = items[i];

				if (item.position >= low && item.position <= high) {
					item.position++;
					itemMap[item.position] = item;
				}
			}
		}

		source.position = index;
		itemMap[index] = source;
	}

	function getContainer(position) {
		return containers[position];
	}

	function getItem(position) {
		return itemMap[position];
	}

	function initItem(item) {
		if (!item.initialized)
			item.parent = area;

		item.area = area;
		item.container = Qt.binding(function() { return item.area.getContainer(item.position); });
		item.width = Qt.binding(function() { return item.container.width; });
		item.height = Qt.binding(function() { return item.container.height; });
		item.iconOnly = Qt.binding(function() { return item.area.iconOnly; });
		item.initialized = true;
	}

	function addItem(item) {
		item.position = items.length;
		initItem(item);
		items.push(item);
		itemMap[item.position] = item;
	}

	function removeItem(item) {

		// Remove item from array
		var old = items.indexOf(item);
		if (old != -1) {
			items.splice(old, 1);

			// Remove from map
			delete itemMap[item.position];

			// Arange items left
			for (var i in items) {
				var _item = items[i];

				if (_item.position > item.position) {
					_item.position--;
					itemMap[_item.position] = _item;
				}
			}
		}
	}

	function replaceItem(oldItem, newItem) {

		console.log('RI: ' + oldItem.position);
		newItem.position = oldItem.position;
		initItem(newItem);

		// Replace specific item
		var old = items.indexOf(oldItem);
		if (old != -1) {
			items.splice(old, 1, newItem);
		}

		itemMap[newItem.position] = newItem;
	}

	function createDirectoryItem(item) {
		var newItem = Qt.createQmlObject('import QtQuick 2; IconItem { isIcon: false; property var app: Item {} area: desktopTop; }', area, 'IconItem');

		item.hovered = false;

		// Replace item with directory item
		replaceItem(item, newItem);

		// Add current item to directory automatically
		newItem.directory.parent = parent;
		newItem.directory.area.addItem(item);

		return newItem;
	}

	onSubAreaClosed: {

		if (item.directory.area.items.length == 0) {
			// Release directory item
			item.destroy();

		} else if (item.directory.area.items.length == 1) {
			var iconItem = item.directory.area.items[0];

			// Move the only icon out from the directory
			area.replaceItem(item, iconItem);

			iconItem.parent = area;

			// Release directory item
			item.destroy();
		}
	}

	onDropAreaEntered: {
		// Change parent to this new
		area.addItem(source);
		source.parent = area;
		area.editing = true;
	}

	onDropAreaExited: {
		area.editing = false;
		area.removeItem(source);
	}
}
