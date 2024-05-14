@tool
extends EditorPlugin


var import_plugin
var resLoader

func _enter_tree():
    import_plugin = preload("res://addons/STLimp/stlLoader.gd").new()
    resLoader = preload("stlResourceLoader.gd").new()
    add_import_plugin(import_plugin)


func _exit_tree():
    remove_import_plugin(import_plugin)
    import_plugin = null
