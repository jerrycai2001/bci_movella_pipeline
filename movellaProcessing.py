import os

# Insert path to existing folder
session_folder_path = ' '

# Creates obj folder within folder
obj_folder_name = 

obj_folder_path = os.path.join(session_folder_path, obj_folder_name)

# Copies obj files into obj_folder_name

# Scan filename for .obj
# If - contains .obj --> copy file to obj_folder_name
# Else - make other folder

for root, _, files in os.walk(session_folder_path):
    for filename in files:
        if filename.endswith('.mvno'):
            session_folder_path = os.path.join(root, filename)
            obj_folder_path = os.path.join(obj_folder_path, filename)

            shutil.move(session_folder_path, obj_folder_path)
            print(f"Moved '{filename}' to '{destination_directory}'")
print("File movement complete.")


