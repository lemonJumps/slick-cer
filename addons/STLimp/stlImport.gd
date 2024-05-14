class_name STLImport

static func load(path: String, scale = 0.01):
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
            
            verts.append(v3 * scale)
            verts.append(v2 * scale)
            verts.append(v1 * scale)
            var attribCount := file.get_16()


    var data = []
    data.resize(Mesh.ARRAY_MAX)
    data[Mesh.ARRAY_NORMAL] = normals
    data[Mesh.ARRAY_VERTEX] = verts

    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
    return mesh
