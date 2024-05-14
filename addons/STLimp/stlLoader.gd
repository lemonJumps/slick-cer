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

enum binaryState {
    Header,
    Number_OfTriangles,
    Normal,
    Vert1,
    Vert2,
    Vert3,
    Attrib0
}

func _import(source_file, save_path, options, platform_variants, gen_files):
    var file = FileAccess.open(source_file, FileAccess.READ)
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

    # print(data)

    # print(file.get_as_text())

    var filename = save_path + "." + _get_save_extension()
    return ResourceSaver.save(mesh, filename)
