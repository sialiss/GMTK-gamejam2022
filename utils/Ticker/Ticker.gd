class_name Ticker

static func once(target: Node, time: float):
	var timer = TickerTimer.new()
	target.add_child(timer)
	timer.start(time)
	return timer

class TickerTimer:
	extends Timer

	func _init():
		one_shot = true
		connect("timeout", self, "queue_free")

	func then(target: Object, method_name: String, binds: Array = [], flags: int = 0):
		return connect("timeout", target, method_name, binds, flags)