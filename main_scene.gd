
extends Control


@onready var loaderThread := Thread.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

    
var model
var loadCall : SubThreadCall

func loadObject(file : String):
    var mesh
    if file.get_extension() == "stl":
        loadCall = SubThreadCall.new(STLImport.load.bind(file), on_loaded)

func checkValid():
    print(is_instance_valid(loadCall))

func on_loaded(mesh):
    checkValid.call_deferred()
    model = MeshInstance3D.new()
    model.mesh = mesh
    model.rotate_x(deg_to_rad(-90))
    %Objects.add_child(model)

func slice():
    var lc = 50
    var s = Slicker.new(model.mesh, model)
    
    for layer in range(lc):
        s.layerData = []
        s.inter = []
        s.checkPlaneAgainstModel(Vector3.UP, layer * (Vector3.UP/lc))
        
        var verts1 = PackedVector3Array()
        var verts2 = PackedVector3Array()

        for i in s.layerData:
            for j in i:
                #for k in j:
                #print(j)
                verts1.append(j)
                
        var data = []
        data.resize(Mesh.ARRAY_MAX)
        data[Mesh.ARRAY_VERTEX] = verts1

        var m = ArrayMesh.new()
        m.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, data)
        var mat = StandardMaterial3D.new()
        mat.albedo_color = Color.WHITE
        m.surface_set_material(0, mat)

        var mm = MeshInstance3D.new() 
        mm.mesh = m
        %Objects.add_child(mm)
        
        #for i in s.inter:
            #for j in i:
                #for k in j:
                    ##print(k)
                    #verts2.append(k)
                #
        #data = []
        #data.resize(Mesh.ARRAY_MAX)
        #data[Mesh.ARRAY_VERTEX] = verts2
        #
        #m = ArrayMesh.new()
        #m.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, data)
        #mat = StandardMaterial3D.new()
        #mat.disable_ambient_light = true
        #mat.albedo_color = Color.RED
        #m.surface_set_material(0, mat)
        #
        #mm = MeshInstance3D.new() 
        #mm.mesh = m
        #%Objects.add_child(mm)
        
    
    %Objects.remove_child(model)
    

func _on_main_menu_index_pressed(index):
    var name = %MainMenu.get_item_text(index)
    
    if name == "LoadModel":
        %LoadFileDialog.show()
    if name == "Slice":
        slice()
        


func _on_load_file_dialog_file_selected(path):
    loadObject(path)
