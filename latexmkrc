# Config
$pdf_mode=1;
$pdf_previewer = 'xdg-open';
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode --shell-escape %O %S';
@generated_exts = (@generated_exts, 'synctex.gz');
$clean_ext = "nav out snm aux log out toc bbl blg";
