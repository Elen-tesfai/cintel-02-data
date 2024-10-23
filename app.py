import palmerpenguins
import pandas as pd
import shiny

app = shiny.App()

# Load the dataset
penguins_df = palmerpenguins.load_penguins()

@app.route("/")
def index():
    return shiny.render("Hello, Palmer Penguins!")

if __name__ == "__main__":
    app.run()
