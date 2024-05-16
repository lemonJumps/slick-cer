class_name Slicker

var tool : MeshDataTool
var object : Node3D

var inter = []

var layerData = []

func _init(mesh : Mesh, refObject : Node3D):
    tool = MeshDataTool.new()
    tool.create_from_surface(mesh, 0)
    object = refObject

func checkPlaneAgainstModel(normal : Vector3, offset : Vector3):
    var d = normal.dot(offset)

    var quat = object.quaternion
    var scale = object.scale

    # turn normal and offset to (n*r=d) form of plane
    for i in range(tool.get_face_count()):
        var intersections = []
        for j in range(3):
            var face = tool.get_face_edge(i, j)
            var p1 = quat * (tool.get_vertex(tool.get_edge_vertex(face, 0)) * scale)
            var p2 = quat * (tool.get_vertex(tool.get_edge_vertex(face, 1)) * scale)
            
            var a = normal.dot(p1) > d
            var b = normal.dot(p2) > d

            if a != b:
                intersections.append([p1,p2])

        if len(intersections) == 2:
            inter.append(intersections)
            #print("intersections ", intersections)

            var line = []
            for intersection in intersections:
                var v = (intersection[1] - intersection[0]).normalized()
                var t1 = d - normal.dot(intersection[1]) # d - N * P0
                var t2 = normal.dot(v) # N * V (v is the direction vector)
                var t = t1/t2
                
                #print("t ", t, " - ", t1, " - ", t2)
                line.append(t*v + intersection[1])

            layerData.append(line)
