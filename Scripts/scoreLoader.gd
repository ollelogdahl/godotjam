extends Control

func _ready():
	getScores()
	

func getScores():
	$HTTPRequest.request("http://gamejolt.com/api/game/v1/scores/?username=30&format=json&game_id=447157&signature=299c81ecc60a9a30cfd9eac6bb65a45f")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	listScores(json.result.response.scores)

func listScores(s):
	$Names.text = ""
	$Scores.text = ""
	for e in s:
		$Names.text += e.guest + '\n'
		$Scores.text += e.score + '\n'