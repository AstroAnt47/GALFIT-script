PRO GALscript
; #################################################################
; This script runs GALFIT for set of FITS files. It first reads the
; input FITS from a list. The script generates a GALFIT input file.
; Then the script runs GALFIT and repeats the process. The script
; checks if the GALFIT's output image exists or not. If GALFIT has
; failed to fit and produce output image, the script writes a report
; of it to its own output file.
; #################################################################
; Reading the name of the input FITS from a file:

starttime = SYSTIME() ; Start time of the run


CLOSE, 1 ; Closing a file that can possibly be open already.

; # The file with all the names of data images have to be created before this! # ;

; Cluster  ID
cluster = 'RXJ1720'

; Open the file with input image names.
file = FILEPATH('imagenames.list',ROOT_DIR=['~'],SUBDIRECTORY=['locuss',cluster])
OPENR, lun, file, /GET_LUN

; Read one line at the time and save to array
imagenames = ''
line = ''
WHILE NOT EOF(lun) DO BEGIN & $
  READF, lun, line & $
  imagenames = [imagenames,line] & $
ENDWHILE

; Close the file and free the file unit
FREE_LUN, lun

samplesize = SIZE(imagenames,/N_ELEMENTS) -1 ; Number of the filenames.
                                             ; (minus 1 because of the indexing)

; #################################################################
; #################################################################
; Loop for generating GALFIT inputfile and running GALFIT.
; Each iteration contains the inputfile generation and GALFIT run.


  ; Open file for script output. Problems will be saved here.
scriptfile = FILEPATH('galscript.output',ROOT_DIR=['~'],SUBDIRECTORY=['locuss',cluster])
OPENW, lun2, scriptfile, /GET_LUN
; Print date to scripts output file.
PRINTF, lun2, '# '+starttime+' #'


; #################################################################
; #################################################################
; Begin a FOR loop for iterating through all the files
;
; #################################################################

; --------------------------
FOR i =1,samplesize DO BEGIN
; --------------------------

    ; Open the file.
  galfitfile = FILEPATH('galscript.input',ROOT_DIR=['~'],SUBDIRECTORY=['locuss',cluster])
  OPENW, lun, galfitfile, /GET_LUN

  imagename = imagenames[i]

; Generating a GALFIT input file (same parameter values than test.input)
; #################################################################
PRINTF,lun, '================================================================================'
PRINTF,lun, '# IMAGE and GALFIT CONTROL PARAMETERS'
PRINTF,lun, 'A) ',imagename,'      # Input data image (FITS file)'
PRINTF,lun, 'B) gal2_',imagename,'      # Output data image block'
PRINTF,lun, 'C) none                # Sigma image name (made from data if blank or "none")'
PRINTF,lun, 'D) psf_',cluster,'.fits            # Input PSF image and (optional) diffusion kernel'
PRINTF,lun, 'E) 1                   # PSF fine sampling factor relative to data'
PRINTF,lun, 'F) none                # Bad pixel mask (FITS image or ASCII coord list)'
PRINTF,lun, 'G) constraints.txt                # File with parameter constraints (ASCII file)'
PRINTF,lun, 'H) 1    50   1    50   # Image region to fit (xmin xmax ymin ymax)'
PRINTF,lun, 'I) 160     160           # Size of the convolution box (x y)'
PRINTF,lun, 'J) 33.630              # Magnitude photometric zeropoint'
PRINTF,lun, 'K) 0.20  0.20        # Plate scale (dx dy)   [arcsec per pixel]'
PRINTF,lun, 'O) regular             # Display type (regular, curses, both)'
PRINTF,lun, 'P) 0                   # Choose: 0=optimize, 1=model, 2=imgblock, 3=subcomps'
PRINTF,lun, ' '
PRINTF,lun, '# INITIAL FITTING PARAMETERS'
PRINTF,lun, '# '
PRINTF,lun, '#   For component type, the allowed functions are:'
PRINTF,lun, '#       sersic, expdisk, edgedisk, devauc, king, nuker, psf,'
PRINTF,lun, '#       gaussian, moffat, ferrer, and sky.'
PRINTF,lun, '# '
PRINTF,lun, '#   Hidden parameters will only appear when they"re specified:'
PRINTF,lun, '#       Bn (n=integer, Bending Modes).'
PRINTF,lun, '#       C0 (diskyness/boxyness),'
PRINTF,lun, '#       Fn (n=integer, Azimuthal Fourier Modes).'
PRINTF,lun, '#       R0-R10 (coordinate rotation, for creating spiral structures).'
PRINTF,lun, '#       To, Ti, T0-T10 (truncation function).'
PRINTF,lun, '# '
PRINTF,lun, '# ------------------------------------------------------------------------------'
PRINTF,lun, '#   par)    par value(s)    fit toggle(s)    # parameter description'
PRINTF,lun, '# ------------------------------------------------------------------------------'
PRINTF,lun, ' '
PRINTF,lun, '# Component number: 1'
PRINTF,lun, '0) sersic                 #  Component type'
PRINTF,lun, '1) 25  25  1 1  #  Position x, y'
PRINTF,lun, '3) 21.0    1          #  Integrated magnitude'
PRINTF,lun, '4) 6.0237      1          #  R_e (effective radius)   [pix]'
PRINTF,lun, '5) 2.      1          #  Sersic index n (de Vaucouleurs n=4)'
PRINTF,lun, '6) 0.0000      0          #     -----'
PRINTF,lun, '7) 0.0000      0          #     -----'
PRINTF,lun, '8) 0.0000      0          #     -----'
PRINTF,lun, '9) 0.843      1          #  Axis ratio (b/a)'
PRINTF,lun, '10) 0.2400     1          #  Position angle (PA) [deg: Up=0, Left=90]'
PRINTF,lun, '#C0) 0     1          #  Diskyness(-)/Boxyness(+)'
PRINTF,lun, 'Z) 0                      #  Skip this model in output image?  (yes=1, no=0)'
PRINTF,lun, ' '
PRINTF,lun, '# Component number: 2'
PRINTF,lun, '0) expdisk                #  Component type'
PRINTF,lun, '1) 25  25  1 1  #  Position x, y'
PRINTF,lun, '3) 21.0     1          #  Integrated magnitude'
PRINTF,lun, '4) 6.5157      1          #  R_s (disk scale-length)   [pix]'
PRINTF,lun, '5) 0.0000      0          #     -----'
PRINTF,lun, '6) 0.0000      0          #     -----'
PRINTF,lun, '7) 0.0000      0          #     -----'
PRINTF,lun, '8) 0.0000      0          #     -----'
PRINTF,lun, '9) 0.863      1          #  Axis ratio (b/a)'
PRINTF,lun, '10) 0.7506     1          #  Position angle (PA) [deg: Up=0, Left=90]'
PRINTF,lun, 'Z) 0                      #  Skip this model in output image?  (yes=1, no=0)'
PRINTF,lun, ' '
PRINTF,lun, '# Component number: 3'
PRINTF,lun, '0) sky                    #  Component type'
PRINTF,lun, '1) 0.7700         0       #  Sky background at center of fitting region [ADUs]'
PRINTF,lun, '2) 0.000e+00      1       #  dsky/dx (sky gradient in x)     [ADUs/pix]'
PRINTF,lun, '3) 0.000e+00      1       #  dsky/dy (sky gradient in y)     [ADUs/pix]'
PRINTF,lun, 'Z) 0                      #  Skip this model in output image?  (yes=1, no=0)'
PRINTF,lun, ' '
PRINTF,lun, '================================================================================'
; #################################################################

; Close the file and free the file unit
FREE_LUN, lun

; Give command to run GALFIT
command = './galfit '+galfitfile
SPAWN, command & PRINT, imagename, i


; Testing if GALFIT has created the output file.
; If not, print report to script's output file.
result = FILE_TEST('gal2_'+imagename)
  IF result NE 1 THEN BEGIN
    PRINT, 'File gal2_'+imagename+' has not been created.'
    PRINTF, lun2, 'No output image: ', imagename
  ENDIF

; --------------------------
ENDFOR
; --------------------------
;
; #################################################################
; #################################################################


; Print end date to script's output file.
PRINTF, lun2, '# '+SYSTIME()+' #'
endtime = SYSTIME() ; End time of the run.
PRINTF, lun2, '# Remember to update "fits.lis" after fitting these. #'


; Close the script's output file and free the file unit.
FREE_LUN, lun2

PRINT, 'Start: '+starttime
PRINT, 'Finish: '+endtime

; Give command to create a input file for script test_galfit.py
command2 = 'ls gal2_cut* > fits.lis'
SPAWN, command2 & PRINT, 'fits.lis file created'

END
