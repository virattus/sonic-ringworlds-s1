extends Tree


signal AddToMonitorOverlay(monProperty)
signal EntryDeleted(object, property)


var treeRoot = null
var treeEntries = {}

const Property = preload("res://overlays/DebugMenu/MonitorProperty.gd")


func _ready() -> void:
	treeRoot = create_item()
	set_hide_root(true)


func _process(_delta: float) -> void:
	var deleted = []
	for t in treeEntries:
		if treeEntries[t].UpdateValue():
			var text = str(treeEntries[t].property) + ": " + str(treeEntries[t].value)
			t.set_text(0, text)
		else:
			deleted.append(t)
	
	for i in deleted:
		var array = treeEntries[i].fullPath.split("/", false, 1)
		EntryDeleted.emit(treeEntries[i].fullPath, treeEntries[i].property)
		RemoveMonitorProperty(treeEntries[i], array[1], treeRoot)


func AddMonitor(object, property, display = "") -> void:
	var monitorProperty = Property.new(object, property, display)
	var array = monitorProperty.fullPath.split("/", false, 1)
	AddMonitorProperty(monitorProperty, array[1], treeRoot)


func AddMonitorProperty(_property: MonitorProperty, _name: String, _parent: TreeItem) -> void:
	if !_name.is_empty():
		var array = _name.split("/", false, 1)
		if array.size() <= 0:
			return

		array.push_back("")
		var siblings = _parent.get_children()
		for i in siblings:
			#print(i.get_text(0))
			if i.get_text(0) == array[0]:
				AddMonitorProperty(_property, array[1], i)
				return
		
		#Entry isn't in the tree
		var newEntry = create_item(_parent)
		newEntry.set_text(0, array[0])
		newEntry.set_collapsed_recursive(true)
		AddMonitorProperty(_property, array[1], newEntry)
		#print("NonLeaf " + str(newEntry) + " " + _parent.get_text(0) + " " + array[0])
	else:
		var newEntry = create_item(_parent)
		newEntry.set_text(0, _property.object.name)
		treeEntries[newEntry] = _property
		#print("Leaf " + str(newEntry) + " " + _property.fullPath + " " + _property.property)


func RemoveMonitor(object, property) -> void:
	var nodePath = object.get_path()
	assert(nodePath.is_absolute())
	
	var pathString = String(nodePath)
	var array = pathString.split("/", false, 1)
	RemoveMonitorProperty(property, array[1], treeRoot)


#TODO it's leaving the root parent objects
func RemoveMonitorProperty(_property: MonitorProperty, _name: String, _parent: TreeItem) -> bool:
	if _name.is_empty():
		var siblings = _parent.get_children()
		for i in siblings:
			if treeEntries.has(i):
				if treeEntries[i].fullPath == _property.fullPath and treeEntries[i].property == _property.property:
					RemoveTreeEntry(i)
					if _parent.get_child_count() == 0:
						return true
	else:
		#move down the tree, but also call RemoveMonitorProperty recursively, check if there's any
		#children left, and remove this level from the tree if it's empty
		var pat_h = _property.fullPath
		var array = _name.split("/", false, 1)
		if array.size() > 0:
			array.push_back("")
			var siblings = _parent.get_children()
			for i in siblings:
				if(RemoveMonitorProperty(_property, array[1], i) == true):
					#i.free()
					return true
	return false


#return true/false whether the parent was deleted
func RemoveTreeEntry(t: TreeItem) -> void:
	if treeEntries.erase(t):
		#print("deleting " + t.get_text(0))
		t.free()


func _on_item_activated() -> void:
	var selectedItem = get_selected()
	
	for i in treeEntries.keys():
		if i == selectedItem:
			AddToMonitorOverlay.emit(treeEntries[i])
			return
