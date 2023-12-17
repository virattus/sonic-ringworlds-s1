extends Node


var FPS := 0.0
var TimePerFrame := 0.0
var TimePerPhysicsFrame := 0.0
var TimeNavigation := 0.0
var StaticMemory := ""
var MaxStaticMemory := ""

var ObjectCount := 0.0
var ObjectNodeCount := 0.0
var OrphanNodes := 0.0
var ObjectsLastFrame := 0.0

var TextureMemory := ""
var VertexCount := 0.0
var DrawCalls := 0.0

var PhysicsActiveObjects3D := 0.0
var PhysicsCollisionPairs3D := 0.0
var PhysicsIslandCount3D := 0.0

var NavigationMapCount := 0.0
var NavigationRegionCount := 0.0
var NavigationAgentCount := 0.0

var AudioLatency := 0.0

var Uptime := 0.0


func _ready():
	AddSystemMonitors()


func _process(_delta):
	FPS = Performance.get_monitor(Performance.TIME_FPS)
	TimePerFrame = Performance.get_monitor(Performance.TIME_PROCESS)
	TimePerPhysicsFrame = Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)
	TimeNavigation = Performance.get_monitor(Performance.TIME_NAVIGATION_PROCESS)
	StaticMemory = BytesFormatted(Performance.get_monitor(Performance.MEMORY_STATIC))
	MaxStaticMemory = BytesFormatted(Performance.get_monitor(Performance.MEMORY_STATIC_MAX))
	ObjectCount = Performance.get_monitor(Performance.OBJECT_COUNT)
	ObjectNodeCount = Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	OrphanNodes = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
	ObjectsLastFrame = Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)
	VertexCount = Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	DrawCalls = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	TextureMemory = BytesFormatted(Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED))
	PhysicsActiveObjects3D = Performance.get_monitor(Performance.PHYSICS_3D_ACTIVE_OBJECTS)
	PhysicsCollisionPairs3D = Performance.get_monitor(Performance.PHYSICS_3D_COLLISION_PAIRS)
	PhysicsIslandCount3D = Performance.get_monitor(Performance.PHYSICS_3D_ISLAND_COUNT)
	NavigationMapCount = Performance.get_monitor(Performance.NAVIGATION_ACTIVE_MAPS)
	NavigationRegionCount = Performance.get_monitor(Performance.NAVIGATION_REGION_COUNT)
	NavigationAgentCount = Performance.get_monitor(Performance.NAVIGATION_AGENT_COUNT)
	AudioLatency = Performance.get_monitor(Performance.AUDIO_OUTPUT_LATENCY)
	Uptime = Time.get_ticks_msec() / 1000.0
	

func BytesFormatted(text):
	var byteAmount = int(text)
	if byteAmount / (1024.0 * 1024.0) > 1:
		return "%s MB" % roundf(byteAmount / (1024.0 * 1024.0))
	elif byteAmount / 1024.0 > 1:
		return "%s KB" % roundf(byteAmount / 1024.0)
	else:
		return "%s B" % roundf(byteAmount)


func AddSystemMonitors():
	DebugMenu.AddMonitor(SystemMonitor, "FPS")
	DebugMenu.AddMonitor(SystemMonitor, "TimePerFrame")
	DebugMenu.AddMonitor(SystemMonitor, "TimePerPhysicsFrame")
	DebugMenu.AddMonitor(SystemMonitor, "TimeNavigation")
	DebugMenu.AddMonitor(SystemMonitor, "StaticMemory")
	DebugMenu.AddMonitor(SystemMonitor, "MaxStaticMemory")
	DebugMenu.AddMonitor(SystemMonitor, "ObjectCount")
	DebugMenu.AddMonitor(SystemMonitor, "ObjectNodeCount")
	DebugMenu.AddMonitor(SystemMonitor, "OrphanNodes")
	DebugMenu.AddMonitor(SystemMonitor, "ObjectsLastFrame")
	DebugMenu.AddMonitor(SystemMonitor, "TextureMemory")
	DebugMenu.AddMonitor(SystemMonitor, "VertexCount")
	DebugMenu.AddMonitor(SystemMonitor, "DrawCalls")
	DebugMenu.AddMonitor(SystemMonitor, "PhysicsActiveObjects3D")
	DebugMenu.AddMonitor(SystemMonitor, "PhysicsCollisionPairs3D")
	DebugMenu.AddMonitor(SystemMonitor, "PhysicsIslandCount3D")
	DebugMenu.AddMonitor(SystemMonitor, "NavigationMapCount")
	DebugMenu.AddMonitor(SystemMonitor, "NavigationRegionCount")
	DebugMenu.AddMonitor(SystemMonitor, "NavigationAgentCount")
	DebugMenu.AddMonitor(SystemMonitor, "AudioLatency")
	DebugMenu.AddMonitor(SystemMonitor, "Uptime")
