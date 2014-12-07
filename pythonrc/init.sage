#!/usr/bin/env sage -*- mode:python -*-

# Setup the shell environment for LaTeX
import os

binpaths = ['/usr/texbin','/usr/local/bin','/opt/local/bin']
texmfpaths = ['config/texmf-public','lavori/latex/texmf-private']

for p in binpaths:
    if os.path.isdir(p):
        os.environ["PATH"] += ':'+ p

if not os.environ.has_key("TEXMFHOME"):
    os.environ["TEXMFHOME"]=":".join([os.environ["HOME"]+"/" + p for p in texmfpaths])



# PDFLaTeX is faster and more powerful for graphics.
latex.engine('pdflatex')

# Style tuning
latex.blackboard_bold(False)
latex.matrix_delimiters(left='[',right=']')

# Graphics in notebook requires Mathjax to move on...
latex.add_to_mathjax_avoid_list('xymatrix')
latex.add_to_mathjax_avoid_list('tikzpicture')

# Packages for Graph Drawings (and tikzpicture)
latex.add_package_to_preamble_if_available('tikz')
latex.add_package_to_preamble_if_available('tkz-graph')
latex.add_package_to_preamble_if_available('tkz-berge')
