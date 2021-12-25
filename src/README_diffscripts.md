Requirements:

- In KiAuto docker image:
  - apt install -f ghostscript
- runInKiAuto  
  Script that runs a command (parameters) in Docker image "setsoft/kicad_auto:dev"  
  TODO: change this call in the scripts (environment variable/...)
  
How this works:

- setup_git.sh
  Set up git repository so that git diff on *.kicad_pcb and *.sch calls the relevant scripts.  
  This script currently expects those scripts to be in the project directory.
  
- git-diff-sch-local.sh  
  - Called by `git diff *.kicad_sch"`, receives the git parameters.  
  - Copies git files to directory accessible from Docker constainer.
  - Executes `git-diff-sch.sh` in docker container.
  - Launch image viewer on difference image
- schematic-diff.sh  
  - Can be used as standalone script (for instance, to compare using kibot script).  
  - Generates "montage.png" showing the differences.
  - Used `gen-schematic-img.sh` to generate the images for a schematic version.
- gen-schematic-img.sh  
  Generate images for a schematic 
  
- git-diff-pcb-local.sh  
  - Called by `git diff *.kicad_sch"`, receives the git parameters.  
  - Copies git files to directory accessible from Docker constainer.
  - Executes `git-diff-pcb.sh` in docker container.
  - Launch image viewer on difference image
- pcb-diff.sh  
  - Can be used as standalone script (for instance, to compare using kibot script).  
  - Generates "montage.png" showing the differences.
  - Used `gen-pcb-img.sh` to generate the images for a pcb version.
- gen-schematic-img.sh  
  Generate images for a pcb.  
  The list of layers is fixed in the script.  Should be a configuration setting (environment variable/...).
  
  

# Other thoughts:

The "difference" images are using a "stereo" method where the output is black if both sides are the same and red or magenta otherwise.  
That is an interesting output, but it would also be interesting to generate a real difference file where the average sum of pixel values helps determine the differencE.

For the schematic difference, there is the "issue" of local schematic components.  I guess that the methods already used for kibot/kiauto could improve that.

This could evolve to be cable to compare a current version to some golden version (precomputed images), usefull for kibot runs (preflight) to ensure nothing changed compared to the golden output by putting an upper limit on the pixel differences.

Temporary locations and cleanup needs improvement.  
  
Could be transformed to "python" scripts (still using imagick tools).
