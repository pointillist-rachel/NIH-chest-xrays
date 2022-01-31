# NIH-chest-xrays
 A conv net for chest xrays. Each x-ray is assigned 0-14 conditions, so this is a multi-label classification problem. There is a python version (finished) and an R version (very much in progress).

## To Run the Python Version:
1. Clone this repo
2. Download the data from Kaggle here: https://www.kaggle.com/nickuzmenkov/nih-chest-xrays-tfrecords (it may take about 20 minutes)

You'll get a zip file called archive.zip containing 
 - preprocessed_data.csv 
 - data (a folder)
   - 256 tfrecord files with names like 001-438.tfrec. The first three numbers are the tfrecord index, ranging from 000 to 255. The last three numbers are the number of pngs in that file, either 438 or 437. In total, there are 112,120 chest x-rays in this folder.

3. Extract the data and move it (the folder labeled data and preprocessed_data.csv) into the cloned repository folder. 
4. Open NIH-chest-xrays-in-python.ipynb
5. Run the first 10 code blocks to open and explore the data. If you encounter a File Not Found error, make sure the contents of the zip file in step 2 have been extracted and moved to the repo, and that the repo is the current working directory (in a new cell, type os.getcwd(), run it, and make sure the result ends in "/NIH-chest-xrays/")
6. Now you have options. 

      a) If you're really interested, run the code under "Finding the Best Learning Rate". 
      
      b) If that's not your bag, you can safely skip to "Retrain Some Layers". Training the model can take a few hours. 
      
      c) If you don't have a few hours to wait (and who does), [download the trained weights here](https://drive.google.com/file/d/1qXgg5or6rFXTR-H9zrntTuWsEaVQir-g/view?usp=sharing), move them into your repo, and run code blocks 11 and 18.
