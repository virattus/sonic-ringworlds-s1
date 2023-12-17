extends MarginContainer


var BoundProperties = {}


const Property = preload("res://overlays/DebugMenu/MonitorProperty.gd")


func _process(_delta: float) -> void:
	var deleted = []
	for p in BoundProperties:
		if p.UpdateValue():
			BoundProperties[p].text = str(p.object.get_path()) + "/" + str(p.property) + "::" + str(p.value)
		else:
			deleted.append(p)
	
	for i in deleted:
		RemoveProperty(i)


func ToggleProperty(monProperty) -> void:
	if RemoveProperty(monProperty):
		return
	else:
		AddProperty(monProperty)


func AddProperty(monProperty) -> void:
	var label = Label.new()
	$VBoxContainer.add_child(label)
	BoundProperties[monProperty] = label


func RemoveProperty(monProperty) -> bool:
	for p in BoundProperties:
		if p.fullPath == monProperty.fullPath and p.property == monProperty.property:
			BoundProperties[p].queue_free()
			BoundProperties.erase(p)
			return true
	
	return false


func RemoveMonitor(object, property) -> void:
	var monProperty = Property.new(object, property, "")
	RemoveProperty(monProperty)


func ClearAllProperties():
	BoundProperties.clear()
	for i in $VBoxContainer.get_children():
		i.queue_free()
