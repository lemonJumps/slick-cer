extends Object

class_name SubThreadCall

var thread : Thread

func _init(function : Callable, callback : Callable):
    thread = Thread.new()
    thread.start(self.inThread.bind(function, callback, self))

static func inThread(function : Callable, callback : Callable, obj : SubThreadCall):
    callback.call_deferred(function.call())

    SubThreadCall.kill.call_deferred(obj)
    
static func kill(obj : SubThreadCall):
    obj.thread.wait_to_finish()
    obj.free()
