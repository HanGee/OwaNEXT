import QtQuick 2.3
import QtQml.Models 2.1

DelegateModel {
	id: delegateModel;

	model: AppList {
		id: applist;
		filter: categoryLauncher;
		paginable: false;
	}

	delegate: Package {
		id: pkg;
		property var appInfo: app;

		Item {
			id: desktop;
			Package.name: 'desktop';
			width: wrapper.width;
			height: wrapper.height;
		}

		Item {
			id: dock;
			Package.name: 'dock';
			width: wrapper.width;
			height: wrapper.height;
		}
/*
		property var groupPlaces: null;
		Repeater {
			id: groupPkgs;
			model: delegateModel.places.length;

			Item {
				//Package.name: delgateModel.places[index];
				width: wrapper.width;
				height: wrapper.height;
				Component.onCompleted: {
console.log(delgateModel.places[index]);
					if (!groupPlaces)
						groupPlaces = {};
					groupPlaces[delgateModel.places[index]] = this;
				}
			}

			Component.onCompleted: {
				console.log(delegateModel.places.length);
			}
		}
*/
		/*
		Item {
			id: desktop;
			Package.name: 'desktop';
			width: wrapper.width;
			height: wrapper.height;
		}
		*/
		Item {
			id: wrapper;
			//Package.name: placeName;
			//parent: groupPlaces[groupName];
			parent: desktop;
/*
			parent: {
				var _parent = groupPkgs.model.get(0)
				for 
				var _parent = groupItems[groupName];
				if (!_parent)
					return undefined;
console.log(123);
				_parent.width = Qt.binding(function() { return wrapper.width; });
				_parent.height = Qt.binding(function() { return wrapper.height; });

				return _parent;
			}
			*/
			property string placeName: 'desktop';
			property var newParent: null;

			Loader {
				id: loader;
				property var placeName: wrapper.placeName;
				property var app: appInfo;
				asynchronous: true;
				sourceComponent: delegateModel.template;
				active: (sourceComponent) ? true : false;

				onLoaded: {
					//item.placeName = wrapper.placeName;
					wrapper.width = Qt.binding(function() { return item.width; });
					wrapper.height = Qt.binding(function() { return item.height; });
				}

				Connections {
					target: loader.item;
					onClicked: delegateModel.clicked(mgr);
					onPlaceChanged: {
						if (placeName == 'desktop') {
							wrapper.parent = desktop;
						} else {
							wrapper.parent = dock;
						}
					}
					onPressAndHold: {
						pkg.VisualDataModel.inPicked = true;
					}
					onReleased: {
						pkg.VisualDataModel.inPicked = false;
					}
					onSlippingRequested: {

						// Nothing need to be moved
						if (pickedItems.count == 0)
							return;

						// Icon from somewhere is going to this place
						var from = pickedItems.get(0).itemsIndex;
						var target = index;

						// No change
						if (from == target)
							return;

						delegateModel.model.move(from, target, 1);
					}
				}
			}

			states: [
				State {
					when: (newParent != null);

					ParentChange {
						target: wrapper;
						parent: newParent;
					}

					StateChangeScript {
						script: {
							var _parent = newParent;
							newParent = null;
							wrapper.parent = _parent;
							console.log('changed');
						}
					}
				}
			]
		}
	}

	groups: [
		VisualDataGroup {
			id: pickedItems;
			name: 'picked'
		}
	]
	property var places: [];
//	property var groupItems: null;
	property Component template: null;

	signal clicked(var mgr);
	signal pressAndHold(var mgr);
	signal released(var mgr);
	signal groupingRequested;
	signal slippingRequested(var source);
/*
	onGroupsChanged: {
		if (!groupItems)
			groupItems = {};

		// Update package
		for (var index in places) {
			var groupName = places[index];
			var groupItem = groupItems[groupName] || null;

			// Group exists already
			if (groupItem)
				continue;

			// Create a new group
			//var group = Qt.createQmlObject('import QtQuick 2.3; Item { id: \'' + groupName + '\'; Package.name: \'' + groupName + '\'; }', delegateModel.delegate, groupName);
			//groupItems[groupName] = group;
			//groupItems[groupName] = true;
		}
	}
	*/
	function moveIcon() {
	}
}
