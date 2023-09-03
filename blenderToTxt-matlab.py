#%%
import bpy
import os
import numpy as np
import pandas as pd

# --- README ---
# Activate Virtual Environment: source /Users/jycai/testenv/bin/activate
# --- END ------

index_num = 7

# Set the path to your Blender file
blender_file_path = "/Users/jycai/Research + Entrepreneurship/Xsens Movella Project/Xsens Excel + FBX Files/Trial_1/Trial_1-Movella-Brekel.blend"

# Load the Blender file
bpy.ops.wm.open_mainfile(filepath=blender_file_path)

# print all objects
print(" *** Object Names *** ")
for obj in bpy.data.objects:
    print(obj.name)

# print all scene names in a list
print(" *** Scene Keys *** ")
print(bpy.data.scenes.keys())

# Create numpy array for location data
df = pd.DataFrame(columns = ['x_coord', 'y_coord', 'z_coord'])

# Location array takes in object [x, y, z] with Type:
# float array of 3 items in [-inf, inf], default (0.0, 0.0, 0.0)
# There are a total of 250 frames for the entire blender .fbx animation

scene = bpy.context.scene
loc = bpy.context.object.location
cur_object = bpy.data.objects[index_num]

# write images into a new file next to the specified object
file = open(os.path.splitext(bpy.data.filepath)[0] + str(cur_object)[21:46] + "-output-MAT" + ".txt", 'w')

print(" *** Current Object: "+str(cur_object)+" *** ")
file.write('Current Object: '+str(cur_object)+'\n')
# [TEST] Single Loop to test dataframe
for frames in range(scene.frame_start, scene.frame_end+1):
    scene.frame_set(frames)
    loc = cur_object.location
    # Appends xyz positions to DataFrame
    data = {'x_coord': loc.x, 'y_coord': loc.y, 'z_coord': loc.z}
    # Writes txt file with locations
    file.write(str(frames)+', '+str(loc.x)+', '+str(loc.y)+', '+str(loc.z)+'\n')
    df.loc[len(df.index)] = data
    # df = df(data, ignore_index=True)
file.close()

# print(df['x_coord'])
print(np.asarray(df['x_coord']))
print(np.asarray(df['x_coord']).shape)

# %%
# >>>>>> NAME OF DF + Object <<<<<<
# df_1_brk = df
print("df saved as")
df_6_mov = df


# %%
# Step 2: Visualize Data
# Look at this link: https://pythonprogramming.net/3d-graphing-pandas-matplotlib/

# from mpl_toolkits import mplot3d

import numpy as np
import matplotlib.pyplot as plt

x_array = np.asarray(df['x_coord'])
y_array = np.asarray(df['y_coord'])
z_array = np.asarray(df['z_coord'])
fig1 = plt.figure()

plt.plot(x_array)
plt.xlabel("frame_number")
plt.ylabel("x_position")

plt.plot(y_array)
plt.xlabel("frame_number")
plt.ylabel("y_position")

plt.plot(z_array)
plt.xlabel("frame_number")
plt.ylabel("z_position")

# %%
# 3D plot projections
fig2 = plt.figure()
ax2 = plt.axes(projection='3d')

# Data for a three-dimensional line

xline = x_array
yline = y_array
zline = z_array

ax2.set_xlabel("x_position")
ax2.set_ylabel("y_position")
ax2.set_zlabel("z_position")
ax2.plot3D(xline, yline, zline)

# fig2.set_xlabel()

# %%
# Difference Vector 2D plots

# --- CHANGE ME ---
df_diff_1_6 = df_1_brk - df_6_mov
df = df_diff_1_6
# --- CHANGE ME ---

# Brekel - Inter-Axial Differences
brk_xy_array = np.asarray(df_1_brk['y_coord'] - df_1_brk['x_coord'])
brk_xz_array = np.asarray(df_1_brk['z_coord'] - df_1_brk['x_coord'])
brk_yz_array = np.asarray(df_1_brk['z_coord'] - df_1_brk['y_coord'])

# Movella - Inter-Axial Differences
mov_xy_array = np.asarray(df_6_mov['y_coord'] - df_6_mov['x_coord'])
mov_xz_array = np.asarray(df_6_mov['z_coord'] - df_6_mov['x_coord'])
mov_yz_array = np.asarray(df_6_mov['z_coord'] - df_6_mov['y_coord'])

fig1 = plt.figure()

# plt.plot(brk_xy_array)
# plt.xlabel("frame_number")
# plt.ylabel("xy_interaxial_position_diff")

plt.plot(mov_xy_array)
plt.xlabel("frame_number")
plt.ylabel("xy_interaxial_position_diff")


# %%
