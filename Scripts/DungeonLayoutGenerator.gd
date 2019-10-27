extends Node

# klasser
onready var dungeonRoom = preload("res://Scripts/Classes/dungeonRoomClass.gd")
onready var dungeonCorridor = preload("res://Scripts/Classes/dungeonCorridorClass.gd")

var rooms
var corridors
var rng = RandomNumberGenerator.new()

func buildDungeon(steps, roomMean, roomStdev, mapSeed, first = dungeonRoom.new(0, 0, 10, 10)) -> void:
	rooms = []
	corridors = []
	
	# sätter seed
	rng.randomize()
	rng.seed = mapSeed
	
	# skapar det första rummet
	rooms.append(first)
	var lastValid := 0
	var fails := 0

	for i in range(steps):
		# roomsOrigin är det rummet korridoren ska byggas från
		#    bygger från senast giltiga rum, men går bakåt ifall den misslyckas
		var roomOrigin = rooms[max(lastValid - fails, 0)]
		var newRoom
		
		# välj en slumpad sida på föregående rum
		var edgeDirection : int = rng.randi() % 4
		var corridor = attachCorridorToOrigin(roomOrigin, edgeDirection)

		# beräkna storlek på nytt rum
		var roomDimensions = generateRoomDimensions(roomMean, roomStdev)
		var roomWidth  = int(roomDimensions.x)
		var roomHeight = int(roomDimensions.y)
		
		# slumpa rummets förskjutning längst med korridoren
		var v = attachRoomToCorridor(corridor, roomWidth, roomHeight)

		# testar om det nya rummet är godkänt, repetera annars!
		newRoom = dungeonRoom.new(v.x, v.y, roomWidth, roomHeight)
		if not roomIsValid(newRoom):
			fails += 1
			continue
			
		# validera det nya rummet ( OCH KORRIDOREN!! ;) )
		corridors.append( corridor )
		rooms.append( newRoom )
		lastValid = i
		
func buildDungeonLinear(steps, roomMean, roomStdev, mapSeed, first = dungeonRoom.new(0, 0, 10, 10)) -> void:
	rooms = []
	corridors = []
	
	# sätter seed
	rng.seed = mapSeed
	
	# skapar det första rummet
	rooms.append(first)
	var lastValid := 0
	var fails := 0

	for i in range(steps):
		# roomsOrigin är det rummet korridoren ska byggas från
		#var roomOrigin = rooms[lastValid - fails] # rätt så najs dungeon, men fel! ;)
		var roomOrigin = rooms[i]
		
		# repetera försök att placera rum tills rum är placerat
		#    detta behövs när rum försöker placeras ogiltigt (på andra)
		var repeat := true
		var newRoom
		var corridor
		while repeat:
		
			# välj en slumpad sida på föregående rum
			var edgeDirection : int = rng.randi() % 4
			corridor = attachCorridorToOrigin(roomOrigin, edgeDirection)

			# beräkna storlek på nytt rum
			var roomDimensions = generateRoomDimensions(roomMean, roomStdev)
			var roomWidth  = int(roomDimensions.x)
			var roomHeight = int(roomDimensions.y)
		
			# slumpa rummets förskjutning längst med korridoren
			var v = attachRoomToCorridor(corridor, roomWidth, roomHeight)

			# testar om det nya rummet är godkänt, repetera annars!
			newRoom = dungeonRoom.new(v.x, v.y, roomWidth, roomHeight)
			if roomIsValid(newRoom):
				repeat = false
			
		# validera det nya rummet ( OCH KORRIDOREN!! ;) )
		rooms.append(newRoom)
		corridors.append(corridor)
		lastValid = i

func attachCorridorToOrigin(roomOrigin, edge):
	# väljer en punkt slumpad längst med den sidan, där det ska bildas en dörr, korridor och ett rum
	var x := 0
	var y := 0
	var corridorLength := 0

	match edge:
		0: # H
			x = roomOrigin.x + roomOrigin.w
			y = roomOrigin.y + 1 + rng.randi() % (roomOrigin.h - 1)
		1: # U
			x = roomOrigin.x + 1 + rng.randi() % (roomOrigin.w - 1)
			y = roomOrigin.y
		2: # V
			x = roomOrigin.x
			y = roomOrigin.y + 1 + rng.randi() % (roomOrigin.h - 1)
		3: # N
			x = roomOrigin.x + 1 + rng.randi() % (roomOrigin.w - 1)
			y = roomOrigin.y + roomOrigin.h
	corridorLength = 2 + rng.randi() % 3 # slumptal 2-4
		
	return dungeonCorridor.new(x, y, edge, corridorLength)

func attachRoomToCorridor(c, width, height):
	# slumpa rummets förskjutning relativt korridoren
	var roomX := 0
	var roomY := 0
	match c.dir:
		0: # H
			roomX = c.x + c.length-1
			var offsetY = 1 + rng.randi() % max(height - 2, 1)
			roomY = c.y - offsetY
		1: # U
			var offsetX = 1 + rng.randi() % max(width - 2, 1)
			roomX = c.x - offsetX
			roomY = c.y - ( height + c.length -1)
		2: # V
			roomX = c.x - ( width + c.length   -1)
			var offsetY = 1 + rng.randi() % max(height - 2, 1)
			roomY = c.y - offsetY
		3: # N
			var offsetX = 1 + rng.randi() % max(width - 2, 1)
			roomX = c.x - offsetX
			roomY = c.y + c.length-1
			
	return Vector2(roomX, roomY)

func generateRoomDimensions(roomMean, roomStdev):
	var width  = int(rng.randfn(roomMean, roomStdev))
	var height = int(rng.randfn(width, roomStdev))
	
	width  = max(width,  4)
	height = max(height, 4)
	
	return Vector2(width, height)

# kollar ifall det går att placera ett rum här UTAN att överskrida något
func roomIsValid(room):
	for r in rooms:
		if room == r:
			continue
		
		if(room.collidesWith(r)):
			return false
	return true