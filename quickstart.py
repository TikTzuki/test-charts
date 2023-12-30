import argparse
import json
import os
import shutil
from typing import Dict


def replace_content(filename, map: Dict):
  shutil.copyfile(filename, filename + ".bak")
  print("file: " + filename)
  f = open(filename, mode="r")
  content = f.read()
  f.close()

  new_content = content
  for key, value in map.items():
    new_content = new_content.replace(key, value)

  f = open(filename, mode="w")
  f.write(new_content)
  f.close()


def restore(filename):
  if os.path.isfile(filename + ".bak"):
    os.rename(filename + ".bak", filename)


def mapping_file_to_dict(filepath) -> Dict:
  with open(filepath) as f:
    return json.load(f)


def main():
  version = "0.0.1"
  banner = f"""
 _     ___  ____    ____ ____    _____ _____ ____ _____
| |   / _ \\/ ___|  / ___|___ \\  |_   _| ____/ ___|_   _|
| |  | | | \\___ \\  \\___ \\ __) |   | | |  _| \\___ \\ | |
| |__| |_| |___) |  ___) / __/    | | | |___ ___) || |
|_____\\___/|____/  |____/_____|   |_| |_____|____/ |_|

     =========|_|==============
      :: Los Test ::                (v{version})
    """
  parser = argparse.ArgumentParser(usage=banner)
  parser.add_argument("-c", "--command", help="Command", default="gen")
  parser.add_argument("-i", "--input", help="Input file key=value form, default=all")
  parser.add_argument("-d", "--directory", help="Template directory")
  parser.add_argument("-v", "--version", action="store_true", help="print the version number and exit")
  args = parser.parse_args()
  if args.version:
    print(version)
    return

  input_file = args.input
  directory = args.directory
  command = args.command
  if command in {"gen", "g"}:
    print("Generate charts")
    mapping_dict = mapping_file_to_dict(input_file)
    print(mapping_dict)
    for subdir, dirs, files in os.walk(directory):
      for file in files:
        filepath = subdir + os.sep + file
        if file.endswith((".tpl", ".yaml", ".txt", ".md")):
          replace_content(filepath, mapping_dict)
  elif command in {"restore", "r"}:
    print("Quick start restore")
    for subdir, dirs, files in os.walk(directory):
      for file in files:
        filepath = subdir + os.sep + file
        if not file.endswith(".bak"):
          restore(filepath)


if __name__ == '__main__':
  main()
#   s = """
# annotations:
#   category: %%CHOOSE_ONE_FROM_CHART_CATEGORIES_FILE%%
#   licenses: Apache-2.0
# apiVersion: v2
# appVersion: %%UPSTREAM_PROJECT_VERSION%%
# dependencies:
#   - condition: SUBCHART_NAME.enabled
#     name: SUBCHART_NAME
#     repository: oci://registry-1.docker.io/bitnamicharts
#     version: %%MAJOR_SUBCHART_VERSION_(A.X.X)%%
#   - name: common
#     repository: oci://registry-1.docker.io/bitnamicharts
#     tags:
#       - bitnami-common
#     version: 2.x.x""".replace(
#     "- condition: SUBCHART_NAME.enabled\n    name: SUBCHART_NAME\n    repository: oci://registry-1.docker.io/bitnamicharts\n    version: %%MAJOR_SUBCHART_VERSION_(A.X.X)%%\n",
#     "")
#   print(s)
