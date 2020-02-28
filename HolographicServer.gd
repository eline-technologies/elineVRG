extends Node

# The port we will listen to
const PORT = 9080
# Our WebSocketServer instance
var _server = WebSocketServer.new()

func _ready():
	# Connect base signals to get notified of new client connections,
	# disconnections, and disconnect requests.
	_server.connect("client_connected", self, "_connected")
	_server.connect("client_disconnected", self, "_disconnected")
	_server.connect("client_close_request", self, "_close_request")
	# This signal is emitted when not using the Multiplayer API every time a
	# full packet is received.
	# Alternatively, you could check get_peer(PEER_ID).get_available_packets()
	# in a loop for each connected peer.
	_server.connect("data_received", self, "_on_data")
	# Start listening on the given port.
	var err = _server.listen(PORT)
	if err != OK:
		print("Unable to start server")
		set_process(false)
	print("Holographic Server started on port 9080")

func _connected(id, proto):
	# This is called when a new peer connects, "id" will be the assigned peer id,
	# "proto" will be the selected WebSocket sub-protocol (which is optional)
	print("Client %d connected with protocol: %s" % [id, proto])

func _close_request(id, code, reason):
	# This is called when a client notifies that it wishes to close the connection,
	# providing a reason string and close code.
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])

func _disconnected(id, was_clean = false):
	# This is called when a client disconnects, "id" will be the one of the
	# disconnecting client, "was_clean" will tell you if the disconnection
	# was correctly notified by the remote peer before closing the socket.
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])

func _on_data(id):
	# Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
	# and not get_packet directly when not using the MultiplayerAPI.
	var pkt = _server.get_peer(id).get_packet()
	print("Received from client %d: %s" % [id, pkt.get_string_from_utf8()])
	var jsonFrame = JSON.parse(pkt.get_string_from_utf8()).result
	if jsonFrame != null:
		match jsonFrame.command:
			"helo_holo":
				_processHeloHolo(id, jsonFrame.command, jsonFrame.content)
			"create_holo_panel":
				_processCreateHoloPanel(id, jsonFrame.command, jsonFrame.content)
			_:
				print("Unknown command %s" % [jsonFrame.content])
	else:
		print("This is not a Holographic Protocol frame !")

func _processHeloHolo(peer_id, command, content):
	print("Client HELO received: version %s" % [content])
	var response: Dictionary
	response["command"] = "holo_helo"
	response["code"] = 0
	var serializedResponse: String = JSON.print(response)
	_server.get_peer(peer_id).put_packet(serializedResponse.to_utf8())
	print("Sent to client %d: %s" % [peer_id, serializedResponse])

func _processCreateHoloPanel(peer_id, command, content):
	print("Client CreateHoloPanel received")
	var response: Dictionary
	response["command"] = "create_holo_panel"
	response["code"] = 0
	var serializedResponse: String = JSON.print(response)
	_server.get_peer(peer_id).put_packet(serializedResponse.to_utf8())
	print("Sent to client %d: %s" % [peer_id, serializedResponse])
	# Process holo_panel ui
	var holo_panel = content
	print("title %s" % [content.title])

func _process(delta):
	# Call this in _process or _physics_process.
	# Data transfer, and signals emission will only happen when calling this function.
	_server.poll()
