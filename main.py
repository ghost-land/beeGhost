import customtkinter
import os
from PIL import Image, ImageTk
import asyncio
from generate_db import generate_db
import threading
import urllib.request
from io import BytesIO
import json

class App(customtkinter.CTk):
    def __init__(self):
        super().__init__()
        self.images = []

        self.title("beeGhost")
        self.geometry("700x450")

        # set grid layout 1x2
        self.grid_rowconfigure(0, weight=1)
        self.grid_columnconfigure(1, weight=1)

        # load images with light and dark mode image
        image_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "images")
        self.logo_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "logo.ico")), size=(26, 26))
        self.banner = customtkinter.CTkImage(Image.open(os.path.join(image_path, "banner.png")), size=(500, 150))
        self.image_icon_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "logo.ico")), size=(20, 20))
        self.home_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "home_dark.png")),
                                                 dark_image=Image.open(os.path.join(image_path, "home_light.png")), size=(20, 20))
        self.settings_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "settings_dark.png")),
                                                 dark_image=Image.open(os.path.join(image_path, "settings_light.png")), size=(20, 20))
        self.add_user_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "add_user_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "add_user_light.png")), size=(20, 20))

        # create navigation frame
        self.navigation_frame = customtkinter.CTkFrame(self, corner_radius=0)
        self.navigation_frame.grid(row=0, column=0, sticky="nsew")
        self.navigation_frame.grid_rowconfigure(4, weight=1)

        self.navigation_frame_label = customtkinter.CTkLabel(self.navigation_frame, text=" beeGhost", image=self.logo_image,
                                                             compound="left", font=customtkinter.CTkFont(size=15, weight="bold"))
        self.navigation_frame_label.grid(row=0, column=0, padx=20, pady=20)

        self.home_button = customtkinter.CTkButton(self.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Home",
                                                   fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                   image=self.home_image, anchor="w", command=self.home_button_event)
        self.home_button.grid(row=1, column=0, sticky="ew")

        self.settings_button = customtkinter.CTkButton(self.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Settings",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                      image=self.settings_image, anchor="w", command=self.settings_button_event)
        self.settings_button.grid(row=2, column=0, sticky="ew")


        self.appearance_mode_menu = customtkinter.CTkOptionMenu(self.navigation_frame, values=["System", "Light", "Dark"],
                                                                command=self.change_appearance_mode_event)
        self.appearance_mode_menu.grid(row=6, column=0, padx=20, pady=20, sticky="s")

        # create home frame
        self.home_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
        self.home_frame.grid_columnconfigure(0, weight=1)

        self.home_frame_large_image_label = customtkinter.CTkLabel(self.home_frame, text="", image=self.banner)
        self.home_frame_large_image_label.grid(row=0, column=0, padx=20, pady=10)

        #self.home_frame_button_1 = customtkinter.CTkButton(self.home_frame, text="", image=self.image_icon_image)
        #self.home_frame_button_1.grid(row=1, column=0, padx=20, pady=10)

        # progress bar
        self.progress_bar = customtkinter.CTkProgressBar(self.home_frame, corner_radius=50, height=20,
                                                        fg_color=("gray70", "gray30"))
        self.progress_bar.grid(row=2, column=0, padx=20, pady=10, sticky="ew")
        self.progress_bar.set(0)

        # create settings frame
        self.settings_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")

        # Display image from link in ghosteshop.json
        self.canvas = customtkinter.CTkCanvas(self.home_frame)
        # make the canvas 5x higher than the window height to allow scrolling
        self.canvas.grid(row=3, column=0, sticky="nsew")

        self.scrollbar = customtkinter.CTkScrollbar(self.home_frame, command=self.canvas.yview)
        self.scrollbar.grid(row=3, column=1, sticky="ns")

        # attach scrollbar to canvas
        self.canvas.configure(yscrollcommand=self.scrollbar.set)


                
        # select default frame
        self.select_frame_by_name("home")



    def select_frame_by_name(self, name):
        # set button color for selected button
        self.home_button.configure(fg_color=("gray75", "gray25") if name == "home" else "transparent")
        self.settings_button.configure(fg_color=("gray75", "gray25") if name == "settings" else "transparent")

        # show selected frame
        if name == "home":
            self.home_frame.grid(row=0, column=1, sticky="nsew")
        else:
            self.home_frame.grid_forget()
        if name == "settings":
            self.settings_frame.grid(row=0, column=1, sticky="nsew")
        else:
            self.settings_frame.grid_forget()

    def home_button_event(self):
        self.select_frame_by_name("home")

    def settings_button_event(self):
        self.select_frame_by_name("settings")

    def change_appearance_mode_event(self, new_appearance_mode):
        customtkinter.set_appearance_mode(new_appearance_mode)

        
def display_images(app):
    with open('ghosteshop.json', "r", encoding="utf-8") as json_file:
        data = json.load(json_file)
    for i, image in enumerate(data["storeContent"]):
        #set the number of columns to the width of the canvas divided by the width of the image
        
        url = image["info"]["icon_url"]
        with urllib.request.urlopen(url) as u:
            raw_data = u.read()
        im = Image.open(BytesIO(raw_data))
        columns = int(app.canvas.cget("width")) // im.width*2
        tk_im = ImageTk.PhotoImage(im)
        app.images.append(tk_im)  # Add the new tk_im to a list
        
        row = i // columns  # Calculate the row position of the image
        col = i % columns   # Calculate the column position of the image
        
        x = col * im.width
        y = row * im.height

        #if y is greater than the height of the canvas, resize the canvas
        if y > int(app.canvas.cget("height")):
            break 
        app.canvas.create_image(x, y, image=tk_im, anchor="nw")

def update_progress_bar(progress_bar):
    # Run generate_db as a task in the event loop
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.create_task(generate_db(progress_bar))
    loop.run_forever()

if __name__ == "__main__":
    app = App()
    threading.Thread(target=update_progress_bar, args=(app.progress_bar,), daemon=True).start()
    threading.Thread(target=display_images, args=(app,), daemon=True).start()
    app.mainloop()