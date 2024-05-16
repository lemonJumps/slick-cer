@tool
extends EditorImportPlugin

func _get_importer_name():
    return "lemon.stl.importer"

func _get_visible_name():
    return "STL MESH"

func _get_recognized_extensions():
    return ["stl"]

func _get_save_extension():
    return "mesh" # this must be mesh bc otherwise it wont work

func _get_resource_type():
    return "Mesh"

func _get_preset_count():
    return 1

func _get_preset_name(preset_index):
    return "Default"

func _get_import_options(path, preset_index):
    return [{"name": "my_option", "default_value": false}]

# so this was a fucking lie
# the following two functions are REQUIRED and do not provide the correct values if undefined!!!!
func _get_priority():
    return 2.0

func _get_import_order():
    return 1

func _import(source_file, save_path, options, platform_variants, gen_files):

    var mesh = STLImport.load(source_file)

    var filename = save_path + "." + _get_save_extension()
    return ResourceSaver.save(mesh, filename)
