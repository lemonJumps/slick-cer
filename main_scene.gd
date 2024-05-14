
extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func loadObject(file : String):
    var model
    if file.get_extension() == "stl":
        model = STLImport.load(file) 

    var mesh = MeshInstance3D.new()
    mesh.mesh = model
    mesh.rotate_x(deg_to_rad(-90))
    %Objects.add_child(mesh)

func _on_main_menu_index_pressed(index):
    var name = %MainMenu.get_item_text(index)
    
    if name == "LoadModel":
        %LoadFileDialog.show()


func _on_load_file_dialog_file_selected(path):
    loadObject(path)
