@tool

extends ResourceFormatLoader

class_name STLFormatLoader

func _get_recognized_extensions() -> PackedStringArray:
    return PackedStringArray(["stl"])

func _get_resource_type(path: String) -> String:
    var ext = path.get_extension().to_lower()
    if ext == "stl":
        return "Mesh"

    return ""

func _handles_type(typename: StringName) -> bool:
    return ClassDB.is_parent_class(typename, "Mesh")

func _load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int):
    if ResourceLoader.exists(path):
        return STLImport.load(path)
