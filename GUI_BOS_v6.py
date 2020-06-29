# BOS Cross-Correlation - v6
# Written by: JoshTheEngineer
# Website   : www.joshtheengineer.com
# YouTube   : www.youtube.com/joshtheengineer
# Started: 09/10/19
# Updated: 09/10/19 - Started code
#                   - Works as expected
#          09/15/19 - Added image sub-region selection functionality
#                   - Added comments
#          09/18/19 - Added some capabilities
#          09/19/19 - Added deep copying to allow thresholding to work

# Import stuff for computations and plotting
import numpy as np
import math as m
import copy
import PIL.Image                                                                # Avoid namespace issues
import matplotlib.pyplot as plt
from normxcorr2 import normxcorr2
import matplotlib.patches as patches

# Import some tkinter things for GUI stuff
import tkinter as tk
from tkinter import Tk
from tkinter import ttk
from tkinter import Button, Entry, Label, Checkbutton
from tkinter import Frame, CENTER, END
from tkinter import filedialog

# Define the GUI_BOS class
class GUI_BOS:
    def __init__(self, parent):
        self.myParent = parent
        self.containerLoad    = Frame(parent)                                   # Create LOAD container
        self.containerCompute = Frame(parent)                                   # Create COMPUTE container
        self.containerPlot    = Frame(parent)                                   # Create PLOT container
        self.containerPost    = Frame(parent)                                   # Create POST container

        # Place containers
        self.containerLoad.grid(column = 0, row = 0, columnspan = 3)            # Place the LOAD container
        self.containerCompute.grid(column = 0, row = 1)                         # Place the COMPUTE container
        self.containerPlot.grid(column = 1, row = 1)                            # Place the PLOT container
        self.containerPost.grid(column = 2, row = 1, sticky = "NS")             # Place the POST container
        
        # Get spacing of POST container correct
        # - Edit boxes line up with appropriate checkbox in PLOT container
        self.containerPost.grid_rowconfigure(0, weight = 0)                     # Set weight for row 0
        self.containerPost.grid_rowconfigure(1, weight = 0)                     # Set weight for row 1
        self.containerPost.grid_rowconfigure(2, weight = 1)                     # Set weight for row 2
        self.containerPost.grid_rowconfigure(3, weight = 1)                     # Set weight for row 3
        self.containerPost.grid_rowconfigure(4, weight = 4)                     # Set weight for row 4
        self.containerPost.grid_rowconfigure(5, weight = 1)                     # Set weight for row 5
        self.containerPost.grid_rowconfigure(6, weight = 1)                     # Set weight for row 6
        self.containerPost.grid_rowconfigure(7, weight = 1)                     # Set weight for row 7
        self.containerPost.grid_rowconfigure(8, weight = 1)                     # Set weight for row 8
        
        # Instance variables
        self.I1                = None                                           # Image 1
        self.I2                = None                                           # Image 2
        self.I1Orig            = None                                           # Original Image 1
        self.I2Orig            = None                                           # Original Image 2
        self.CC                = None                                           # Column meshgrid
        self.RR                = None                                           # Row meshgrid
        self.cOffset           = None                                           # Column offset
        self.rOffset           = None                                           # Row offset
        self.quivU             = None                                           # X-displacement
        self.quivV             = None                                           # Y-displacement
        self.quivVel           = None                                           # Total displacement
        self.XX                = None                                           # Scaled X-position (for plotting)
        self.YY                = None                                           # Scaled Y-position (for plotting)
        self.thresh            = tk.DoubleVar()                                 # Threshold
        self.chkShowImage1     = tk.IntVar()                                    # Checkbox value to show image 1 upon loading
        self.chkShowImage2     = tk.IntVar()                                    # Checkbox value to show image 2 upon loading
        self.chkUseSubRegion   = tk.IntVar()                                    # Checkbox value to select sub-region for computations
        self.chkValPlotVelVec  = tk.IntVar()                                    # Checkbox value to plot velocity vectors
        self.chkValPlotOrigImg = tk.IntVar()                                    # Checkbox value to plot original image and contour
        self.chkValPlotX       = tk.IntVar()                                    # Checkbox value to plot X-displacement contour
        self.chkValPlotY       = tk.IntVar()                                    # Checkbox value to plot Y-displacement contour
        self.chkValPlotTot     = tk.IntVar()                                    # Checkbox value to plot total-displacement contour
        self.xSelTL            = 0                                              # Top-left selected X-value
        self.ySelTL            = 0                                              # Top-left selected Y-value
        self.xSelBR            = 0                                              # Bottom-right selected X-value
        self.ySelBR            = 0                                              # Bottom-right selected Y-value
        self.winXS             = 275                                            # Figure window X-offset from original displayed position
        self.winYS             = 75                                             # Figure window Y-offset from original displayed position
        
        # ---------------------------------------------------------------------
        # ---------------------------------------------------------------------
        # --------------------------- W I D G E T S ---------------------------
        # ---------------------------------------------------------------------
        # ---------------------------------------------------------------------
        
        # // == // ============= \\ == \\
        # // == // == L O A D == \\ == \\
        # // == // ============= \\ == \\
        
        # ===== Check: Show Image 1 =====
        self.checkShowImage1 = Checkbutton(self.containerLoad)
        self.checkShowImage1.configure(text = "Show Image",
                                       variable = self.chkShowImage1)
                
        # ===== Button: Load Image 1 =====
        self.buttonLoadImage1 = Button(self.containerLoad)
        self.buttonLoadImage1.configure(text="Load Image 1",
                                        bg = "Steel Blue",
                                        fg = "White",
                                        activeforeground = "White",
                                        activebackground = "Black",
                                        command = self.pushLoadImage1)
        
        # ===== Static Text: Image 1 Filename =====
        self.textImage1File = Entry(self.containerLoad)
        self.textImage1File.configure(bg = "White", fg = "Black", width = 100)
        
        # ===== Check: Show Image 2 =====
        self.checkShowImage2 = Checkbutton(self.containerLoad)
        self.checkShowImage2.configure(text = "Show Image",
                                       variable = self.chkShowImage2)
        
        # ===== Button: Load Image 2 =====
        self.buttonLoadImage2 = Button(self.containerLoad)
        self.buttonLoadImage2.configure(text="Load Image 2",
                                        bg = "Steel Blue",
                                        fg = "White",
                                        activeforeground = "White",
                                        activebackground = "Black",
                                        command = self.pushLoadImage2)
        
        # ===== Static Text: Image 1 Filename =====
        self.textImage2File = Entry(self.containerLoad)
        self.textImage2File.configure(bg = "White", fg = "Black", width = 100)
        
        # // == // =================== \\ == \\
        # // == // == C O M P U T E == \\ == \\
        # // == // =================== \\ == \\
        
        # ===== Label: Window Size =====
        self.textWSize = Label(self.containerCompute)
        self.textWSize.configure(text = "Window Size", height=1, width = 11)
        
        # ===== Entry: Window Size =====
        self.editWSize = Entry(self.containerCompute)
        self.editWSize.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editWSize.delete(0,END)
        self.editWSize.insert(0,"32")
        
        # ===== Label: Search Size =====
        self.textSSize = Label(self.containerCompute)
        self.textSSize.configure(text = "Search Size", height=1, width = 11)
        
        # ===== Entry: Search Size =====
        self.editSSize = Entry(self.containerCompute)
        self.editSSize.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editSSize.delete(0,END)
        self.editSSize.insert(0,"64")
        
        # ===== Check: Select Sub-Region =====
        self.checkSelectSubRegion = Checkbutton(self.containerCompute)
        self.checkSelectSubRegion.configure(text = "Select Sub-Region",
                                            variable = self.chkUseSubRegion)
        
        # ===== Button: Select Sub-Region & Crop =====
        self.buttonSelectSubRegion = Button(self.containerCompute)
        self.buttonSelectSubRegion.configure(text = "Select Sub-Region",
                                             bg = "Steel Blue",
                                             fg = "White",
                                             activeforeground = "White",
                                             activebackground = "Black",
                                             command = self.pushSelectSubRegion)
        
        # ===== Button: Check Sub-Region and Windows =====
        self.buttonCheckSubRegion = Button(self.containerCompute)
        self.buttonCheckSubRegion.configure(text = "Check Sub-Region",
                                            bg = "Steel Blue",
                                            fg = "White",
                                            activeforeground = "White",
                                            activebackground = "Black",
                                            command = self.pushCheckSubRegion)
        
        # ===== Button: Compute =====
        self.buttonCompute = Button(self.containerCompute)
        self.buttonCompute.configure(text = "Compute",
                                     bg = "Steel Blue",
                                     fg = "White",
                                     activeforeground = "White",
                                     activebackground = "Black",
                                     command = self.pushCompute)
        
        # // == // ============= \\ == \\
        # // == // == P L O T == \\ == \\
        # // == // ============= \\ == \\
        
        # ===== Label: Threshold =====
        self.textThreshold = Label(self.containerPlot)
        self.textThreshold.config(text = "Threshold")
        
        # ===== Entry: Threshold =====
        self.editThreshold = Entry(self.containerPlot)
        self.editThreshold.config(bg = "White", fg = "Black", justify = CENTER)
        self.editThreshold.delete(0,END)
        self.editThreshold.insert(0,"5")
        
        # ===== Pop: Colormap =====
        self.popColormap = ttk.Combobox(self.containerPlot,
                                        values = ["plasma",
                                                  "jet",
                                                  "bone",
                                                  "viridis"])
        
        # ===== Check: Plot Velocity Vectors =====
        self.checkPlotVelVec = Checkbutton(self.containerPlot)
        self.checkPlotVelVec.configure(text = "Plot Velocity Vectors",
                                       variable = self.chkValPlotVelVec)
        
        # ===== Check: Plot Orig Img Contour =====
        self.checkPlotOrigImg = Checkbutton(self.containerPlot)
        self.checkPlotOrigImg.configure(text = "Plot Orig Img Contour",
                                        variable = self.chkValPlotOrigImg)
        
        # ===== Pop: Orig Img Contour ======
        self.popOrigImgXYTot = ttk.Combobox(self.containerPlot,
                                            values = ["X",
                                                      "Y",
                                                      "Tot"])
        
        # ===== Label: Alpha =====
        self.textAlpha = Label(self.containerPlot)
        self.textAlpha.configure(text = "Alpha")
        
        # ===== Entry: Alpha =====
        self.editAlpha = Entry(self.containerPlot)
        self.editAlpha.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editAlpha.delete(0,END)
        self.editAlpha.insert(0,"0.6")
        
        # ===== Check: Plot X-Displacement =====
        self.checkPlotXDisplacement = Checkbutton(self.containerPlot)
        self.checkPlotXDisplacement.configure(text = "Plot X Displacement",
                                              variable = self.chkValPlotX)
        
        # ===== Check: Plot Y-Displacement =====
        self.checkPlotYDisplacement = Checkbutton(self.containerPlot)
        self.checkPlotYDisplacement.configure(text = "Plot Y Displacement",
                                              variable = self.chkValPlotY)
        
        # ===== Check: Plot Total Displacement =====
        self.checkPlotTotDisplacement = Checkbutton(self.containerPlot)
        self.checkPlotTotDisplacement.configure(text = "Plot Total Displacement",
                                                variable = self.chkValPlotTot)
        
        # ===== Button: Plot =====
        self.buttonPlot = Button(self.containerPlot)
        self.buttonPlot.configure(text = "Plot",
                                  bg = "Steel Blue",
                                  fg = "White",
                                  activeforeground = "White",
                                  activebackground = "Black",
                                  command = self.pushPlot)
                
        # // == // ============= \\ == \\
        # // == // == P O S T == \\ == \\
        # // == // ============= \\ == \\
        
        # ===== Entry: Orig Img Contour Start Caxis =====
        self.editCS_OrigImg = Entry(self.containerPost)
        self.editCS_OrigImg.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editCS_OrigImg.delete(0,END)
        self.editCS_OrigImg.insert(0,"0")
        self.editCS_OrigImg.bind("<Return>", self.editAdjustColormap_OrigImg)
        
        # ===== Entry: Orig Img Contour End Caxis =====
        self.editCE_OrigImg = Entry(self.containerPost)
        self.editCE_OrigImg.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editCE_OrigImg.delete(0,END)
        self.editCE_OrigImg.insert(0,"0")
        self.editCE_OrigImg.bind("<Return>", self.editAdjustColormap_OrigImg)
        
        # ===== Label: Threshold =====
        self.textColorbar_OrigImg = Label(self.containerPost)
        self.textColorbar_OrigImg.config(text = "Colorbar Limits")
        
        # ===== Entry: X-Displacement Contour Start Caxis =====
        self.editCS_X = Entry(self.containerPost)
        self.editCS_X.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editCS_X.delete(0,END)
        self.editCS_X.insert(0,"0")
        self.editCS_X.bind("<Return>", self.editAdjustColormap_X)
        
        # ===== Entry: X-Displacement Contour End Caxis =====
        self.editCE_X = Entry(self.containerPost)
        self.editCE_X.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editCE_X.delete(0,END)
        self.editCE_X.insert(0,"0")
        self.editCE_X.bind("<Return>", self.editAdjustColormap_X)
        
        # ===== Label: Threshold =====
        self.textColorbar_X = Label(self.containerPost)
        self.textColorbar_X.config(text = "Colorbar Limits")
        
        # ===== Entry: Y-Displacement Contour Start Caxis =====
        self.editCS_Y = Entry(self.containerPost)
        self.editCS_Y.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editCS_Y.delete(0,END)
        self.editCS_Y.insert(0,"0")
        self.editCS_Y.bind("<Return>", self.editAdjustColormap_Y)
        
        # ===== Entry: Y-Displacement Contour End Caxis =====
        self.editCE_Y = Entry(self.containerPost)
        self.editCE_Y.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editCE_Y.delete(0,END)
        self.editCE_Y.insert(0,"0")
        self.editCE_Y.bind("<Return>", self.editAdjustColormap_Y)
        
        # ===== Label: Threshold =====
        self.textColorbar_Y = Label(self.containerPost)
        self.textColorbar_Y.config(text = "Colorbar Limits")
        
        # ===== Entry: Total Displacement Contour Start Caxis =====
        self.editCS_Tot = Entry(self.containerPost)
        self.editCS_Tot.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editCS_Tot.delete(0,END)
        self.editCS_Tot.insert(0,"0")
        self.editCS_Tot.bind("<Return>", self.editAdjustColormap_Tot)
        
        # ===== Entry: Total Displacement Contour End Caxis =====
        self.editCE_Tot = Entry(self.containerPost)
        self.editCE_Tot.configure(bg = "White", fg = "Black", justify = CENTER)
        self.editCE_Tot.delete(0,END)
        self.editCE_Tot.insert(0,"0")
        self.editCE_Tot.bind("<Return>", self.editAdjustColormap_Tot)
        
        # ===== Label: Threshold =====
        self.textColorbar_Tot = Label(self.containerPost)
        self.textColorbar_Tot.config(text = "Colorbar Limits")
        
        # ===== Label: Placeholder 1 =====
        self.textPlaceholder1 = Label(self.containerPost)
        self.textPlaceholder1.configure(text = "")
        
        # ===== Label: Placeholder 2 =====
        self.textPlaceholder2 = Label(self.containerPost)
        self.textPlaceholder2.configure(text = "")
        
        # ===== Label: Placeholder 3 =====
        self.textPlaceholder3 = Label(self.containerPost)
        self.textPlaceholder3.configure(text = "")
        
        # ===== Label: Placeholder 4 =====
        self.textPlaceholder4 = Label(self.containerPost)
        self.textPlaceholder4.configure(text = "")
        
        # ---------------------------------------------------------------------
        # ---------------------------------------------------------------------
        # ----------------------------- L A Y O U T ---------------------------
        # ---------------------------------------------------------------------
        # ---------------------------------------------------------------------
        
        # LOAD
        self.checkShowImage1.grid(column = 0, row = 0)
        self.buttonLoadImage1.grid(column = 1, row = 0)
        self.textImage1File.grid(column = 2, row = 0)
        self.checkShowImage2.grid(column = 0, row = 1)
        self.buttonLoadImage2.grid(column = 1, row = 1)
        self.textImage2File.grid(column = 2, row = 1)
        # COMPUTE
        self.textWSize.grid(column = 0, row = 0)
        self.editWSize.grid(column = 1, row = 0)
        self.textSSize.grid(column = 0, row = 1)
        self.editSSize.grid(column = 1, row = 1)
        self.checkSelectSubRegion.grid(column = 0, row = 2, columnspan = 2, sticky = "EW")
        self.buttonSelectSubRegion.grid(column = 0, row = 3, columnspan = 2, sticky = "EW")
        self.buttonCheckSubRegion.grid(column = 0, row = 4, columnspan = 2, sticky = "EW")
        self.buttonCompute.grid(column = 0, row = 5, columnspan = 2, sticky = "EW")
        # PLOT
        self.textThreshold.grid(column = 0, row = 0, columnspan = 2, sticky = "EW")
        self.editThreshold.grid(column = 2, row = 0, columnspan = 1, sticky = "EW")
        self.popColormap.grid(column = 0, row = 1, columnspan = 3, sticky = "EW")
        self.popColormap.current(0)
        self.checkPlotVelVec.grid(column = 0, row = 2, columnspan = 3, sticky = "EW")
        self.checkPlotOrigImg.grid(column = 0, row = 3, columnspan = 3, sticky = "EW")
        self.popOrigImgXYTot.grid(column = 0, row = 4, sticky = "EW")
        self.popOrigImgXYTot.current(0)
        self.textAlpha.grid(column = 1, row = 4, sticky = "EW")
        self.editAlpha.grid(column = 2, row = 4, sticky = "EW")
        self.checkPlotXDisplacement.grid(column = 0, row = 5, columnspan = 3, sticky = "EW")
        self.checkPlotYDisplacement.grid(column = 0, row = 6, columnspan = 3, sticky = "EW")
        self.checkPlotTotDisplacement.grid(column = 0, row = 7, columnspan = 3, sticky = "EW")
        self.buttonPlot.grid(column = 0, row = 8, columnspan = 3, sticky = "EW")
        # POST
        self.textPlaceholder1.grid(column = 0, row = 0, columnspan = 3, sticky = "EW")              # Row 0
        self.textPlaceholder2.grid(column = 0, row = 1, columnspan = 3, sticky = "EW")              # Row 1
        self.textPlaceholder3.grid(column = 0, row = 2, columnspan = 3, sticky = "EW")              # Row 2
        self.editCS_OrigImg.grid(column = 0, row = 3, sticky = "EW")                                # \
        self.textColorbar_OrigImg.grid(column = 1, row = 3, sticky = "EW")                          # | -> Row 3
        self.editCE_OrigImg.grid(column = 2, row = 3, sticky = "EW")                                # /
        self.textPlaceholder4.grid(column = 0, row = 4, columnspan = 3, sticky = "EW")              # Row 4
        self.editCS_X.grid(column = 0, row = 5, sticky = "EW")                                      # \ ->
        self.textColorbar_X.grid(column = 1, row = 5, sticky = "EW")                                # | -> Row 5
        self.editCE_X.grid(column = 2, row = 5, sticky = "EW")                                      # /
        self.editCS_Y.grid(column = 0, row = 6, sticky = "EW")                                      # \
        self.textColorbar_Y.grid(column = 1, row = 6, sticky = "EW")                                # | -> Row 6
        self.editCE_Y.grid(column = 2, row = 6, sticky = "EW")                                      # /
        self.editCS_Tot.grid(column = 0, row = 7, sticky = "EW")                                    # \
        self.textColorbar_Tot.grid(column = 1, row = 7, sticky = "EW")                              # | -> Row 7
        self.editCE_Tot.grid(column = 2, row = 7, sticky = "EW")                                    # /
        self.textPlaceholder4.grid(column = 0, row = 8, columnspan = 3, sticky = "EW")              # Row 8
        self.textPlaceholder4.grid(column = 0, row = 9, columnspan = 3, sticky = "EW")              # Row 9
        
    # ================================
    # ===== Method: Load Image 1 =====
    # ================================
    # Reference: https://pillow.readthedocs.io/en/5.1.x/handbook/concepts.html
    def pushLoadImage1(self):
        
        file_path = filedialog.askopenfilename(initialdir = "C:/Users/Josh/Documents/DIY_BOS/",
                                       title = "Select Image 1",
                                       filetypes = (("All Files", "*.jpg;*.png;*.tif;*.tiff;*.bmp"),
                                                    ("JPG Files", "*.jpg"),
                                                    ("PNG Files", "*.png"),
                                                    ("TIF Files", "*.tif;*.tiff"),
                                                    ("BMP Files", "*.bmp")))
#        file_path = filedialog.askopenfilename(initialdir = "C:/Users/Josh/Documents/YouTube_Files/DIY_BOS/",
#                                               title = "Select Image 1",
#                                               filetypes = (("All Files", "*.jpg;*.png;*.tif;*.tiff;*.bmp"),
#                                                            ("JPG Files", "*.jpg"),
#                                                            ("PNG Files", "*.png"),
#                                                            ("TIF Files", "*.tif;*.tiff"),
#                                                            ("BMP Files", "*.bmp")))
        self.I1 = PIL.Image.open(file_path)                                     # Open the image
        self.textImage1File.delete(0,END)                                       # Delete any strings in text box for file name
        self.textImage1File.insert(0,file_path)                                 # Add file name to the text box
        self.I1Orig = self.I1                                                   # Save original image for plotting
        self.I1 = self.I1.convert("L")                                          # Convert image to 8-bit black and white (L)
        
        if (self.chkShowImage1.get()):                                          # If user wants to see loaded image
            plt.figure(1)                                                       # Open figure for plotting
            plt.imshow(self.I1, cmap = "gray")                                  # Plot the image
        
    # ================================
    # ===== Method: Load Image 2 =====
    # ================================
    # Reference: https://pillow.readthedocs.io/en/5.1.x/handbook/concepts.html
    def pushLoadImage2(self):
        
        file_path = filedialog.askopenfilename(initialdir = "C:/Users/Josh/Documents/DIY_BOS/",
                               title = "Select Image 1",
                               filetypes = (("All Files", "*.jpg;*.png;*.tif;*.tiff;*.bmp"),
                                            ("JPG Files", "*.jpg"),
                                            ("PNG Files", "*.png"),
                                            ("TIF Files", "*.tif;*.tiff"),
                                            ("BMP Files", "*.bmp")))
#        file_path = filedialog.askopenfilename(initialdir = "C:/Users/Josh/Documents/YouTube_Files/DIY_BOS/",
#                                               title = "Select Image 1",
#                                               filetypes = (("All Files", "*.jpg;*.png;*.tif;*.tiff;*.bmp"),
#                                                            ("JPG Files", "*.jpg"),
#                                                            ("PNG Files", "*.png"),
#                                                            ("TIF Files", "*.tif;*.tiff"),
#                                                            ("BMP Files", "*.bmp")))
        self.I2 = PIL.Image.open(file_path)                                     # Open the image
        self.textImage2File.delete(0,END)                                       # Delete any strings in text box for file name
        self.textImage2File.insert(0,file_path)                                 # Add file name to the text box
        self.I2Orig = self.I2                                                   # Save original image for plotting
        self.I2 = self.I2.convert("L")                                          # Convert image to 8-bit black and white (L)
        
        if (self.chkShowImage2.get()):                                          # If user wants to see loaded image
            plt.figure(2)                                                       # Open figure for plotting
            plt.imshow(self.I2, cmap = "gray")                                  # Plot the image
    
    # =====================================
    # ===== Method: Select Sub-Region =====
    # =====================================
    # Reference: https://matplotlib.org/3.1.1/users/event_handling.html
    def pushSelectSubRegion(self):
        
        fig2 = plt.figure(2)                                                    # Create figure
        plt.imshow(self.I2, cmap="gray")                                        # Show the image
        fig2.canvas.mpl_connect('button_press_event',self.pushSelectCropRegion) # Link button clicks on the image to a method
    
    # ==============================================
    # ===== Method: Select Sub-Region (Part 2) =====
    # ==============================================
    # Reference: https://matplotlib.org/3.1.1/users/event_handling.html
    def pushSelectCropRegion(self, event):
        
        if (event.button == 1):                                                 # If user clicked left mouse button
            print("Selected Top-Left")                                          # Print message to the console
            self.xSelTL = event.xdata                                           # Store top-left X-values
            self.ySelTL = event.ydata                                           # Store top-left Y-values
        elif (event.button == 3):                                               # If user clicked right mouse button
            print("Selected Bottom-Right")                                      # Print message to the console
            self.xSelBR = event.xdata                                           # Store bottom-right X-values
            self.ySelBR = event.ydata                                           # Store bottom-right Y-values

    # ==========================================
    # ===== Method: Get Crop Region Bounds =====
    # ==========================================
    def getCropI(self):
        
        if (self.chkUseSubRegion.get()):                                        # If user wants to use a cropped image for the calculations
            x1 = self.xSelTL                                                    # Get the top-left (TL) X-value
            x2 = self.xSelBR                                                    # Get the bottom-right (BR) X-value
            y1 = self.ySelTL                                                    # Get the top-left (TL) Y-value
            y2 = self.ySelBR                                                    # Get the bottom-right (BR) Y-value
        
            if (x1 < x2):                                                       # If TL X-value is smaller than BR X-value
                xMin = int(x1)                                                  # Set min X-value to TL X-value
                xMax = int(x2)                                                  # Set max X-value to BR X-value
            else:                                                               # If TL X-value is larger than BR X-value
                xMin = int(x2)                                                  # Set min X-value to BR X-value
                xMax = int(x1)                                                  # Set max X-value to TL X-value
            
            if (y1 < y2):                                                       # If TL Y-value is smaller than BR Y-value
                yMin = int(y1)                                                  # Set min Y-value to TL Y-value
                yMax = int(y2)                                                  # Set max Y-value to BR Y-value
            else:                                                               # If TL Y-value is larger than BR Y-value
                yMin = int(y2)                                                  # Set min Y-value to BR Y-value
                yMax = int(y1)                                                  # Set max Y-value to TL Y-value
        
            self.cropI = (xMin, yMin, xMax, yMax)                               # Set the cropping window limits
        else:                                                                   # If user does not want to use a cropped image for the calculations
            xMax, yMax = np.size(self.I2)                                       # Size of the full image
            self.cropI = (0, 0, xMax-1, yMax-1)                                 # Set the crop region to the size of the full image
            
    # ================================================
    # ===== Method: Check Sub-Region and Windows =====
    # ================================================
    def pushCheckSubRegion(self):
        
        # Call the method to get the cropped region
        self.getCropI()                                                         # Call method to get the crop region bounds
        
        # Window and search sizes
        wSize  = int(self.editWSize.get())                                      # Get window size from the edit text box
        sSize  = int(self.editSSize.get())                                      # Get search size from the edit text box
        wSize2 = np.floor(wSize/2)                                              # Half the window size
        sSize2 = np.floor(sSize/2)                                              # Half the search size
        
        # Get center of cropped region to display windows
        xC = self.cropI[0] + 0.5*(self.cropI[2] - self.cropI[0])                # X-center of the crop region
        yC = self.cropI[1] + 0.5*(self.cropI[3] - self.cropI[1])                # Y-center of the crop region
        
        plt.figure(2)                                                           # Select the figure for image 2 if displayed
        plt.close(2)                                                            # Close that figure
        self.fig2 = plt.figure(2)                                               # Select appropriate figure
        self.ax2  = self.fig2.add_subplot(111, aspect='equal')                  # Add a subplot
        plt.cla()                                                               # Clear the axes
        plt.imshow(self.I2Orig, cmap = "gray")                                  # Plot the original Image 2
        
        # Create a Rectangle patch for sub-region
        rectSR = patches.Rectangle((self.cropI[0],self.cropI[1]),               # Create rectangle to show sub-region on image
                                 self.cropI[2] - self.cropI[0],
                                 self.cropI[3] - self.cropI[1],
                                 edgecolor = 'r', facecolor = 'none',
                                 linewidth = 2, linestyle = '-')
        
        # Create a Rectangle patch for window size
        rectW = patches.Rectangle((xC-wSize2,yC-wSize2), wSize, wSize,          # Create rectangle to show window size
                                  edgecolor = "Blue", facecolor = "none",           # Color = blue, no face color
                                  linewidth = 2, linestyle = '-')                   # Thicker linewidth than normal, solid line
        
        # Create a Rectangle patch for search size
        rectS = patches.Rectangle((xC-sSize2,yC-sSize2), sSize, sSize,          # Create rectangle to show search size
                                  edgecolor = "Cyan", facecolor = "none",           # Color = cyan, no face color
                                  linewidth = 2, linestyle = '-')                   # Thicker linewidth than normal, solid line
        
        # Plot the rectangle for the crop region
        self.ax2.add_patch(rectSR)                                              # Add the crop region rectangle to the axes
        self.ax2.add_patch(rectW)                                               # Add the window rectangle to the axes
        self.ax2.add_patch(rectS)                                               # Add the search rectangle to the axes
        plt.show()                                                              # Show the plot
        
        fm            = plt.get_current_fig_manager()                           # Get the current figure manager
        geom          = fm.window.geometry()                                    # Get the geometry of the window
        x,y,winW,winH = geom.getRect()                                          # Extract the geometry of the window
        fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)              # Set the window geometry to new values
        
    # ===========================
    # ===== Method: Compute =====
    # ===========================
    def pushCompute(self):
        
        # Call the method to get the cropped region
        self.getCropI()                                                         # Call method to get the crop region bounds
        
        # Set new images based on option to crop or not
        if (self.chkUseSubRegion.get()):                                        # If user wants to use a cropped region
            I1Crop    = np.array(self.I1.crop(self.cropI))                      # Crop image 1
            I2Crop    = np.array(self.I2.crop(self.cropI))                      # Crop image 2
            I1Compute = PIL.Image.fromarray(I1Crop)                             # Convert back from array to image
            I2Compute = PIL.Image.fromarray(I2Crop)                             # Convert back from array to image
        else:                                                                   # If user does not want to use a cropped region
            I1Compute = self.I1                                                 # Don't crop original image 1
            I2Compute = self.I2                                                 # Don't crop original image 2
        
        numRows_I = I1Compute.size[1]                                           # Number of rows of the image
        numCols_I = I1Compute.size[0]                                           # Number of columns of the image
        
        # Window and search sizes
        wSize  = int(self.editWSize.get())                                      # Get window size from the edit text box
        sSize  = int(self.editSSize.get())                                      # Get search size from the edit text box
        
        # Window and search half-sizes
        wSize2 = m.floor(wSize/2)                                               # Compute half-window size
        sSize2 = m.floor(sSize/2)                                               # Compute half-search size
        
        # Window centers
        wIndR = np.arange(wSize,(numRows_I-wSize2),wSize)                       # Find the centers of the row windows
        wIndC = np.arange(wSize,(numCols_I-wSize2),wSize)                       # Find the centers of the column windows
        
        # Meshgrid
        RR, CC = np.meshgrid(wIndR,wIndC)                                       # Create the row/column meshgrid
        RR     = np.transpose(RR)                                               # Transpose the row meshgrid
        CC     = np.transpose(CC)                                               # Transpose the column meshgrid
        
        # Initialize variables for the loops
        colPeak   = np.zeros((len(wIndR),len(wIndC)))                           # Column-shift peak
        rowPeak   = np.zeros((len(wIndR),len(wIndC)))                           # Row-shift peak
        colOffset = np.zeros((len(wIndR),len(wIndC)))                           # Actual column pixel shift
        rowOffset = np.zeros((len(wIndR),len(wIndC)))                           # Actual row pixel shift
        
        # Loop
        for i in range(len(wIndR)):                                             # Loop over all row window centers
            print("Iteration: ",i,"/",len(wIndR)-1)                             # Print current iteration to console
            for j in range(len(wIndC)):                                         # Loop over all column window centers
                
                # Get window centers
                rowCenter = wIndR[i]                                            # Current iteration row window center
                colCenter = wIndC[j]                                            # Current iteration column window center
                
                # Crop the image to WINDOW size
                # - im1 = im.crop((left, top, right, bottom))
                cropI1    = (colCenter-wSize2, rowCenter-wSize2,                # Define the crop region using the window center and the window size
                             colCenter+wSize2, rowCenter+wSize2)
                I1_Sub    = np.array(I1Compute.crop(cropI1))                    # Crop the image (Image 1) to its window size
                        
                # Crop the template to SEARCH size
                # - im1 = im.crop((left, top, right, bottom))
                cropI2    = (colCenter-sSize2, rowCenter-sSize2,                # Define the crop region using the window center and the search size
                             colCenter+sSize2, rowCenter+sSize2)
                I2_Sub    = np.array(I2Compute.crop(cropI2))                    # Crop the image (Image 2) to its search size
                        
                # Check whether window or search arrays have a constant value in entire array
                I1_Sub_SameVals = np.array_equal(I1_Sub,np.full(np.shape(I1_Sub),I1_Sub[0]))
                I2_Sub_SameVals = np.array_equal(I2_Sub,np.full(np.shape(I2_Sub),I2_Sub[0]))
                
                if (I1_Sub_SameVals or I2_Sub_SameVals):                        # If values in either matrix are all the same
                    print('I1_Sub/I2_Sub has same values in entire matrix!')    # Print notice (not an error)
                    rPeak = 0                                                   # Set row peak to zero
                    cPeak = 0                                                   # Set column peak to zero
                    dR    = 0                                                   # Set sub-pixel row delta to zero
                    dC    = 0                                                   # Set sub-pixel column delta to zero
                else:
                    # Compute normalized cross-correlation
                    c         = normxcorr2(I1_Sub,I2_Sub)                       # Compute the normalized cross-correlation between the two cropped images
                    maxCInd   = np.unravel_index(c.argmax(), c.shape)           # Find (X,Y) tuple of max value of cross-correlation matrix
                    rPeak     = maxCInd[1]                                      # Peak row-value from normalized cross-correlation
                    cPeak     = maxCInd[0]                                      # Peak column-value from normalized cross-correlation
                    c         = abs(c)                                          # Make sure none of the matrix values are negative (logs don't like negatives)
                    c[c == 0] = 0.0001                                          # Make sure there are no zeros in the c matrix (logs don't like zeros)
                    cC, rC    = np.shape(c)                                     # Get size of cross-correlation matrix (CC-matrix)
                    
                    # To avoid errors with subpixel peak point calculations
                    if (rPeak == 0):                                            # If row peak is zero
                        rPeak = rPeak + 1                                       # Add one to row peak
                    if (rPeak == rC-1):                                         # If row peak is one less than size of CC-matrix rows
                        rPeak = rC - 2                                          # Subtract one from row peak
                    if (cPeak == 0):                                            # If column peak is zero
                        cPeak = cPeak + 1                                       # Add one to column peak
                    if (cPeak == cC-1):                                         # If column peak is one less than size of CC-matrix columns
                        cPeak = cC - 2                                          # Subtract one from column peak
                                
                    # Sub-pixel peak point (3-point Gaussian)
                    numR = m.log(c[cPeak][rPeak-1]) - m.log(c[cPeak][rPeak+1])
                    denR = 2*m.log(c[cPeak][rPeak-1]) - 4*m.log(c[cPeak][rPeak]) + 2*m.log(c[cPeak][rPeak+1])
                    dR   = numR/denR
                    numC = m.log(c[cPeak-1][rPeak]) - m.log(c[cPeak+1][rPeak])
                    denC = 2*m.log(c[cPeak-1][rPeak]) - 4*m.log(c[cPeak][rPeak]) + 2*m.log(c[cPeak+1][rPeak])
                    dC   = numC/denC
                
                # Find the peak indices of the cross-correlation map
                colPeak[i][j] = cPeak + dC
                rowPeak[i][j] = rPeak + dR
                
                # Find the pixel offsets for X and Y directions
                colOffset[i][j] = colPeak[i][j] - wSize2 - sSize2 + 1           # Correct the column pixel shift for window and search sizes
                rowOffset[i][j] = rowPeak[i][j] - wSize2 - sSize2 + 1           # Correct the row pixel shift for window and search sizes
        
        # Move the contour plot over the image to correct location
        XX     = CC - np.min(CC)                                                # Shift X-values to origin of image
        YY     = RR - np.min(RR)                                                # Shift Y-values to origin of image
        scaleX = (self.cropI[2] - self.cropI[0])/np.max(XX)                     # Scale X-value to get sub-region correct size
        scaleY = (self.cropI[3] - self.cropI[1])/np.max(YY)                     # Scale Y-value to get sub-region correct size
        XX     = XX*scaleX + self.cropI[0]                                      # Shift the X-values to the sub-region
        YY     = YY*scaleY + self.cropI[1]                                      # Shift the Y-values to the sub-region
        
        # Set instance variables for plotting
        self.cOffset = colOffset                                                # Non-thresholded column shift
        self.rOffset = rowOffset                                                # Non-thresholded row shift
        self.CC      = CC                                                       # Column meshgrid
        self.RR      = RR                                                       # Row meshgrid
        self.XX      = XX                                                       # Shifted coordinates for plotting overlay
        self.YY      = YY                                                       # Shifted coordinates for plotting overlay
        
    # ========================
    # ===== Method: Plot =====
    # ========================
    def pushPlot(self):
                
        # Get relevant instance variables
        alphaVal = float(self.editAlpha.get())
        thresh   = float(self.editThreshold.get())                              # Get threshold value from edit text box
        quivX    = copy.deepcopy(self.CC)                                       # Set X-values from column meshgrid
        quivY    = copy.deepcopy(self.RR)                                       # Set Y-values from row meshgrid
        quivU    = copy.deepcopy(self.rOffset)                                  # Set U-displacement from row offset
        quivV    = copy.deepcopy(self.cOffset)                                  # Set V-displacement from column offset
        
        # Apply threshold to results
        quivU[abs(quivU) > thresh] = np.nan                                     # Apply min/max value threshold to U-displacement
        quivV[abs(quivV) > thresh] = np.nan                                     # Apply min/max value threshold to V-displacement
        quivVel = np.sqrt(np.square(quivU) + np.square(quivV))                  # Compute total displacement from thresholded values
        
        # Re-set the threshold for total displacement and threshold all data
        testVal = np.sqrt(thresh**2 + thresh**2)                                # Compute total displacement threshold
        quivU[quivVel == testVal]   = np.nan                                    # Apply threshold to X displacement
        quivV[quivVel == testVal]   = np.nan                                    # Apply threshold to Y displacement
        quivVel[quivVel == testVal] = np.nan                                    # Apply threshold to total displacement
        
        # Set default colorbar limits to zero to keep things clean
        self.editCS_OrigImg.delete(0,END)                                       # Delete any existing text
        self.editCS_OrigImg.insert(0,0)                                         # Add new caxis starting bound
        self.editCE_OrigImg.delete(0,END)                                       # Delete any existing text
        self.editCE_OrigImg.insert(0,0)                                         # Add new caxis ending bound
        self.editCS_X.delete(0,END)                                             # Delete any existing text
        self.editCS_X.insert(0,0)                                               # Add new caxis starting bound
        self.editCE_X.delete(0,END)                                             # Delete any existing text
        self.editCE_X.insert(0,0)                                               # Add new caxis ending bound
        self.editCS_Y.delete(0,END)                                             # Delete any existing text
        self.editCS_Y.insert(0,0)                                               # Add new caxis starting bound
        self.editCE_Y.delete(0,END)                                             # Delete any existing text
        self.editCE_Y.insert(0,0)                                               # Add new caxis ending bound
        self.editCS_Tot.delete(0,END)                                           # Delete any existing text
        self.editCS_Tot.insert(0,0)                                             # Add new caxis starting bound
        self.editCE_Tot.delete(0,END)                                           # Delete any existing text
        self.editCE_Tot.insert(0,0)                                             # Add new caxis ending bound
        
        # Plot the velocity vectors if user wants to
        if (self.chkValPlotVelVec.get()):
            plt.figure(4)                                                       # Select figure 4
            plt.close(4)                                                        # Close the figure
            plt.figure(4)                                                       # Select appropriate figure
            plt.cla()                                                           # Clear the axes
            plt.plot(quivX,quivY,'k.')                                          # Plot the window centers with black dots
            plt.quiver(quivX,quivY,quivU,-quivV,scale=None,color='r')           # Plot the velocity vectors (flip Y-displacement)
            plt.xlabel('X-Axis')                                                # Set X-label
            plt.ylabel('Y-Axis')                                                # Set Y-label
            plt.gca().invert_yaxis()                                            # Invert the Y-axis (to compare to MATLAB)
            plt.gca().set_aspect('equal')                                       # Set the axes to equal size
            plt.title("Displacement Vectors")                                   # Set plot title
            plt.show()                                                          # Show the plot
            
            fm            = plt.get_current_fig_manager()                       # Get the current figure manager
            geom          = fm.window.geometry()                                # Get the geometry of the window
            x,y,winW,winH = geom.getRect()                                      # Extract the geometry of the window
            fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)          # Set the window geometry to new values
            
        # Plot the original image contour if user wants to
        if (self.chkValPlotOrigImg.get()):
            plt.figure(5)                                                       # Select figure 5
            plt.close(5)                                                        # Close figure 5
            self.fig5 = plt.figure(5)                                           # Select appropriate figure
            self.ax5  = self.fig5.add_subplot(111, aspect='equal')
            plt.cla()                                                           # Clear the axes
            plt.imshow(self.I2Orig, cmap = "gray")                              # Plot the original Image 2
            
            # Create a Rectangle patch
            rect = patches.Rectangle((self.cropI[0],self.cropI[1]),             # Create rectangle to show sub-region on image
                                     self.cropI[2] - self.cropI[0],
                                     self.cropI[3] - self.cropI[1],
                                     edgecolor = 'k', facecolor = 'none',
                                     linewidth = 1, linestyle = '--')
            self.ax5.add_patch(rect)                                            # Add the rectangle to the axes
            
            if (self.popOrigImgXYTot.get() == "X"):                             # If user wants to overlay X-displacement contour
                plt.contourf(self.XX,self.YY,quivU,100,                         # Plot the X-displacement contour
                         cmap = self.popColormap.get(),
                         extend = 'both',
                         alpha = alphaVal,
                         antialiased = True)
            elif (self.popOrigImgXYTot.get() == "Y"):                           # If user wants to overlay Y-displacement contour
                plt.contourf(self.XX,self.YY,quivV,100,                         # Plot the Y-displacement contour
                         cmap = self.popColormap.get(),                             # Set colormap limits
                         extend = 'both',                                           # Extend colormap beyond explicit limits
                         alpha = alphaVal,                                          # Set transparency to user-defined value
                         antialiased = True)                                        # Enable anti-aliasing
            elif (self.popOrigImgXYTot.get() == "Tot"):                         # If user wants to overlay total displacement contour
                plt.contourf(self.XX,self.YY,quivVel,100,                       # Plot the total displacement contour
                         cmap = self.popColormap.get(),                             # Set colormap limits
                         extend = 'both',                                           # Extend colormap beyond explicit limits
                         alpha = alphaVal,                                          # Set transparency to user-defined value
                         antialiased = True)                                        # Enable anti-aliasing
            plt.colorbar()                                                      # Display the colorbar
            plt.show()                                                          # Show the plot
            
            fm            = plt.get_current_fig_manager()                       # Get the current figure manager
            geom          = fm.window.geometry()                                # Get the geometry of the window
            x,y,winW,winH = geom.getRect()                                      # Extract the geometry of the window
            fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)          # Set the window geometry to new values
            
            # Set the color axis limits in the Entry boxes
            vMin, vMax = plt.gci().get_clim()                                   # Get existing limits for the colormap
            self.editCS_OrigImg.delete(0,END)                                   # Delete any existing text
            self.editCS_OrigImg.insert(0,vMin)                                  # Add new caxis starting bound
            self.editCE_OrigImg.delete(0,END)                                   # Delete any existing text
            self.editCE_OrigImg.insert(0,vMax)                                  # Add new caxis ending bound
            
        # Plot the X-displacement if the user wants to
        if (self.chkValPlotX.get()):
            plt.figure(6)                                                       # Select figure 6
            plt.close(6)                                                        # Close the figure
            plt.figure(6)                                                       # Select appropriate figure
            plt.cla()                                                           # Clear the axes
            plt.contourf(quivX,quivY,quivU,100,                                 # Plot the X-displacement contour
                         cmap = self.popColormap.get(), extend = 'both')
            plt.gca().invert_yaxis()                                            # Invert the Y-axis
            plt.gca().set_aspect('equal')                                       # Set the axes equal
            plt.colorbar()                                                      # Show the colorbar
            plt.title('X Displacement')                                         # Set the plot title
            plt.show()                                                          # Show the plot

            fm            = plt.get_current_fig_manager()                       # Get the current figure manager
            geom          = fm.window.geometry()                                # Get the geometry of the window
            x,y,winW,winH = geom.getRect()                                      # Extract the geometry of the window
            fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)          # Set the window geometry to new values
            
            # Set the color axis limits in the Entry boxes
            vMin, vMax = plt.gci().get_clim()
            self.editCS_X.delete(0,END)                                         # Delete any existing text
            self.editCS_X.insert(0,vMin)                                        # Add new caxis starting bound
            self.editCE_X.delete(0,END)                                         # Delete any existing text
            self.editCE_X.insert(0,vMax)                                        # Add new caxis ending bound
            
        # Plot the Y-displacement if the user wants to
        if (self.chkValPlotY.get()):
            plt.figure(7)                                                       # Select figure 7
            plt.close(7)                                                        # Close the figure
            plt.figure(7)                                                       # Select appropriate figure
            plt.cla()                                                           # Clear the axes
            plt.contourf(quivX,quivY,quivV,100,                                 # Plot the Y-displacement contour
                         cmap = self.popColormap.get(), extend = 'both')
            plt.gca().invert_yaxis()                                            # Invert the Y-axis
            plt.gca().set_aspect('equal')                                       # Set the axes equal
            plt.colorbar()                                                      # Show the colorbar
            plt.title('Y Displacement')                                         # Set the plot title
            plt.show()                                                          # Show the plot
            
            fm            = plt.get_current_fig_manager()                       # Get the current figure manager
            geom          = fm.window.geometry()                                # Get the geometry of the window
            x,y,winW,winH = geom.getRect()                                      # Extract the geometry of the window
            fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)          # Set the window geometry to new values
            
            # Set the color axis limits in the Entry boxes
            vMin, vMax = plt.gci().get_clim()
            self.editCS_Y.delete(0,END)                                         # Delete any existing text
            self.editCS_Y.insert(0,vMin)                                        # Add new caxis starting bound
            self.editCE_Y.delete(0,END)                                         # Delete any existing text
            self.editCE_Y.insert(0,vMax)                                        # Add new caxis ending bound
            
        # Plot the total displacement if the user wants to
        if (self.chkValPlotTot.get()):
            plt.figure(8)                                                       # Select figure 8
            plt.close(8)                                                        # Close figure 8
            plt.figure(8)                                                       # Select appropriate figure
            plt.cla()                                                           # Clear the axes
            plt.contourf(quivX,quivY,quivVel,100,                               # Plot the total displacement contour
                         cmap = self.popColormap.get(), extend = 'both')
            plt.gca().invert_yaxis()                                            # Invert the Y-axis
            plt.gca().set_aspect('equal')                                       # Set the axes equal
            plt.colorbar()                                                      # Show the colorbar
            plt.title('Total Displacement')                                     # Set the plot title
            plt.show()                                                          # Show the plot
            
            fm            = plt.get_current_fig_manager()                       # Get the current figure manager
            geom          = fm.window.geometry()                                # Get the geometry of the window
            x,y,winW,winH = geom.getRect()                                      # Extract the geometry of the window
            fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)          # Set the window geometry to new values
            
            # Set the color axis limits in the Entry boxes
            vMin, vMax = plt.gci().get_clim()
            self.editCS_Tot.delete(0,END)                                       # Delete any existing text
            self.editCS_Tot.insert(0,vMin)                                      # Add new caxis starting bound
            self.editCE_Tot.delete(0,END)                                       # Delete any existing text
            self.editCE_Tot.insert(0,vMax)                                      # Add new caxis ending bound
                    
    # ===================================================
    # ===== Method: Set Colormap Start for Orig Img =====
    # ===================================================
    def editAdjustColormap_OrigImg(self, event):
        
        valCS = float(self.editCS_OrigImg.get())                                # Get user-defined starting value of colorbar
        valCE = float(self.editCE_OrigImg.get())                                # Get user-defined ending value of colorbar
        
        # Get relevant instance variables
        alphaVal = float(self.editAlpha.get())
        thresh   = float(self.editThreshold.get())                              # Get threshold value from edit text box
        quivU    = copy.deepcopy(self.rOffset)                                  # Set U-displacement from row offset
        quivV    = copy.deepcopy(self.cOffset)                                  # Set V-displacement from column offset
        
        # Apply threshold to results
        quivU[abs(quivU) > thresh] = np.nan                                     # Apply min/max value threshold to U-displacement
        quivV[abs(quivV) > thresh] = np.nan                                     # Apply min/max value threshold to V-displacement
        quivVel = np.sqrt(np.multiply(quivU,quivU) + np.multiply(quivV,quivV))  # Compute total displacement from thresholded values
        
        # Re-set the threshold for total displacement
        testVal = np.sqrt(thresh**2 + thresh**2)                                # Compute total displacement threshold
        quivVel[quivVel == testVal] = np.nan                                    # Apply threshold to total displacement
        
        # Close old figure
        plt.close(5)                                                            # Close the figure
        plt.figure(5)                                                           # Select appropriate figure
        plt.cla()                                                               # Clear the axes
        plt.imshow(self.I2Orig, cmap = "gray")                                  # Plot the original Image 2
        
        # Create a Rectangle patch
        rect = patches.Rectangle((self.cropI[0],self.cropI[1]),                 # Create rectangle to show sub-region on image
                                 self.cropI[2] - self.cropI[0],
                                 self.cropI[3] - self.cropI[1],
                                 edgecolor = 'k', facecolor = 'none',
                                 linewidth = 1, linestyle = '--')
        self.ax5.add_patch(rect)                                                # Add the rectangle to the axes
        
        if (self.popOrigImgXYTot.get() == "X"):                                 # If user wants to overlay X-displacement contour
            plt.contourf(self.XX,self.YY,quivU,np.linspace(valCS,valCE,100),    # Plot the X-displacement contour
                     cmap = self.popColormap.get(),                                 # Set colormap limits
                     extend = 'both',                                               # Extend colormap beyond explicit limits
                     alpha = alphaVal,                                              # Set transparency to user-defined value
                     antialiased = True)                                            # Enable anti-aliasing
        elif (self.popOrigImgXYTot.get() == "Y"):                               # If user wants to overlay Y-displacement contour
            plt.contourf(self.XX,self.YY,quivV,np.linspace(valCS,valCE,100),    # Plot the Y-displacement contour
                     cmap = self.popColormap.get(),                                 # Set colormap limits
                     extend = 'both',                                               # Extend colormap beyond explicit limits
                     alpha = alphaVal,                                              # Set transparency to user-defined value
                     antialiased = True)                                            # Enable anti-aliasing
        elif (self.popOrigImgXYTot.get() == "Tot"):                             # If user wants to overlay total displacement contour
            plt.contourf(self.XX,self.YY,quivVel,np.linspace(valCS,valCE,100),  # Plot the total displacement contour
                     cmap = self.popColormap.get(),                                 # Set colormap limits
                     extend = 'both',                                               # Extend colormap beyond explicit limits
                     alpha = alphaVal,                                              # Set transparency to user-defined value
                     antialiased = True)                                            # Enable anti-aliasing
        plt.colorbar()                                                          # Display the colorbar
        plt.show()                                                              # Show the plot
        
        fm            = plt.get_current_fig_manager()                           # Get the current figure manager
        geom          = fm.window.geometry()                                    # Get the geometry of the window
        x,y,winW,winH = geom.getRect()                                          # Extract the geometry of the window
        fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)              # Set the window geometry to new values
        
    # ============================================
    # ===== Method: Set Colormap Start for X =====
    # ============================================
    def editAdjustColormap_X(self, event):
        
        valCS = float(self.editCS_X.get())                                      # Get user-defined starting value of colorbar
        valCE = float(self.editCE_X.get())                                      # Get user-defined ending value of colorbar
        
        # Get relevant instance variables
        thresh  = float(self.editThreshold.get())                               # Get threshold value from edit text box
        quivU   = copy.deepcopy(self.rOffset)                                   # Set U-displacement from row offset
        quivV   = copy.deepcopy(self.cOffset)                                   # Set V-displacement from column offset
        
        # Apply threshold to results
        quivU[abs(quivU) > thresh] = np.nan                                     # Apply min/max value threshold to U-displacement
        quivV[abs(quivV) > thresh] = np.nan                                     # Apply min/max value threshold to V-displacement
        
        plt.close(6)                                                            # Close the figure
        plt.figure(6)                                                           # Select appropriate figure
        plt.cla()                                                               # Clear the axes
        plt.contourf(self.XX,self.YY,quivU,np.linspace(valCS,valCE,100),        # Plot the X-displacement contour
                     cmap=self.popColormap.get(), extend='both')
        plt.gca().invert_yaxis()                                                # Invert the Y-axis
        plt.gca().set_aspect('equal')                                           # Set the axes equal
        plt.colorbar()                                                          # Show the colorbar
        plt.title('X Displacement')                                             # Set the plot title
        plt.show()                                                              # Show the plot
        
        fm            = plt.get_current_fig_manager()                           # Get the current figure manager
        geom          = fm.window.geometry()                                    # Get the geometry of the window
        x,y,winW,winH = geom.getRect()                                          # Extract the geometry of the window
        fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)              # Set the window geometry to new values
            
    # ============================================
    # ===== Method: Set Colormap Start for Y =====
    # ============================================
    def editAdjustColormap_Y(self, event):
        
        valCS = float(self.editCS_Y.get())                                      # Get user-defined starting value of colorbar
        valCE = float(self.editCE_Y.get())                                      # Get user-defined ending value of colorbar
        
        # Get relevant instance variables
        thresh  = float(self.editThreshold.get())                               # Get threshold value from edit text box
        quivU   = copy.deepcopy(self.rOffset)                                   # Set U-displacement from row offset
        quivV   = copy.deepcopy(self.cOffset)                                   # Set V-displacement from column offset
        
        # Apply threshold to results
        quivU[abs(quivU) > thresh] = np.nan                                     # Apply min/max value threshold to U-displacement
        quivV[abs(quivV) > thresh] = np.nan                                     # Apply min/max value threshold to V-displacement
        
        plt.close(7)
        plt.figure(7)                                                           # Select appropriate figure
        plt.cla()                                                               # Clear the axes
        plt.contourf(self.XX,self.YY,quivV,np.linspace(valCS,valCE,100),        # Plot the Y-displacement contour
                     cmap=self.popColormap.get(), extend='both')
        plt.gca().invert_yaxis()                                                # Invert the Y-axis
        plt.gca().set_aspect('equal')                                           # Set the axes equal
        plt.colorbar()                                                          # Show the colorbar
        plt.title('Y Displacement')                                             # Set the plot title
        plt.show()                                                              # Show the plot
        
        fm            = plt.get_current_fig_manager()                           # Get the current figure manager
        geom          = fm.window.geometry()                                    # Get the geometry of the window
        x,y,winW,winH = geom.getRect()                                          # Extract the geometry of the window
        fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)              # Set the window geometry to new values
        
    # ==============================================
    # ===== Method: Set Colormap Start for Tot =====
    # ==============================================
    def editAdjustColormap_Tot(self, event):
        
        valCS = float(self.editCS_Tot.get())                                    # Get user-defined starting value of colorbar
        valCE = float(self.editCE_Tot.get())                                    # Get user-defined ending value of colorbar
        
        # Get relevant instance variables
        thresh  = float(self.editThreshold.get())                               # Get threshold value from edit text box
        quivU   = copy.deepcopy(self.rOffset)                                   # Set U-displacement from row offset
        quivV   = copy.deepcopy(self.cOffset)                                   # Set V-displacement from column offset
        
        # Apply threshold to results
        quivU[abs(quivU) > thresh] = np.nan                                     # Apply min/max value threshold to U-displacement
        quivV[abs(quivV) > thresh] = np.nan                                     # Apply min/max value threshold to V-displacement
        quivVel = np.sqrt(np.multiply(quivU,quivU) + np.multiply(quivV,quivV))  # Compute total displacement from thresholded values
        
        # Re-set the threshold for total displacement
        testVal = np.sqrt(thresh**2 + thresh**2)                                # Compute total displacement threshold
        quivVel[quivVel == testVal] = -thresh                                   # Apply threshold to total displacement
        
        plt.close(8)
        plt.figure(8)                                                           # Select appropriate figure
        plt.cla()                                                               # Clear the axes
        plt.contourf(self.XX,self.YY,quivVel,np.linspace(valCS,valCE,100),      # Plot the total displacement contour
                     cmap=self.popColormap.get(), extend='both')
        plt.gca().invert_yaxis()                                                # Invert the Y-axis
        plt.gca().set_aspect('equal')                                           # Set the axes equal
        plt.colorbar()                                                          # Show the colorbar
        plt.title('Total Displacement')                                         # Set the plot title
        plt.show()                                                              # Show the plot
        
        fm            = plt.get_current_fig_manager()                           # Get the current figure manager
        geom          = fm.window.geometry()                                    # Get the geometry of the window
        x,y,winW,winH = geom.getRect()                                          # Extract the geometry of the window
        fm.window.setGeometry(x+self.winXS,y+self.winYS,winW,winH)              # Set the window geometry to new values
        
root = Tk()
root.wm_title("BOS Processing")                                                 # Set window title
gui_bos = GUI_BOS(root)                                                         # Instantiate the class GUI_BOS
root.mainloop()
