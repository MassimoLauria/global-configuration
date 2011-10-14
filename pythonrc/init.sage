#!/usr/bin/env sage

# Setup the shell environment for LaTeX
import os

binpaths = ['/usr/texbin','/usr/local/bin','/opt/local/bin']

for p in binpaths:
    if os.path.isdir(p):
        os.environ["PATH"] += ':'+ p

if not os.environ.has_key("TEXMFHOME"):
    os.environ["TEXMFHOME"]=os.environ["HOME"]+"/config/texmf"


# PDFLaTeX is faster and more powerful for graphics.
latex.engine('pdflatex')

# Style tuning
latex.blackboard_bold(False)
latex.matrix_delimiters(left='[',right=']')

# Graphics in notebook requires JSMath to move on...
latex.add_to_jsmath_avoid_list('xymatrix')
latex.add_to_jsmath_avoid_list('tikzpicture')

# Packages for Graph Drawings (and tikzpicture)
latex.add_package_to_preamble_if_available('tikzpicture')
latex.add_package_to_preamble_if_available('tkz-graph')
latex.add_package_to_preamble_if_available('tkz-berge')
