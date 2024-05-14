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
        var file = FileAccess.open(path, FileAccess.READ)
        if file == null:
            # print("failed")
            return FAILED
        var mesh = ArrayMesh.new()


        var verts = PackedVector3Array()
        var normals = PackedVector3Array()

        var position = 0

        if file.get_buffer(5).get_string_from_utf8() == "solid":
            # this is an ascii format stl
            pass

        else:
            # this is a binary format stl
            file.seek(0)
            var header = file.get_buffer(80).get_string_from_utf8()
            var numberOfTriangles = file.get_32()

            for i in range(numberOfTriangles):
                var normal = Vector3(file.get_float(),file.get_float(),file.get_float())
                normals.append(normal)
                normals.append(normal)
                normals.append(normal)
                
                var v1 = Vector3(file.get_float(),file.get_float(),file.get_float())
                var v2 = Vector3(file.get_float(),file.get_float(),file.get_float())
                var v3 = Vector3(file.get_float(),file.get_float(),file.get_float())
                
                verts.append(v3)
                verts.append(v2)
                verts.append(v1)
                var attribCount := file.get_16()


        var data = []
        data.resize(Mesh.ARRAY_MAX)
        data[Mesh.ARRAY_NORMAL] = normals
        data[Mesh.ARRAY_VERTEX] = verts

        mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
