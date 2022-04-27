# We want to use python packages here in Julia
using Pkg
Pkg.add("PyCall")  
using PyCall       
 
# now import the NLTK package from python
@pyimport nltk


