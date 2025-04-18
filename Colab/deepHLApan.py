# -*- coding: utf-8 -*-
"""deephlapan_demo.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1lkaPIBFIxUS1UVPKt1x1wsAtMIqFTCmE
"""

# Commented out IPython magic to ensure Python compatibility.
import os
import sys
import subprocess
import shutil
os.environ['PYTHONPATH'] += "/env/python:/content/deephlapan/:/content/deephlapan/deephlapan"
sys.path.insert(2, 'deephlapan')
os.makedirs("input", exist_ok=True)

def install():
  os.system("pip uninstall -y tensorflow tensorflow-estimator keras")
  os.system("rm -r /content/deephlapan")
  os.system("git clone https://github.com/pabloapast/deephlapan.git")
  os.system("pip install -r /content/deephlapan/requirements.txt")

# Make software executable
  os.system("chmod +x /content/deephlapan/bin/deephlapan")

def test_s():
  # Run software
  return subprocess.run("(/content/deephlapan/bin/deephlapan -P LNIMNKLNI -H HLA-A02:01)",
      encoding="utf-8", capture_output=True, text=True,shell=True)

def test():
  # Run software
  return subprocess.run("(/content/deephlapan/bin/deephlapan -F /content/deephlapan/demo/1.csv -O /content/)",
      encoding="utf-8", capture_output=True, text=True,shell=True)


def run(filedir=None, convert=True):
  if not filedir:
    with os.scandir("input") as inputs:
      for input_sing in inputs:
        if os.path.isfile(input_sing) == True:
          input_sing = os.path.basename(input_sing)
          if input_sing.endswith(".csv"):
            filedir = "input/" + input_sing

  if not filedir:
    with os.scandir(".") as inputs:
      for input_sing in inputs:
        if os.path.isfile(input_sing) == True:
          input_sing = os.path.basename(input_sing)
          if input_sing.endswith(".csv"):
            filedir = input_sing
  if not filedir: #if it didnt find anything for some reason
  	raise FileException("Error: no file found. (Does it have a wrong extension or is it placed on the incorrect folder?)")
   
  #converting from a set structure#########################################
  import pandas as pd
  output = filedir[:-4]
  if convert:
    print("Converting CSV")
    filedirpath = os.path.dirname(filedir)
    os.makedirs(f"backup/{filedirpath}", exist_ok=True)
    shutil.copyfile(filedir, f"backup/{filedir}")
    df = pd.read_csv(filedir)
    #dfbkup = df
    df_headers = list(df.columns)
    deephlapan_headers = ['Annotation','HLA','peptide']
    #specific DeepHLAPAN Sorting

    #extra_df_headers = df_headers[3:] #extra is for future merging of csvs once I figure out how to use the output
    #extra_df = df.iloc[:, 3:]
    
    df = df.iloc[:, :3]
    df.columns = ['Annotation','peptide','HLA']
    df = df.reindex(columns=deephlapan_headers)
    df['Annotation'] = df['Annotation'].apply(lambda name: 'temp') #because otherwise it makes too many comparations?
    with open(filedir, 'w') as outfile:
      outfile.write(df.to_csv(index=False))
      outfile.close()
  ###################################################################
  os.makedirs("outputs", exist_ok=True)
  print("Processing... (This will take a long while! Limit your .csv size if you're having issues)")
  result = subprocess.run(f"(/content/deephlapan/bin/deephlapan -F {filedir} -O /content/outputs)",
      encoding="utf-8", capture_output=True, text=True,shell=True)
  if convert:
  	shutil.copyfile(f"backup/{filedir}", filedir)
  print("Success! Downloading your CSV shortly...")

  dfresult = pd.read_csv(f"outputs/{output}_predicted_result.csv")
  dfresultrank = pd.read_csv(f"outputs/{output}_predicted_result_rank.csv") #extra file for results with imm score > 0.5
  df_fullresult = pd.merge(dfresult,dfresultrank,how='left')
  df_fullresult = df_fullresult.add_prefix('DHP_')
  dfconcat = pd.concat([pd.read_csv(filedir), df_fullresult.iloc[:, 3:]], axis="columns")
  with open(f"{output}_DHL_results.csv", 'w') as outfile:
      outfile.write(dfconcat.to_csv(index=False))
      outfile.close()
  from google.colab import files
  files.download(f"{output}_DHL_results.csv")
  print(f"Downloaded on your local computer. Name: \"{output}_DHL_results.csv\"")
  return result
